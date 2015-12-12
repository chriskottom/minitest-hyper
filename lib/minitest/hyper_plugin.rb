require "minitest"

require "minitest/hyper/reporter"
require "minitest/hyper/report"

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
    GEM_DIR       = File.join(File.dirname(__FILE__), "../..")
    WORKING_DIR   = Dir.pwd

    REPORTS_DIR   = File.join(WORKING_DIR, "test/reports/hyper")
    REPORT_FILE   = File.join(REPORTS_DIR, "index.html")

    TEMPLATE_DIR  = File.join(GEM_DIR, "lib/templates")
    CSS_TEMPLATE  = File.join(TEMPLATE_DIR, "hyper.css")
    HTML_TEMPLATE = File.join(TEMPLATE_DIR, "index.html.erb")
    
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
