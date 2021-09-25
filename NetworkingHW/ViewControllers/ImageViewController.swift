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
        
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        navigationItem.title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        
        NetworkManager.shared.fetchPotoInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.updataUI(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updataUI(with photoInfo: PhotoInfo) {
        guard let url = photoInfo.url else { return }
        NetworkManager.shared.fetchImage(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                    self.navigationItem.title = photoInfo.title
                    self.copyrightLabel.text = photoInfo.copyright
                    self.descriptionLabel.text = photoInfo.explanation
                case .failure(let error):
                    self.updateUI(with: error)
                }
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
