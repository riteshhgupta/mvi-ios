//
//  UserListView+MVIController.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension UserListViewController {

	class UserListMVIController: MVIController<Model, Intent, State> {

		let loadingState = MutableProperty<State.LoadingState>(.fullScreen)

		init() {
			super.init(stateReducer: StateReducer(), viewModel: Model())
		}

		override func setupBindings() {
			intent <~ viewModel
				.isRequestExecuting
				.withLatest(from: loadingState.producer)
				.map { .showLoading($1, $0) }
				.async()
			intent <~ viewModel
				.userList
				.map { .showUsers($0) }
			intent <~ viewModel
				.errors
				.filter { $0 != .noError }
				.map { .showError($0) }
			let shouldFetchUser: SignalProducer<State.LoadingState, NoError> = intent
				.producer
				.skipNil()
				.filterMap { $0.loadingState }
				.async()
			loadingState <~ shouldFetchUser
			intent <~ shouldFetchUser
				.map { _ in .showUsers([]) }
			viewModel.reactive.fetchUser <~ shouldFetchUser
				.map { _ in () }
		}
	}
}
