//
//  UserListViewDatasource.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit

final class UserListViewDatasource: NSObject, UITableViewDataSource {

	private let users: [User]

	init(users value: [User]) {
		users = value
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
		cell.configure(with: users[indexPath.row].id)
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
}
