//
//  TableViewCell.swift
//  ToDoApp
//
//  Created by Angadjot singh on 30/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//// name - Angadjot singh
//Author's name - Angadjot singh
// app name - The ToDo App
//  Student ID - 301060981
// file description  - File for custom table view 

import UIKit

protocol TableViewNew {
    func onClickCell(index:Int)
    func onClickSwitch(index:Int)
}



class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var editButtonLabel: UIButton!
    
    var cellDelegate:TableViewNew?
    var index:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func editButton(_ sender: UIButton) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
    
    
    @IBAction func statusSwitch(_ sender: UISwitch) {
        cellDelegate?.onClickSwitch(index: (index?.row)!)
    }
    
    

}
