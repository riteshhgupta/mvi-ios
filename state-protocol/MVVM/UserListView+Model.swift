//
//  UserListViewModel.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension UserListViewController {

	class Model: ViewModel {

		let apiAction = Action(execute: APIClient().usersAPIRequest)
		let cacheAction = Action(execute: DataStore().usersCacheRequest)

		lazy var isRequestExecuting: SignalProducer<Bool, NoError> = {
			let producers = [
				cacheAction.isExecuting.producer,
				apiAction.isExecuting.producer
			]
			return SignalProducer
				.combineLatest(producers)
				.map { $0.reduce(false, { $0 || $1 }) }
		}()

		lazy var userList: Signal<[User], NoError> = {
			return Signal.merge([
				cacheAction.values,
				apiAction.values
				])
		}()

		lazy var errors: Signal<EntityError, NoError> = {
			return Signal.merge([
				cacheAction.errors.map { EntityError.store($0) },
				apiAction.errors.map { EntityError.api($0) }
				])
		}()

		func userFetcher() -> SignalProducer<[User], EntityError> {
			let apiProducer = apiAction
				.apply()
				.mapError { $0.entityError }
			let cacheProducer = cacheAction
				.apply()
				.mapError { $0.entityError }
			return SignalProducer
				.merge(
					cacheProducer,
					apiProducer
			)
		}
	}
}

extension Reactive where Base: UserListViewController.Model {

	var fetchUser: BindingTarget<Void> {
		return makeBindingTarget { viewModel, _ in
			viewModel
				.userFetcher()
				.start()
		}
	}
}

extension UserListViewController.Model: ReactiveExtensionsProvider {}
