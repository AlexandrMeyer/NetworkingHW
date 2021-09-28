//
//  ImageViewController.swift
//  NetworkingHW
//
//  Created by Александр on 25.09.21.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NetworkManager.shared.fetchPotoInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.navigationItem.title = photoInfo.title
                    self.copyrightLabel.text = photoInfo.copyright
                    self.descriptionLabel.text = photoInfo.explanation
                    self.updataImage(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updataImage(with photoInfo: PhotoInfo) {
        guard let url = photoInfo.url else { return }
        NetworkManager.shared.fetchImage(from: url) { result in
                switch result {
                case .success(let data):
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                case .failure(let error):
                    self.updateUI(with: error)
                }
        }
    }
    
    func updateUI(with error: Error) {
        self.title = "Error Fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
    }
}
