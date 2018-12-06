

Pod::Spec.new do |s|

s.name         = "WLBaseTableView"
s.version      = "1.2.0"
s.summary      = "A Lib For tableview."
s.description  = <<-DESC
A Lib For tableView with MJRefresh.
DESC

s.homepage     = "https://github.com/StoneStoneStoneWang/WLBaseTableView"
s.license      = { :type => "MIT", :file => "LICENSE.md" }
s.author             = { "StoneStoneStoneWang" => "yuanxingfu1314@163.com" }
s.platform     = :ios, "9.0"
s.ios.deployment_target = "9.0"

s.swift_version = '4.2'

s.frameworks = 'UIKit', 'Foundation'

s.source = { :git => "https://github.com/StoneStoneStoneWang/WLBaseTableView.git", :tag => "#{s.version}" }

s.source_files = "Code/**/*.{swift}"

s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

s.static_framework = true

s.dependency 'WLToolsKit'

s.dependency 'MJRefresh'

end




