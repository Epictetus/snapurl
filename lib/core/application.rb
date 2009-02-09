=begin
* Name: SnapUrl
* Description:
*   This is a Ruby/RubyCocoa port of the webkit2png.py script by Paul Hammond
*   (http://www.paulhammond.org/webkit2png/) with some minor modifications.
* Author: Juris Galang (http://www.JurisGalang.com)
* Date: 09/15/08
* License:
=end
module SnapUrl
  class Application
    def Application::run(args)
      config = Application.parse(args)
      Camera::snap(config[:urls], config[:options])
    end

    # TODO: add option to control log-level
    # TODO: add implementation for verbose run
    # TODO: set --include-format = true if more than one format
    def Application::parse(args)
      options = Camera::DEFAULT_OPTIONS
      begin
        opts = OptionParser.new do |opts|
          opts.banner = <<-EOF
          Usage: #{opts.program_name} url0 [url1] [url2]... [options]

          #{opts.program_name} is a command line tool that creates PNG screenshots of webpages. 
          With tall or wide pages that would normally require scrolling, it takes
          screenshots of the whole webpage, not just the area that would be visible
          in a browser window.

          It is a Ruby/RubyCocoa port of the webkit2png.py script by Paul Hammond
          (http://www.paulhammond.org/webkit2png/)
          EOF
          opts.banner.gsub!(/  /, '')
          
          opts.separator ' '
          opts.separator 'Specific Options:'
          opts.on('--width [WIDTH]', Float, "initial and minimum browser width (default: #{options[:browser][:width].to_i})")     { |n| options[:browser][:width] = n }
          opts.on('--height [HEIGHT]', Float, "initial and minimum browser height (default: #{options[:browser][:height].to_i})") { |n| options[:browser][:height] = n }

          opts.separator ' '
          opts.on('--[no-]fullsize', "create fullsize screenshot")  { |n| n ? options[:snapFormat] << :fullsize  : options[:snapFormat].delete(:fullsize) }
          opts.on('--[no-]thumbnail', "create thumbnail")           { |n| n ? options[:snapFormat] << :thumbnail : options[:snapFormat].delete(:thumbnail) }
          opts.on('--[no-]clip', "create clip of thumbnail")        { |n| n ? options[:snapFormat] << :clip      : options[:snapFormat].delete(:clip) }

          opts.separator ' '
          opts.on('--scale [SCALE]', Float, "scale factor for thumbnails (default: #{options[:scaleFactor]})") { |n| options[:scaleFactor] = n }

          opts.separator ' '
          opts.on('--clipwidth [WIDTH]', Float, "width of clipped thumbnail (default: #{options[:clip][:width].to_i})")     { |n| options[:clip][:width] = n }
          opts.on('--clipheight [HEIGHT]', Float, "height of clipped thumbnail (default: #{options[:clip][:height].to_i})") { |n| options[:clip][:height] = n }

          opts.separator ' '
          opts.on('-f', '--filename [NAME]', "use NAME as part of filename (derived from url if not specified)") { |n| options[:filename] = n }
          
          opts.on('--use-md5hash', "use md5 hash for filename (overriden by --filename)") { |n| options[:useHashForFilename?] = n }
          opts.on('--include-datestamp', "include date in filename")                  { |n| options[:datestampInFilename?] = n }
          opts.on('--include-timestamp', "include time in filename")                  { |n| options[:timestampInFilename?] = n }
          opts.on('--include-size', "include image size in filename")                 { |n| options[:sizeInFilename?] = n }
          opts.on('--include-format', "include image format in filename")             { |n| options[:snapFormatInFilename?] = n }

          opts.separator ' '
          opts.on('-d', '--output-dir [DIRNAME]', "directory to place images into (default: #{options[:outputDirectory]})") { |n| options[:outputDirectory] = n }

          opts.separator ' '
          opts.separator 'Common Options:'
          opts.on('-v', "--[no-]verbose", "Run verbosely")  { |n| options[:verbose?] = n }
          opts.on_tail("-h", "--help", "Show this message") do
            puts opts.help
            exit
          end

          opts.on_tail("--version", "Show version") do
            puts opts.ver
            exit
          end   
        end

        urls = opts.permute!(args)

        raise OptionParser::MissingArgument.new('you need to supply at least one URL')                           if urls.empty?
        raise OptionParser::InvalidArgument.new('you can only use the filename option if there is only one URL') if (urls.size > 1) && !options[:filename].empty?
        raise OptionParser::InvalidArgument.new('scale cannot be zero')                                          if options[:scaleFactor] < 0.0
        # width and height cannot be zero or less than minimum
        # clipwidth and clipheight cannot be zero or less than minimum
        raise OptionParser::AmbiguousArgument.new('you need to allow at least one format')                       if options[:snapFormat].empty?

        return { :urls => urls, :options => options }
      rescue OptionParser::ParseError => e
        puts "#{e.message.capitalize}"
        exit(1)
      end
    end
  end
end
