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
        copyrightLabel.text = ""
        descriptionLabel.text = ""
        
        NetworkManager.shared.fetchPotoInfoWithAlamofire(from: NetworkManager.shared.apiNASA) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo):
                    self.navigationItem.title = photoInfo.title
                    self.copyrightLabel.text = photoInfo.copyright
                    self.descriptionLabel.text = photoInfo.description
                    self.updataImage(with: photoInfo)
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updataImage(with photoInfo: PhotoInfo) {
        guard let stringURL = photoInfo.url else { return }
        imageView.image = UIImage(contentsOfFile: stringURL)
        activityIndicator.stopAnimating()
    }
    
    func updateUI(with error: Error) {
        self.title = "Error Fetching Photo"
        self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
    }
}
