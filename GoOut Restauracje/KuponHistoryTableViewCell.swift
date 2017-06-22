//
//  KuponHistoryTableViewCell.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 16/10/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class KuponHistoryTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var boughtKuponCountLabel: UILabel!
    
    func setCellData(from kuponObject:BoughtKuponModel)
    {
        if let resturantName = kuponObject.restaurantName
        {
            restaurantName.text = resturantName
        }
        if let restaurantAddress = kuponObject.restaurantAddress
        {
            addressLabel.text = restaurantAddress
        }
        if let date = kuponObject.stamp
        {
            dateLabel.text = date
        }
        if let boughtKupons = kuponObject.qty
        {
            boughtKuponCountLabel.text = "\(boughtKupons.intValue)"
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
}
