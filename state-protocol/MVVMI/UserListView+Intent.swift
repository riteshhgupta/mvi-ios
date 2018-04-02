//
//  UserListView+Intent.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation

extension UserListViewController {

	enum Intent: ViewIntent {

		case initialViewSetup
		case fetchUser(State.LoadingState)
		case showLoading(State.LoadingState, Bool)
		case showUsers([User])
		case showError(PresentableError)
	}
}

extension UserListViewController.Intent {

	var loadingState: UserListViewController.State.LoadingState? {
		if case .fetchUser(let loadingState) = self {
			return loadingState
		} else {
			return nil
		}
	}
}
