//
//  UserListView+State.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation

extension UserListViewController {

	enum State: ViewState {

		case initialViewState
		case loading(LoadingState, Bool)
		case error(PresentableError)
		case users([User])
	}
}

extension UserListViewController.State {

	enum LoadingState {

		case pullToRefresh
		case fullScreen
	}
}

