//
//  ViewController.swift
//  Download an image
//
//  Created by Daniel J Janiak on 7/14/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet var fullScreenImage: UIImageView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // https://upload.wikimedia.org/wikipedia/commons/f/f7/All_Souls_College_in_winter.jpg
        
        showLoadingIndicator()
        
        downloadImageFromURL("https://upload.wikimedia.org/wikipedia/commons/f/f7/All_Souls_College_in_winter.jpg") { (imageData, error, errorDesc) in
            
            if let imageData = imageData {
                let downloadedImage = UIImage(data: imageData)
                performUIUpdatesOnMain {
                    self.stopLoadingIndicator()
                    self.fullScreenImage.image = downloadedImage
                }
            }
            
            
            
        }
        
    }
    
    // MARK: - Helpers
    func downloadImageFromURL(urlString: String, completionHandlerForDownloadImageFromURL: (imageData: NSData?, error: Bool, errorDesc: String?) -> Void) {
        
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            
            // Defensive coding
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandlerForDownloadImageFromURL(imageData: nil, error: true, errorDesc: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForDownloadImageFromURL(imageData: nil, error: true, errorDesc: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForDownloadImageFromURL(imageData: nil, error: true, errorDesc: "No data was returned by the request!")
                return
            }
            
            completionHandlerForDownloadImageFromURL(imageData: data, error: false, errorDesc: nil)
            
        }
        
        task.resume()
        
    }
    
    func showLoadingIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
        
    }
    
    func stopLoadingIndicator() {
        
        activityIndicator.stopAnimating()
    }
    
    
    
    
    
}

