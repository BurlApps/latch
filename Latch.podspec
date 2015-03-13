Pod::Spec.new do |s|
  s.name         = "Latch"
  s.version      = "0.0.7"
  s.summary      = "Easily use Passcode and Touch ID authentication!"

  s.description  = <<-DESC
                    Hackathon: Producthunt Hackathon

                    Date: November 25, 2014

                    Placed: N/A

                    Coding Time: 12 hours

                    Team Members: 2

                    Description: Easily use Passcode and Touch ID authentication!
                   DESC

  s.homepage     = "https://github.com/SooJuicy/Latch"
  s.license      = { :type => "GNU", :file => "LICENSE" }
  s.author             = { "Brian Vallelunga" => "vallelungabrian@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/SooJuicy/Latch.git", :tag => s.version }
  s.source_files  = "Framework/*.swift"
  s.resources = "Framework/*.png", "Framework/*.{xib}", "Framework/*.lproj"
  s.requires_arc = true
end
