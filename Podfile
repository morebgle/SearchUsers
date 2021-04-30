# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GithubUser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'RxDataSources', '~> 4.0'
  pod 'Alamofire', '~> 5.2'
  pod 'SDWebImage', '~> 5.0'
  pod "TPKeyboardAvoidingSwift"
  
  # Pods for GithubUser

  target 'GithubUserTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 5.0'
    pod 'RxTest', '~> 5.0'
  end

  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
      end
    end
end
