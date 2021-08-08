private class Opts
    property files, num_lines,verbose, quiet
    def initialize(
        @files : Array(String) = [] of String,
        @num_lines : Int32 = 10,
        @verbose : Bool = false,
        @quiet : Bool = false,
    )
    end
end

class HeadCommand
    @@NAME = "head"

    # setup_parser
    def initialize()
        @options = Opts.new
    end

    def setup_parser(parser : OptionParser)
        parser.on(@@NAME, "output the first part of files") do
            parser.on("-n", "--lines=NUM", "print  the  first  NUM lines instead of the first 10; with the leading '-', print all but the last NUM lines of each file") do |num|
                @options.num_lines = num.to_i
            end

            parser.on("-q", "--quiet", "never print headers giving file names") do |num|
                @options.quiet = true
            end

            parser.on("-v", "--verbose", "always print headers giving file names") do |num|
                @options.verbose = true
            end

            parser.unknown_args do |args|
                @options.files = args
            end
        end
    end

    def run()
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
                # TODO get spacing correct
                puts ""
                next
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
