//
//  NewsTableViewCell.swift
//  SpochanSecondVersion
//
//  Created by Admin on 25.03.2021.
//

import UIKit
import FirebaseStorage
import SDWebImage


class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsTimeLabel: UILabel!
    @IBOutlet weak var newsDataLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var point1: UIImageView!
    @IBOutlet weak var point2: UIImageView!
    @IBOutlet weak var point3: UIImageView!
    @IBOutlet weak var point4: UIImageView!
    @IBOutlet weak var point5: UIImageView!
    
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    
    var imageCount: Int = 1
    
    
    
    override func awakeFromNib() {//вызывается если данный объект создается из файла интерфейса
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(newsTitle: String, newsDescription: String, newsData: String, newsTime: String, newsImageUrl_1: String, newsImageUrl_2: String, newsImageUrl_3: String, newsImageUrl_4: String, newsImageUrl_5: String) {
        
    
        loadingBar.layer.cornerRadius = 5
        
        newsTitleLabel.text = newsTitle
        newsDescriptionLabel.text = newsDescription
        newsDataLabel.text = newsData
        newsTimeLabel.text = newsTime

        loadImage(imageUrl: newsImageUrl_1)
        
        //добавить пять фоток и проверить
        
        point1.isHidden = true
        point2.isHidden = true
        point3.isHidden = true
        point4.isHidden = true
        point5.isHidden = true
        
        if newsImageUrl_1 != "" {imageCount = 1}
        
        if newsImageUrl_2 != "" {
            imageCount = 2
            point4.isHidden = false
            point5.isHidden = false
            self.point4.image = UIImage(named: "bluePoint")}
        
        if newsImageUrl_3 != "" {
            imageCount = 3
            point3.isHidden = false
            self.point4.image = UIImage(named: "greyPoint")
            self.point3.image = UIImage(named: "bluePoint")}
        
        if newsImageUrl_4 != "" {
            imageCount = 4
            point2.isHidden = false
            self.point3.image = UIImage(named: "greyPoint")
            self.point2.image = UIImage(named: "bluePoint")}
        
        if newsImageUrl_5 != "" {
            imageCount = 5
            point1.isHidden = false
            self.point2.image = UIImage(named: "greyPoint")
            self.point1.image = UIImage(named: "bluePoint")}
    }
    
    
    func loadImage(imageUrl: String) {
        
        self.newsImageView.image = nil
        self.loadingBar.isHidden = false
        self.loadingBar.startAnimating()
        
        let imageUrl1 = URL(string: imageUrl)
        newsImageView.sd_setImage(with: imageUrl1, completed: {_,_,_,_ in
            //выполняется когда изображение все же загрузится
            self.loadingBar.isHidden = true
        })
        
        
        //этот метод, если изображения находятся на устройстве, а не через интернет
//        DispatchQueue.main.async { //загружаем изображения в другом потоке, чтоб не тормозить приложение
//            if let url = URL(string: imageUrl) {
//                if let data = try? Data(contentsOf: url) {
//                    self.newsImageView.image = UIImage(data: data)
//                }
//            }
//        }
    }
    
    
    

    
    
    
}
