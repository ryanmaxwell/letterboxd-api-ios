Pod::Spec.new do |s|
  s.name         = "LetterboxdRequestSigning"
  s.version      = "0.1"
  s.summary      = "Convenience methods for signing Letterboxd API requests"
  s.description  = <<-DESC
  Encapsulates the logic required to sign requests when using the Letterboxd API, as an extension on URLRequest for Swift, and a category on NSMutableURLRequest for Objective-C.
                   DESC
  s.homepage     = "https://letterboxd.com"
  s.license      = "MIT"
  s.author       = { "Ryan Maxwell" => "ryan@cactuslab.com" }
  
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  
  s.source       = { :git => "https://github.com/ryanmaxwell/letterboxd-api-ios.git", :tag => "#{s.version}" }
  s.source_files = "Classes"
  s.requires_arc = true
end
