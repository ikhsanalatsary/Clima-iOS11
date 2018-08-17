# Clima
Learn to make iOS Apps with [The App Brewery](https://www.appbrewery.co) 📱 | Project Stub | (Swift 4.0/Xcode 9) - Clima App

Beginner: Download the starter project files as .zip and extract the files to your desktop.

Pro: Git clone to your Xcode projects folder.

## Finished App
<img src="https://github.com/ikhsanalatsary/Clima-iOS11/raw/master/output.gif" width="267" alt="Finished App" title="Demo Clima App" style="max-width:30%;">

## Fix for Cocoapods v1.0.1 and below

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end
```

## Fix for App Transport Security Override

```XML
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>openweathermap.org</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
			</dict>
		</dict>
	</dict>
```


Copyright © The App Brewery

