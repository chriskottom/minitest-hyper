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

    TEMPLATE_DIR  = File.join(GEM_DIR, "lib/templates")
    CSS_TEMPLATE  = File.join(TEMPLATE_DIR, "hyper.css")
    HTML_TEMPLATE = File.join(TEMPLATE_DIR, "index.html.erb")

    VERSION = "0.2.0"

    @@enabled = false

    def self.enabled?
      @@enabled
    end

    def self.enable!
      @@enabled = true
    end

    def self.report_dirname
      project_root = if defined?(Rails) && defined?(Rails.root)
                       Rails.root
                     else
                       Dir.pwd
                     end

      if Dir.exist?(File.join(project_root, "spec"))
        File.join(project_root, "spec/reports/hyper")
      else
        File.join(project_root, "test/reports/hyper")
      end
    end

    def self.report_filename
      File.join(report_dirname, "index.html")
    end
  end
end
