//
//  HelpVC.swift
//  Mobiquity
//
//  Created by surendra on 14/05/21.
//

import UIKit
import WebKit

class HelpVC: UIViewController {
    
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.backgroundColor = .white
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    var activityViewWeb = UIActivityIndicatorView()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(webView)
        
        let str1 = "1.Launch the Weather app from the Home screen of your iPhone"
        let str2 = "2.Go to Home Screen"
        let str3 = "3.Tap on plus button to add locations as you want using MAp"
        let str4 = "4.go to city screen"
        let str5 = "4.City Screen display temperature, humidity, rain chances and wind information"


        let htmlString:String! = str1 + "<br/>" + "<br/>"  + str2 + "<br/>" + "<br/>" + str3 + "<br/>" + "<br/>" + str4 + "<br/>" + "<br/>" + str5
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(htmlString ?? "")
        </body>
        </html>
        """
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        webView.loadHTMLString(html, baseURL: nil)

    }


}

extension HelpVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeActivityindicator(indicator: activityViewWeb)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.removeActivityindicator(indicator: activityViewWeb)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.removeActivityindicator(indicator: activityViewWeb)
    }
}
