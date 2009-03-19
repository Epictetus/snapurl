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
  module Camera
    DEFAULT_OPTIONS = {
      :browser               => {:width => 800.0, :height => 600.0},
      :clip                  => {:width => 200.0, :height => 150.0},
      :snapFormat            => [:fullsize, :thumbnail, :clip],
      :scaleFactor           => 0.25,
      :filename              => '',
      :datestampInFilename?  => false,
      :timestampInFilename?  => false,
      :sizeInFilename?       => false, 
      :snapFormatInFilename? => false,
      :useHashForFilename?   => false,
      :outputDirectory       => Dir.pwd,
      :verbose?              => false
    }

    def Camera::snap(urls, options = {})
      # create context
      OSX::NSApplication.sharedApplication

      # create an app delegate
      delegate = AppDelegate.alloc.init
      OSX::NSApp.setDelegate(delegate)

      # create a webview object
      rect    = OSX::NSMakeRect(-16000, -16000, 100, 100)
      webview = OSX::WebView.alloc.initWithFrame(rect) 
      webview.setMediaStyle('screen')
      webview.mainFrame.frameView.setAllowsScrolling(false)

      # make sure we don't save any of the prefs that we change.
      webview.preferences.setAutosaves(false)
      webview.preferences.setShouldPrintBackgrounds(true)
      webview.preferences.setJavaScriptCanOpenWindowsAutomatically(false)
      webview.preferences.setAllowsAnimatedImages(false)

      # create a window and set view
      win = OSX::NSWindow.alloc
      win.initWithContentRect_styleMask_backing_defer(rect, OSX::NSBorderlessWindowMask, OSX::NSBackingStoreBuffered, false)
      win.setContentView(webview)

      # create load delegate
      loader         = LoadDelegate.alloc.init
      loader.urls    = urls
      loader.options = DEFAULT_OPTIONS.merge(options)
      webview.setFrameLoadDelegate(loader)

      # now run
      OSX::NSApp.run
    end

    class AppDelegate < OSX::NSObject
      def applicationDidFinishLaunching(aNotification)
        webview = aNotification.object.windows.objectAtIndex(0).contentView
        webview.frameLoadDelegate.fetchUrl(webview) 
      end
    end

    class LoadDelegate < OSX::NSObject
      attr_accessor :options, :urls, :logger

      def urls=(urls)
        @urls = urls.to_a
      end
    
      def options=(options)
        # adjust configs
        options[:snapFormatInFilename?] = true if (options[:snapFormat].size > 1) && !options[:snapFormatInFilename?]
      
        w = options[:clip][:width]  / options[:scaleFactor]
        h = options[:clip][:height] / options[:scaleFactor]
        options[:browser][:width]  = w unless w < options[:browser][:width]
        options[:browser][:height] = h unless h < options[:browser][:height]

        @options = options
      end
    
      def init
        @logger = Logger.new(STDOUT)
        self
      end

      def webView_didFailLoadWithError_forFrame(webview, error, frame)
        @logger.warn "#{error.localizedDescription}"
        fetchUrl(webview)
      end

      def webView_didFailProvisionalLoadWithError_forFrame(webview, error, frame)
        @logger.warn "#{error.localizedDescription}" 
        fetchUrl(webview)
      end

      def webView_didFinishLoadForFrame(webview, frame)
        # don't care about subframes
        return unless (frame == webview.mainFrame)
        docview = frame.frameView.documentView
        resizeWebView(docview)
      
        @logger.info "Capturing..." 
        url = frame.dataSource.initialRequest.URL.absoluteString
        bitmap = captureView(docview)  
        saveImages(url, bitmap)

        @logger.info "Done!" 
        fetchUrl(webview)
      end

      def resetWebView(view)
        rect = OSX::NSMakeRect(0, 0, browser[:width], browser[:height])
        view.window.setContentSize([browser[:width], browser[:height]])
        view.setFrame(rect)
      end

      def resizeWebView(view)
        view.setNeedsDisplay(true)
        view.displayIfNeeded
        view.window.setContentSize(view.bounds.size)
        view.setFrame(view.bounds)
      end

      def captureView(view)
        view.lockFocus
        bitmap = OSX::NSBitmapImageRep.alloc
        bitmap.initWithFocusedViewRect(view.bounds)
        view.unlockFocus
        bitmap
      end

      def fetchUrl(webview)
        OSX::NSApplication.sharedApplication.terminate(self) if @urls.empty? 

        url = @urls.shift
	url = url.gsub(/^/, "http:\/\/") unless url =~ /^http:\/\//
        @logger.info "Fetching #{url}..." 

        resetWebView(webview)
        webview.mainFrame.loadRequest(OSX::NSURLRequest.requestWithURL(OSX::NSURL.URLWithString(url)))

        return if webview.mainFrame.provisionalDataSource

        fetchUrl(webview)
      end

      def makeFilename(url, bitmap, format)
        if !filename.empty?
          name = filename

        elsif useHashForFilename?
          name = Digest::MD5.new.hexdigest(url)

        else
          name = String.new(url)
          name.gsub!(/\W/, '');
          name.gsub!(/^http(s)?/i, '');
          name.gsub!(/\//, '.');
        end

        name = "#{Time.now.strftime('%H%M%S')}-#{name}"            if timestampInFilename?
        name = "#{Time.now.strftime('%Y%m%d')}-#{name}"            if datestampInFilename?
        name = "#{name}-#{bitmap.pixelsWide}x#{bitmap.pixelsHigh}" if sizeInFilename?
        name = "#{name}-#{format}"                                 if snapFormatInFilename?
      
        name = "#{name}.png"

        name = File.join(File.expand_path(outputDirectory), name)  unless outputDirectory.empty?
        name
      end

      def saveImages(url, bitmap)
        writeToFile(url, bitmap, :fullsize) if snapFormat.include?(:fullsize)
      
        if snapFormat.include?(:thumbnail) || snapFormat.include?(:clip)
          # work out how big the thumbnail is
          thumbWidth  = bitmap.pixelsWide * scaleFactor
          thumbHeight = bitmap.pixelsHigh * scaleFactor

          # make the thumbnails in a scratch image
          scratch = OSX::NSImage.alloc.initWithSize(OSX::NSMakeSize(thumbWidth, thumbHeight))
          scratch.lockFocus
          OSX::NSGraphicsContext.currentContext.setImageInterpolation(OSX::NSImageInterpolationHigh)
          thumbRect = OSX::NSMakeRect(0.0, 0.0, thumbWidth, thumbHeight)
          clipRect  = OSX::NSMakeRect(0.0, thumbHeight - clip[:height], clip[:width], clip[:height])
          bitmap.drawInRect(thumbRect)
          thumbnail = OSX::NSBitmapImageRep.alloc.initWithFocusedViewRect(thumbRect)
          clipping  = OSX::NSBitmapImageRep.alloc.initWithFocusedViewRect(clipRect)
          scratch.unlockFocus

          # save the thumbnails as pngs 
          writeToFile(url, thumbnail, :thumbnail) if snapFormat.include?(:thumbnail)
          writeToFile(url, clipping, :clip)   if snapFormat.include?(:clip)
        end
      end
  
      def writeToFile(url, bitmap, format) 
        name = makeFilename(url, bitmap, format)
        FileUtils.mkdir_p File.dirname(name)
        bitmap.representationUsingType_properties(OSX::NSPNGFileType, nil).writeToFile_atomically(name, true) 
      end
    
      def method_missing(name, *args)
        if args.empty?
          k = name.to_sym
          super(name, args) unless @options.keys.include?(k)
          return @options[k]
        end
        super(name, args)
      end
    end
  end
end
