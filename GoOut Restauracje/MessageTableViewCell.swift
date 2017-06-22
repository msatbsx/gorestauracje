//
//  MessageTableViewCell.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 29/10/2016.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell
{
    @IBOutlet weak var messageTittleLable: UILabel!
    @IBOutlet weak var timeRecivedLabel: UILabel!
    
    func setCellData(messageObject:MessageListModel)
    {
        messageTittleLable.text = messageObject.title
        timeRecivedLabel.text = messageObject.created_at
       
        if messageObject.is_read! == "1" {
            messageTittleLable.font = UIFont(name:"PTSans-Regular", size: 20.0)
            messageTittleLable.textColor = UIColor(red:0.48, green:0.52, blue:0.55, alpha:1.00)
        }
        else
        {
            messageTittleLable.font = UIFont(name:"PTSans-Bold", size: 20.0)
            messageTittleLable.textColor = UIColor(red:1, green:1, blue:1, alpha:1.00)
        }
    }
    
    override func layoutSubviews()
    {
        self.contentView.updateConstraintsIfNeeded();
        self.contentView.layoutIfNeeded();
        self.messageTittleLable.preferredMaxLayoutWidth = messageTittleLable.frame.width
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}
