require 'roxml'
module Sonia
  module Widgets
    # ROXML classes doesn't include all stuff that Hoptoad returns
    # since we dont need it : we already have the api key and we
    # only need to count the total of errors for each projects
    # ROXML Projects class
    class Project
      include ROXML
      xml_accessor :id
      xml_accessor :name
    end
    class Projects
      include ROXML
      xml_accessor :projects, :as => [Project]
    end

    # ROXML Errors class
    class Group
      include ROXML
      xml_accessor :project_id, :from => "@project-id"
      xml_accessor :resolved
    end

    class Groups
      include ROXML
      xml_accessor :groups, :as => [Group]
    end

    class Hoptoad < Sonia::Widget
      PROJECTS_URL       = "http://%s.hoptoadapp.com/projects.xml?auth_token=%s" # SSL redirecto to non-ssl url
      PROJECT_ERRORS_URL = "http://%s.hoptoadapp.com/errors.xml?auth_token=%s&project_id=%s" # same

      def initialize(config)
        super(config)

        @projects = []
        EventMachine::add_periodic_timer(60 * 5) { fetch_data }
      end

      def initial_push
        fetch_data
      end

      private
      def fetch_data
        fetch_projects do
          fetch_errors
        end
      end

      def fetch_projects(&blk)
        log_info "Polling `#{projects_url}'"
        http = EventMachine::HttpRequest.new(projects_url).get
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_projects_response(http)
          blk.call
        }
      end

      def handle_projects_response(http)
        if http.response_header.status == 200
          @projects = Projects.from_xml(http.response).projects.map { |p| { :id => p.id, :name => p.name } }
        else
          log_unsuccessful_response_body(http.response)
        end
      rescue => e
        log_backtrace(e)
      end

      def fetch_errors
        multi = EventMachine::MultiRequest.new
        @projects.each do |project|
          url = project_errors_url(project[:id])
          log_info "Polling `#{url}'"
          multi.add(EventMachine::HttpRequest.new(url).get)
        end
        multi.errback { log_fatal_error(multi) }
        multi.callback {
          handle_errors_response(multi)
        }
      end

      def handle_errors_response(multi)
        errors = multi.responses[:succeeded].map do |response|
          begin
            error_p_id = response.instance_variable_get(:@uri).query.split("project_id=").last
            project = project(error_p_id)
            project[:errors] = Groups.from_xml(response.response).groups.size
            project
          rescue => e
            log_backtrace(e)
          end
        end

        push errors
      rescue => e
        log_backtrace(e)
      end


      def projects_url
        PROJECTS_URL % [config.account, config.auth_key]
      end
      def project_errors_url(project_id)
        PROJECT_ERRORS_URL % [config.account, config.auth_key, project_id]
      end

      def project(project_id)
        @projects.detect { |r| r[:id] == project_id }
      end

    end
  end
end
