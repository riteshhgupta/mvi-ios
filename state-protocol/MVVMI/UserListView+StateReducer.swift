//
//  UserListView+StateReducer.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation

extension UserListViewController {

	class StateReducer: ViewStateReducer<State, Intent> {

		init() {
			super.init { (previousState: State, intent: Intent) -> State in
				switch intent {
				case .initialViewSetup:
					return .initialViewState
				case .showUsers(let users):
					return .users(users)
				case .showError(let error):
					return .error(error)
				case .showLoading(let loadingState, let isFetching):
					return .loading(loadingState, isFetching)
				case .fetchUser:
					return previousState
				}
			}
		}
	}
}
