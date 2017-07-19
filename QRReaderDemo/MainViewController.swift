//
//  MainViewController.swift
//  QRReaderDemo
//
//  Created by Design on 7/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class MainViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var mainWeb: UIWebView!
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isInternetAvailable())
        {
            showIndicator()
            let requestURL = NSURL(string:"http://firassleibi.com/qr.php")
            let request = NSURLRequest(url: requestURL! as URL)
            mainWeb.loadRequest(request as URLRequest)
            mainWeb.delegate=self
        }
        else{
            let myAlert = UIAlertController(title: "خطأ", message: "حدث خطأ ما تآكد من اتصالك بالانترنت وحاول مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
            myAlert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "sharjahhaj" {
            
            //performSegue(withIdentifier: "showQR", sender: nil)
            let myVC = storyboard?.instantiateViewController(withIdentifier: "QRView") as! ViewController
            myVC.mainView = self
            navigationController?.pushViewController(myVC, animated: true)
        }
        if request.url?.scheme == "openmobile" {
            if let url = URL(string: (request.url?.query!)!), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        return true
    }
    func webView(_webView: UIWebView, didFailLoadWithError error: NSError?) {
        let myAlert = UIAlertController(title: "خطأ", message: "حدث خطأ ما تآكد من اتصالك بالانترنت وحاول مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
        self.present(myAlert, animated: true, completion: nil)
    }
    func setCode(code : NSString){
        mainWeb.stringByEvaluatingJavaScript(from: "setCode('"+(code as String)+"')")
        
    }
    
    func showIndicator(){
        // Start the throbber to check if the user exists
        
        indicator.frame = CGRect(x: 0, y: 0,width: 40,height: 40);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        indicator.startAnimating()
    }
    func hideIndicator(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        hideIndicator()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    

}
