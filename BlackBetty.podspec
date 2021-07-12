Pod::Spec.new do |spec|
  spec.name = "BlackBetty"
  spec.version = "0.0.1"
  spec.summary = "BlackBetty"
  spec.homepage = "https://github.com/shsanek/BlackBetty"

  spec.license = { 
    type: 'Apache-2.0 License',
  }

  spec.author = { "Alexander Shipin" => "ssanek212@gmail.com" }
  spec.source = { :git => "https://github.com/shsanek/BlackBetty" }
  
  spec.prefix_header_file = false
  spec.ios.deployment_target = '11.0'
  spec.swift_version = '5.3'
  
  spec.source_files = 'Sources/**/*.{swift}'
end
