//
//  UserListTableViewCell.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {

	@IBOutlet var titleLabel: UILabel!

	func configure(with index: Int) {
		titleLabel.text = "\(index)"
	}
}
