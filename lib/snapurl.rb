=begin
* Name:
* Description   
* Author:
* Date:
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

Version = "0.0.1"
Release = "alpha"

module SnapUrl
  VERSION = Version
end
