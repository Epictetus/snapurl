= snapurl

* http://www.jurisgalang.com/articles/show/SnapUrl

== DESCRIPTION:

This is a Ruby/RubyCocoa port of the webkit2png.py script by Paul Hammond
(http://www.paulhammond.org/webkit2png/) with some minor modifications.

== FEATURES/PROBLEMS:

* OS X only. 
* Requires RubyCocoa (Leopard will already have this installed)
* Requires Ruby 1.8.7 (Ruby 1.9.x wont play with RubyCocoa)

== SYNOPSIS:

   Just pass a list of URLs to the snapurl script and it will take a snapshot of the pages found in those URLs:

   $ snapurl http://artists.gawker.com/                  # takes a snapshot of gawker artists
   $ snapurl http://io9.com/ http://artists.gawker.com/  # ... and io9 websites.

   By default snapurl generates a set of files per URL that it processes: thumbnail, clipped, and full sized 
   view of the web pages in PNG format. 

== REQUIREMENTS:

* OS X
* Ruby 1.8.7
* RubyCocoa 

== BUILD AND INSTALL:

* sudo rake install_cocoa
* rake package
* sudo gem install pkg/snapurl-0.0.2.gem

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
