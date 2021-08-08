require "option_parser"
require "./commands/*"

# TODO
# - building instance of every command just to parse the opts

version = "0.1.0"

commands = [
  LsCommand.new,
  HeadCommand.new,
]

opt_parser = OptionParser.new do |parser|
  parser.banner = "crystal-busybox"


  commands.each do |cmd|
    cmd.setup_parser(parser)
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

commands.each do |cmd|
  if cmd.active
    cmd.run
  end
end
