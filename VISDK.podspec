
Pod::Spec.new do |s|
  s.name             = 'VISDK'
  s.version          = '1.5.1'
  s.summary          = 'Add in-app video advertisement with VISDK'

  s.description      = 'Add in-app video advertisement with VISDK. Use it carefully and enjoy.'

  s.homepage         = 'https://github.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'VISDK' => 'nl@vi.com' }
  s.source           = { :git => 'https://github.com/maksymkravchenko/vi.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

s.vendored_frameworks = 'VISDK/VISDK.framework'
s.source_files = 'VISDK/VISDK.framework/Headers/*.h'
s.public_header_files = 'VISDK/VISDK.framework/Headers/*.h'

end
