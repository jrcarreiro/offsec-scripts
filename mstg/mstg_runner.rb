#!/usr/bin/env ruby

require 'json'
require 'time'
require 'fileutils'

MSTG_TESTS_DIR = File.expand_path(File.join(__dir__, 'static/masvs-storage'))
REPORTS_DIR = File.expand_path(File.join(__dir__, 'reports'))
LOGS_DIR = File.join(REPORTS_DIR, 'logs')
TIMESTAMP = Time.now.utc.strftime('%Y%m%d-%H%M%S')

FileUtils.mkdir_p(LOGS_DIR)

def log(message)
  timestamp = Time.now.utc.iso8601
  puts "[#{timestamp}] #{message}"
  File.open(File.join(LOGS_DIR, "runner-#{TIMESTAMP}.log"), 'a') do |file|
    file.puts("[#{timestamp}] #{message}")
  end
end

def run_test(script_path, app_path)
  output = `ruby #{script_path} #{app_path} 2>&1`
  { script: File.basename(script_path), result: output.strip }
end

def run_all_tests(app_path)
  results = []
  Dir.glob(File.join(MSTG_TESTS_DIR, '*.rb')).sort.each do |test_script|
    log("Running #{File.basename(test_script)}...")
    result = run_test(test_script, app_path)
    results << result
  end
  results
end

def parse_grouped_output(raw_output)
  grouped = Hash.new { |h, k| h[k] = [] }

  raw_output.each_line do |line|
    if match = line.match(/Pattern match \[(.+?)\] in: (.+)/)
      keyword, file = match[1], match[2]
      grouped[keyword] << file
    end
  end

  grouped
end

def generate_report(results)
  json_path = File.join(REPORTS_DIR, "report-#{TIMESTAMP}.json")
  markdown_path = File.join(REPORTS_DIR, "report-#{TIMESTAMP}.md")

  json_output = []

  # Markdown output
  md = "# MSTG Automation Report\n\nGenerated at #{Time.now.utc}\n\n"

  results.each do |res|
    md += "## #{res[:script]}\n\n"
    grouped = parse_grouped_output(res[:result])
    grouped.each do |pattern, files|
      md += "### Pattern match [#{pattern}]\n"
      files.each { |file| md += "- #{file}\n" }
      md += "\n"
    end
    json_output << { script: res[:script], grouped_results: grouped }
  end

  File.write(json_path, JSON.pretty_generate(json_output))
  File.write(markdown_path, md)

  log("✅ Reports saved: \n- #{json_path}\n- #{markdown_path}")
end

# MAIN
if ARGV.empty?
  puts "Usage: ruby #{__FILE__} /path/to/unzipped/ipa/Payload/AppName.app"
  exit 1
end

app_path = ARGV[0]
log("📦 Starting MSTG batch test for app path: #{app_path}")
results = run_all_tests(app_path)
generate_report(results)
log("🏁 Finished MSTG batch test.")
