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

	let mviController: MVIController<Model, Intent, State> = UserListMVIController()

	let refreshControl = RefreshControl()
	var dataSource: UserListViewDatasource!

	@IBOutlet var activityIndicatorView: UIActivityIndicatorView!
	@IBOutlet var tableview: UITableView! {
		didSet {
			tableview.refreshControl = refreshControl
			tableview.delegate = self
			tableview.tableFooterView = UIView()
			mviController.intent <~ refreshControl
				.didRefreshSignal
				.map { _ in .fetchUser(.pullToRefresh) }
		}
	}
	
	@IBOutlet var searchButton: UIButton! {
		didSet {
		}
	}
	
	@IBOutlet var settingsButton: UIButton! {
		didSet {
			mviController.intent <~ settingsButton
				.reactive
				.didTap
				.map { .fetchUser(.fullScreen) }
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renderSetup()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mviController.intent.value = .fetchUser(.fullScreen)
	}
}

extension UserListViewController: ViewStateRenderer {

	var initialState: State {
		return .initialViewState
	}

	var renderView: BindingTarget<State> {
		return reactive.makeBindingTarget { controller, state in
			switch state {
			case .initialViewState:
				controller.activityIndicatorView.isHidden = true
			case .loading(let loadingState, let isLoading):
				switch loadingState {
				case .pullToRefresh:
					if !isLoading { controller.refreshControl.endRefreshing() }
				case .fullScreen:
					controller.activityIndicatorView.isHidden = !isLoading
					controller.activityIndicatorView.animate(isLoading)
				}
			case .users(let users):
				controller.dataSource = UserListViewDatasource(users: users)
				controller.tableview.dataSource = controller.dataSource
				controller.tableview.reloadData()
			case .error(let error):
				controller.showAlert(for: error)
			}
		}
	}
}

extension UserListViewController: UITableViewDelegate {}
