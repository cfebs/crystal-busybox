require "./base_command"

private class Opts
  property long, all
  def initialize(
    @long : Bool = false,
    @all : Bool = false,
  )
  end
end

class LsCommand
  include BaseCommand

  @@name = "ls"

  def initialize
    @active = false

    @options = Opts.new
  end

  def setup_parser(parser : OptionParser)
    parser.on(@@name, "list directory contents") do
      @active = true
      parser.on("-l", "use a long listing format") do
        @options.long = true
      end

      parser.on("-a", "do not ignore entries starting with .") do
        @options.all = true
      end
    end
  end

  def run
    cur = Dir.new(Dir.current)
    cur.entries.sort.each do |ent|
      is_dot = ent.starts_with?('.')

      # if not -a, skip dots
      if is_dot && !@options.all
        next
      end

      puts ent
    end
  end
end
