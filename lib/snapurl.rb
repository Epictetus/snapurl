=begin
* Name: SnapUrl
* Description:
*   This is a Ruby/RubyCocoa port of the webkit2png.py script by Paul Hammond
*   (http://www.paulhammond.org/webkit2png/) with some minor modifications.
* Author: Juris Galang (http://www.JurisGalang.com)
* Date: 09/15/08
* License:
=end
require 'digest/md5'
require 'fileutils'
require 'logger'
require 'optparse'
require 'ostruct'

require 'osx/cocoa'
OSX.require_framework 'WebKit'

require 'core/camera'
require 'core/application'

Version = "0.0.2"
Release = "alpha"

module SnapUrl
  VERSION = Version
end
