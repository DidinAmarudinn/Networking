//
//  ViewController.swift
//  LatihanEmpheralSession
//
//  Created by didin amarudin on 23/12/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        donwloadImage()
    }

    private func donwloadImage() {
        let path = "https://www.dicoding.com/blog/wp-content/uploads/2017/10/dicoding-logo-square.png"
        let url = URL(string: path)
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration)
        
        if let response = configuration.urlCache?.cachedResponse(for: URLRequest(url: url!)) {
            label.text = "Use cache image"
            imageView.image = UIImage(data: response.data)
        } else {
            label.text = "call image from network"
            let downloadTask = session.dataTask(with: url!) { [weak self] data, response, error in
                guard let self = self, let data = data else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
                
            }
            downloadTask.resume()
        }
    }
}

