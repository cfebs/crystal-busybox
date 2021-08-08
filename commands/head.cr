require "./base_command"
# TODO spacing between files when headers are on
# TODO buffered byte reading, just using each_byte now. print statement flushes every byte

private class Opts
  property files, num_lines, num_bytes, verbose, quiet

  def initialize(
    @files : Array(String) = [] of String,
    @num_lines : Int32 = 10,
    @num_bytes : Int32? = 0,
    @verbose : Bool = false,
    @quiet : Bool = false
  )
  end
end

class HeadCommand
  include BaseCommand

  @@name = "head"

  # setup_parser
  def initialize
    @options = Opts.new
    @active = false
  end

  def setup_parser(parser : OptionParser) Bool
    parser.on(@@name, "output the first part of files") do
      @active = true
      parser.on("-n", "--lines=NUM", "print  the  first  NUM lines instead of the first 10; with the leading '-', print all but the last NUM lines of each file") do |num|
        @options.num_lines = num.to_i
      end

      parser.on("-c", "--bytes=NUM", "print the first NUM bytes of each file; with the leading '-', print all but the last NUM bytes of each file") do |num|
        num_i = num.to_i?
        if num_i == nil
          raise "Invalid bytes number"
        end
        @options.num_bytes = num.to_i
      end

      parser.on("-q", "--quiet", "never print headers giving file names") do
        @options.quiet = true
      end

      parser.on("-v", "--verbose", "always print headers giving file names") do
        @options.verbose = true
      end

      parser.unknown_args do |args|
        @options.files = args
      end
    end
  end

  def run
    show_headers = @options.files.size > 1
    if @options.quiet
      show_headers = false
    elsif @options.verbose
      show_headers = true
    end

    @options.files.each do |fname|
      if show_headers
        STDOUT.puts "==> #{fname} <=="
      end

      if File.directory?(fname)
        puts ""
        next
      end

      num_bytes = @options.num_bytes
      if !num_bytes.nil?
        byte_num = 0
        file = File.new(fname)
        file.each_byte do |b|
          byte_num += 1
          print String.new(Slice.new(1, b))

          if byte_num > num_bytes
            break
          end
        end

        return
      end

      line_num = 0
      File.each_line(fname) do |line|
        line_num += 1
        STDOUT.puts line

        if line_num > @options.num_lines
          break
        end
      end
    end
  end
end
