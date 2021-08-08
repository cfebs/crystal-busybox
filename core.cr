require "option_parser"

version = "0.1.0"

require "./commands/*"

active_cmd = nil

opt_parser = OptionParser.new do |parser|
  parser.banner = "crystal-busybox"

  commands = [
    LsCommand.new,
    HeadCommand.new,
  ]

  commands.each do |cmd|
    active = cmd.setup_parser(parser)
    if active
      active_cmd = cmd
    end
  end

  parser.on "-v", "--version", "Show version" do
    puts version
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

opt_parser.parse

if active_cmd
  active_cmd.run
end
