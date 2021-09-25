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
        fetchPotoInfo()
    }
    
    private func fetchPotoInfo() {
        let urlComponent = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        
        guard let url = URL(string: urlComponent) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }

            do {
                let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
                
                DispatchQueue.main.async {
                    self.updateUI(with: photoInfo)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func updateUI(with photoInfo: PhotoInfo) {
        descriptionLabel.text = photoInfo.explanation
        copyrightLabel.text = photoInfo.copyright
        navigationItem.title = photoInfo.title
        DispatchQueue.global().async {
            guard let url = photoInfo.url else { return }
            guard let imagaData = try? Data(contentsOf: url) else {
                return }
            DispatchQueue.main.async {
                self.imageView.image =  UIImage(data: imagaData)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
