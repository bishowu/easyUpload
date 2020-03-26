Pod::Spec.new do |spec|
  spec.name         = 'TUSKit'
  spec.version      = '1.4.2'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://tus.io/'
  spec.authors      = { 'tus - Resumable File Uploads' => 'email@address.com' }
  spec.summary      = 'The tus client for iOS.'
  spec.source       = { :git => 'https://github.com/tus/TUSKit.git', :tag => '#{s.version}' }
  spec.source_files  = "Supporting Files/*.{h,m}", "TUSKit/*.{h,m}"
end