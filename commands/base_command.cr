# https://github.com/crystal-lang/crystal/issues/3489#issuecomment-257185615
module BaseCommand
  getter active
  @active : Bool
  abstract def setup_parser(parser : OptionParser)
  abstract def run
end
