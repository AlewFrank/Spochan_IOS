//
//  CompetitionTableViewCell.swift
//  SpochanSecondVersion
//
//  Created by Admin on 13.04.2021.
//

import UIKit
import FirebaseStorage
import SDWebImage

class CompetitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var competitionTitleLabel: UILabel!
    @IBOutlet weak var competitionLocationLabel: UILabel!
    @IBOutlet weak var competitionDataLabel: UILabel!
    
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var competitionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(competitionTitle: String, competitionDescription: String, competitionLocation: String, competitionAddress: String, competitionImageUrl: String, daysCompetitionDate: String, monthCompetitionDate: String, yearCompetitionDate: String) {
        
        loadingBar.layer.cornerRadius = 5
        
        loadingBar.isHidden = false
        loadingBar.startAnimating()
        
        competitionTitleLabel.text = competitionTitle
        competitionLocationLabel.text = competitionLocation
        competitionDataLabel.text = daysCompetitionDate + "." + monthCompetitionDate + "." + yearCompetitionDate
        
        let imageUrl1 = URL(string: competitionImageUrl)
        
        competitionImageView.sd_setImage(with: imageUrl1, placeholderImage: UIImage.init(named: "competitions_item_background"), context: nil, progress: nil, completed: {_,_,_,_ in
            //выполняется когда изображение все же загрузится
            self.loadingBar.isHidden = true
        })
//        competitionImageView.sd_setImage(with: imageUrl1, completed: {_,_,_,_ in
//            //выполняется когда изображение все же загрузится
//            self.loadingBar.isHidden = true
//        })
        
    }

}
