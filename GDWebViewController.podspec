
Pod::Spec.new do |s|
  s.name              = "GDWebViewController"
  s.version           = "1.3.0"
  s.summary           = "WKWebview browser view controller in Swift"

  s.description       = <<-DESC
                      A simple view controller for navigating web pages using WKWebView. iOS 8.1+.
                      Supports Swift 2.0 and iOS 9 SDK.
                      DESC

  s.homepage          = "https://github.com/coffellas-cto/GDWebViewController"
  s.screenshots       = "https://cloud.githubusercontent.com/assets/3193877/7665617/29a8672a-fbc9-11e4-98cf-41fec0f6c403.gif"

  s.license           = { :type => "MIT", :file => "LICENSE" }

  s.author            = { "coffellas-cto" => "coffellas-cto@coffellas-cto.com" }
  s.social_media_url  = "http://twitter.com/coffellas-cto"

  s.platform          = :ios, "8.0"
  s.source            = { :git => "https://github.com/coffellas-cto/GDWebViewController.git" }

  s.source_files      = "GDWebViewController/*"
end
