//
//  ImageDetailVC.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import UIKit

class ImageDetailVC: UIViewController {

    //MARK:  Outlets
    @IBOutlet weak var imageDetailView: UIImageView!
    
    var imageUrl: String?
    var image: UIImage?
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShareButton()
        loadImage()
    }
    //MARK: helper functions
    
    private func setupShareButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItem = shareButton
    }

    
    @objc private func didTapShare() {
        guard let image = imageDetailView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }

}

//MARK: extensions loading image
extension ImageDetailVC {
    
    private func loadImage() {
        if let image = image {
            imageDetailView.image = image
        } else if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageDetailView.image = image
                    }
                }
            }
        }
    }
}

//MARK: zooming Image
extension ImageDetailVC: UIScrollViewDelegate  {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageDetailView
    }
}
 
