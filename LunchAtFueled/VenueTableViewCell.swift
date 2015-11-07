//
//  VenueTableViewCell.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 10/30/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import Cosmos
import Foundation
import UIKit

class VenueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingsCountView: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueRatingLabel: UILabel!
    @IBOutlet weak var venueCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    /// Customizes the table view cell
    func setupView() {
        userPhotoImageView.layer.cornerRadius = 4
        userPhotoImageView.layer.shouldRasterize = true
        userPhotoImageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .Precise
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userPhotoImageView.image = nil
    }
}
