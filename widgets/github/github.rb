require 'json'

module Sonia
  module Widgets
    class Github < Sonia::Widget
      REPOSITIORIES_URL      = "https://api.github.com/users/%s/repos"
      NETWORK_META_URL       = "%s://github.com/%s/%s/network_meta"
      NETWORK_DATA_CHUNK_URL = "%s://github.com/%s/%s/network_data_chunk?nethash=%s"

      def initialize(config)
        super(config)

        @repositories = []
        @nethashes    = []
        EventMachine::add_periodic_timer(60 * 5) { fetch_data }
      end

      def initial_push
        fetch_data
      end

      private
      def fetch_data
        fetch_repositories do
          fetch_nethashes do
            fetch_commits
          end
        end
      end

      def fetch_repositories(&blk)
        log_info "Polling `#{repositories_url}'"
        http = EventMachine::HttpRequest.new(repositories_url).get(auth_data)
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_repositories_response(http)
          blk.call
        }
      end

      def handle_repositories_response(http)
        if http.response_header.status == 200
          @repositories = parse_json(http.response)
        else
          log_unsuccessful_response_body(http.response)
        end
      rescue => e
        log_backtrace(e)
      end

      def fetch_nethashes(&blk)
        multi = EventMachine::MultiRequest.new
        @repositories.each do |repo|
          url = network_meta_url(repo['name'])
          log_info "Polling `#{url}'"
          multi.add(repo['name'], EventMachine::HttpRequest.new(url).get(auth_data))
        end
        multi.errback { log_fatal_error(multi) }
        multi.callback {
          handle_nethashes_response(multi)
          blk.call
        }
      end

      def handle_nethashes_response(multi)
        @nethashes = multi.responses[:callback].map do |response|
          begin
            if response[1].response_header.status == 200
              payload = parse_json(response[1].response)
              nethash = payload["nethash"]
              repo    = payload["users"].first["repo"]
              { :repo => repo, :nethash => nethash }
            else
              log_unsuccessful_response_body(response[1].response)
              nil
            end
          rescue => e
            log_backtrace(e)
            nil
          end
        end.compact
      rescue => e
        log_backtrace(e)
      end

      def fetch_commits
        multi = EventMachine::MultiRequest.new
        @nethashes.each do |nethash|
          url = network_data_chunk_url(nethash[:repo], nethash[:nethash])
          log_info "Polling `#{url}'"
          multi.add(nethash[:repo], EventMachine::HttpRequest.new(url).get(auth_data))
        end
        multi.errback { log_fatal_error(multi) }
        multi.callback {
          handle_commits_response(multi)
        }
      end

      def handle_commits_response(multi)
        require 'pp'
        commits = multi.responses[:callback].map do |response|
          begin
            nethash = response[1].req.uri.query.split("nethash=").last
            repo = repo_name_for_nethash(nethash)
            commits = parse_json(response[1].response)["commits"].map { |commit|
              commit["repository"] = repo
              commit
            }
          rescue => e
            log_backtrace(e)
          end
        end.flatten.compact.sort_by { |e| Time.parse(e["date"]) }.reverse[0...config.nitems]

        push commits
      rescue => e
        log_backtrace(e)
      end

      def auth_data
        { :query => { "login" => config.username, "token" => config.token }}
      end

      def repositories_url
        REPOSITIORIES_URL % config.username
      end

      def network_meta_url(repo)
        repository = repo(repo)
        NETWORK_META_URL % ['https', config.username, repo]
      end

      def network_data_chunk_url(repo, nethash)
        repository = repo(repo)
        is_private = 'https'
        NETWORK_DATA_CHUNK_URL % [is_private, config.username, repo, nethash]
      end

      def repo(repo)
        @repositories.detect { |r| r['name'] == repo }
      end

      def repo_name_for_nethash(nethash)
        repo(@nethashes.detect { |r| r[:nethash] == nethash }[:repo])
      end
    end
  end
end
