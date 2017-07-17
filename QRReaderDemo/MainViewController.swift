//
//  MainViewController.swift
//  QRReaderDemo
//
//  Created by Design on 7/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var mainWeb: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestURL = NSURL(string:"http://firassleibi.com/qr.php")
        let request = NSURLRequest(url: requestURL! as URL)
        mainWeb.loadRequest(request as URLRequest)
        mainWeb.delegate=self
        
        

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
        return true
    }
    func setCode(code : NSString){
        mainWeb.stringByEvaluatingJavaScript(from: "setCode('"+(code as String)+"')")
        
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
