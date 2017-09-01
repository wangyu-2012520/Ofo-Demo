//
//  WebActivityViewController.swift
//  ofo Bike
//
//  Created by Yu Wang on 8/17/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

import UIKit
import WebKit

class WebActivityViewController: UIViewController, WKUIDelegate{
    
    var webView: WKWebView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start loading Activity page")
        
        self.title = "热门活动"
        let myURL = URL(string: "https://www.apple.com/au/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        print("navigate to Activity page")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
