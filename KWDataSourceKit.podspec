Pod::Spec.new do |s|
  s.name = 'KWDataSourceKit'
  s.version = '0.3.1'
  s.summary = 'UITableView and UICollectionView DataSources enabling light view controllers'
  s.homepage = 'https://github.com/kupferwerk'
  s.authors = { 'Kupferwerk GmbH' => 'mathias.nagler@kupferwerk.com' }
  s.source = { :git => 'https://github.com/kupferwerk/KWDataSourceKit.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'KWDataSourceKit/*.swift'

  s.requires_arc = true
end
