#!/usr/bin/env ruby

# MSTG-STORAGE-1: Verify that no sensitive data is stored unprotected
# This script checks the extracted IPA contents for sensitive files or insecure data storage
# using external keywords/regex from 'keywords.txt'.

require 'find'

KEYWORDS_FILE = File.expand_path(File.join(__dir__, 'keywords.txt'))

def load_patterns
  File.readlines(KEYWORDS_FILE)
      .map(&:strip)
      .reject { |line| line.empty? || line.start_with?('#') }
      .map { |pattern| Regexp.new(pattern, Regexp::IGNORECASE) }
end

def check_unprotected_storage(ipa_extract_path)
  issues = []
  patterns = load_patterns

  Find.find(ipa_extract_path) do |path|
    patterns.each do |regex|
      if regex.match?(path)
        issues << "⚠️ Pattern match [#{regex.source}] in: #{path}"
        break
      end
    end
  end

  if issues.empty?
    puts "✅ No unprotected sensitive data found."
  else
    puts "🔍 Potential issues found:"
    issues.each { |i| puts i }
  end
end

# Example usage:
# ruby mstg-storage-1.rb /path/to/unzipped/ipa/Payload/AppName.app

if ARGV.empty?
  puts "Usage: ruby #{__FILE__} /path/to/extracted/ipa"
  exit 1
else
  check_unprotected_storage(ARGV[0])
end
