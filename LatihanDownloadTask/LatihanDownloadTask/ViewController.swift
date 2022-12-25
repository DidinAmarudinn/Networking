//
//  ViewController.swift
//  LatihanDownloadTask
//
//  Created by didin amarudin on 24/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var buttonView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.text = ""
        progressView.isHidden = true
        
        DownloadManager.shared.progress = { (totalBytesWriten, totalBytesExpectedToWrite) in
            let totalMB = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .binary)
            let writenMB = ByteCountFormatter.string(fromByteCount: totalBytesWriten, countStyle: .binary)
            let progress = Float(totalBytesWriten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.async {
                self.buttonView.isEnabled = false
                self.progressView.isHidden = false
                self.progressView.progress = progress
                self.messageView.text = "Downloading \(writenMB) of \(totalMB)"
            }
        }
        
        DownloadManager.shared.completed = { (location) in
            try? FileManager.default.removeItem(at: location)
            DispatchQueue.main.async {
                self.messageView.text = "Download Finished"
                self.buttonView.isEnabled = false
            }
        }
        
        DownloadManager.shared.downloadError = { (task, error) in
            print("Task Completed: \(task), error: \(String(describing: error?.localizedDescription))")
            
        }
    }

    @IBAction func buttonDownload(_ sender: UIButton) {
       let url = URL(string: "http://212.183.159.230/50MB.zip")
        let task = DownloadManager.shared.session.downloadTask(with: url!)
        task.resume()
    }
    
}

