//
//  ViewController.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 20/03/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class UserListViewController: UIViewController {

	let viewModel = Model()
	let pullToRefreshView = RefreshControl()
	var dataSource: UserListViewDatasource!

	@IBOutlet var fullScreenLoaderView: UIActivityIndicatorView!
	@IBOutlet var tableview: UITableView! {
		didSet {
			tableview.refreshControl = pullToRefreshView
			tableview.delegate = self
			tableview.tableFooterView = UIView()
		}
	}
	
	@IBOutlet var searchButton: UIButton! {
		didSet {
		}
	}
	
	@IBOutlet var settingsButton: UIButton! {
		didSet {
			viewModel.reactive.fetchUser <~ settingsButton.reactive.didTap
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		reactive.updateTable <~ viewModel.userList
		reactive.showError <~ viewModel.errors
		viewModel.reactive.fetchUser <~ pullToRefreshView.didRefreshSignal
		pullToRefreshView.reactive.isRefreshing <~ viewModel.isRequestExecuting
		fullScreenLoaderView.reactive.isAnimating <~ viewModel.isRequestExecuting
		fullScreenLoaderView.reactive.isHidden <~ viewModel.isRequestExecuting.map(!)
	}
}

extension UserListViewController: UITableViewDelegate {}

extension Reactive where Base: UserListViewController {

	var updateTable: BindingTarget<[User]> {
		return makeBindingTarget { controller, users in
			controller.dataSource = UserListViewDatasource(users: users)
			controller.tableview.dataSource = controller.dataSource
			controller.tableview.reloadData()
		}
	}

	var showError: BindingTarget<EntityError> {
		return makeBindingTarget { controller, _ in
		}
	}
}
