require "minitest"

require "minitest/hyper/reporter"

module Minitest
  # Mandatory Minitest initializer hook
  # Detected by Minitest.load_plugins, invoked during Minitest.init_plugins
  def self.plugin_hyper_init(options)
    if Hyper.enabled?
      reporter.reporters << Hyper::Reporter.new(options[:io], options)
    end
  end

  # Optional hook for command line params handling
  # Invoked by Minitest.process_args
  def self.plugin_hyper_options(opts, options)
    description = "Generate an HTML test report with Minitest::Hyper"
    opts.on "-H", "--html", description do
      Hyper.enable!
    end
  end

  module Hyper
    VERSION = "0.1.0"

    @@enabled = false
    
    def self.enabled?
      @@enabled
    end

    def self.enable!
      @@enabled = true
    end
  end
end
