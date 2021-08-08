private class Opts
end

class LsCommand
  @@NAME = "ls"

  # setup_parser
  def initialize
    @options = {
      :long => false,
      :all  => false,
    }
  end

  def setup_parser(parser : OptionParser)
    parser.on(@@NAME, "list directory contents") do
      parser.on("-l", "use a long listing format") do
        @options[:long] = true
      end

      parser.on("-a", "do not ignore entries starting with .") do
        @options[:all] = true
      end
    end
  end

  def run
    cur = Dir.new(Dir.current)
    cur.entries.each do |ent|
      is_dot = ent.starts_with?('.')

      # if not all, skip dots
      if is_dot && !@options[:all]
        next
      end

      puts ent
    end
  end
end
