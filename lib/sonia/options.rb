require "optiflag"

module Options
  extend OptiFlagSet

  flag "config"

  and_process!
end
