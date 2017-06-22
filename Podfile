# Uncomment this line to define a global platform for your project
 platform :ios, '8.0'

target 'GoOut Restauracje' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!


    pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end

    pod 'SwiftyJSON', '3.0.0'
    pod 'FCUUID', '~> 1.2.0'
    pod 'PKHUD', :git => 'https://github.com/toyship/PKHUD.git'
    pod 'GoogleMaps', '~> 2.0.1'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Kingfisher', '~> 3.0'
    pod 'BRYXBanner', '~> 0.7.1'
  # Pods for GoOut Restauracje

end
