//
//  ImagesViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 12.04.2021.
//

import UIKit

class ImagesViewController: UIViewController {
    
    var newsImageUrl_1: String?
    var newsImageUrl_2: String?
    var newsImageUrl_3: String?
    var newsImageUrl_4: String?
    var newsImageUrl_5: String?
    
    var previousImageIndex: Int = 0
    var nextImageIndex: Int = 2

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var nextImageButton: UIButton!
    @IBOutlet weak var previousImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousImageButton.layer.cornerRadius = 20
        previousImageButton.isHidden = true
        nextImageButton.layer.cornerRadius = 20
        loadingBar.layer.cornerRadius = 5
        
        if newsImageUrl_2 == "" {
            nextImageButton.isHidden = true
            print("У нас одно изображение")
        }

        
        DispatchQueue.main.async {
            self.loadImage(imageUrl: self.newsImageUrl_1 ?? "")}
    }
    
    
    
    @IBAction func previousImageButtonPressed(_ sender: Any) {

        if newsImageUrl_4 != "" && previousImageIndex == 4 {
            nextImageButton.isHidden = false
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_4 ?? "")}
            previousImageIndex = previousImageIndex - 1
            nextImageIndex = nextImageIndex - 1
        } else if newsImageUrl_3 != ""  && previousImageIndex == 3 {
            nextImageButton.isHidden = false
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_3 ?? "")}
            previousImageIndex = previousImageIndex - 1
            nextImageIndex = nextImageIndex - 1
        } else if newsImageUrl_2 != ""  && previousImageIndex == 2 {
            nextImageButton.isHidden = false
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_2 ?? "")}
            previousImageIndex = previousImageIndex - 1
            nextImageIndex = nextImageIndex - 1
        } else if newsImageUrl_1 != ""  && previousImageIndex == 1 {
            nextImageButton.isHidden = false
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_1 ?? "")}
            previousImageIndex = previousImageIndex - 1
            nextImageIndex = nextImageIndex - 1
            previousImageButton.isHidden = true
        }
    }
    
    
    
    @IBAction func nextImageButtonPressed(_ sender: Any) {
        
        if newsImageUrl_2 != ""  && nextImageIndex == 2 {
            if newsImageUrl_3 == "" {nextImageButton.isHidden = true}
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_2 ?? "")}
            previousImageButton.isHidden = false
            previousImageIndex = previousImageIndex + 1
            nextImageIndex = nextImageIndex + 1
        } else if newsImageUrl_3 != "" && nextImageIndex == 3 {
            if newsImageUrl_4 == "" {nextImageButton.isHidden = true}
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_3 ?? "")}
            previousImageButton.isHidden = false
            previousImageIndex = previousImageIndex + 1
            nextImageIndex = nextImageIndex + 1
        } else if newsImageUrl_4 != "" && nextImageIndex == 4 {
            if newsImageUrl_5 == "" {nextImageButton.isHidden = true}
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_4 ?? "")}
            previousImageButton.isHidden = false
            previousImageIndex = previousImageIndex + 1
            nextImageIndex = nextImageIndex + 1
        } else if newsImageUrl_5 != "" && nextImageIndex == 5 {
            nextImageButton.isHidden = true
            DispatchQueue.main.async {
                self.loadImage(imageUrl: self.newsImageUrl_5 ?? "")}
            previousImageButton.isHidden = false
            previousImageIndex = previousImageIndex + 1
            nextImageIndex = nextImageIndex + 1
        }
    }
    
    
    func loadImage(imageUrl: String) {
        self.newsImageView.image = nil
        self.loadingBar.isHidden = false
        self.loadingBar.startAnimating()
        DispatchQueue.main.async { //загружаем изображения в другом потоке, чтоб не тормозить приложение
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    self.newsImageView.image = UIImage(data: data)
                    self.newsImageView.layer.cornerRadius = 15
                }
            }
            self.loadingBar.isHidden = true
        }
    }
    

}
