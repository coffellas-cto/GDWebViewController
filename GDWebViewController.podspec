
Pod::Spec.new do |s|
  s.name              = "GDWebViewController"
  s.version           = "1.5.3"
  s.summary           = "WKWebview browser view controller in Swift"

  s.description       = <<-DESC
                      A simple view controller for navigating web pages using WKWebView. iOS 8.1+.
                      Supports Swift 4.0 and iOS 11 SDK.
                      DESC

  s.homepage          = "https://github.com/coffellas-cto/GDWebViewController"
  s.screenshots       = "https://cloud.githubusercontent.com/assets/3193877/7665617/29a8672a-fbc9-11e4-98cf-41fec0f6c403.gif"

  s.license           = { :type => "MIT", :file => "LICENSE" }

  s.author            = { "coffellas-cto" => "coffellas-cto@coffellas-cto.com" }
  s.swift_version = '4.0'
  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/pikachu987/GDWebViewController.git", :tag => s.version }

  s.source_files      = "GDWebViewController/*"
end
