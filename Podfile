# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FleetGuard_Mechanic' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FleetGuard_Mechanic

  target 'FleetGuard_MechanicTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FleetGuard_MechanicUITests' do
    # Pods for testing
  end

pod 'SlideMenuControllerSwift'
pod 'IQKeyboardManagerSwift'
pod 'Alamofire', '~> 4.0'
pod 'lottie-ios'
pod 'Toast-Swift', '~> 5.0.1'
pod "ImageSlideshow/Alamofire"
pod 'DPOTPView'
pod 'Kingfisher', '~> 7.0'
pod 'LanguageManager-iOS'
pod 'Charts'


end


 post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
         end
     end
  end
