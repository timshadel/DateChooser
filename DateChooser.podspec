Pod::Spec.new do |spec|

  spec.name         = "DateChooser"
  spec.version      = "2.2"
  spec.summary      = "A simple framework with a view controller for choosing the date and time"
  spec.description  = "A simple framework with a view controller for choosing the date and time."

  spec.homepage     = "https://github.com/benjaminsnorris/DateChooser"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Ben Norris" => "code@bsn.design" }
  spec.social_media_url   = "https://twitter.com/bsndesign"

  spec.platform      = :ios, "9.0"
  spec.swift_version = '4.0'
  
  spec.source        = { :git => "https://github.com/benjaminsnorris/DateChooser.git", :tag => "v#{spec.version}" }
  spec.source_files  = "DateChooser"
  spec.resources     = "DateChooser/Base.lproj/*.storyboard"

end
