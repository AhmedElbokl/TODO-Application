//
//  TodoCell.swift
//  TODO Application
//
//  Created by ReMoSTos on 09/08/2023.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoCreationDataLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
