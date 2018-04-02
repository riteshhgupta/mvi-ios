//
//  MVIController.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift

class MVIController<Model: ViewModel, Intent: ViewIntent, State: ViewState> {

	let viewModel: Model
	let stateReducer: ViewStateReducer<State, Intent>
	let intent = MutableProperty<Intent?>(nil)

	init(stateReducer reducer: ViewStateReducer<State, Intent>, viewModel model: Model) {
		stateReducer = reducer
		viewModel = model
		setupBindings()
	}

	func setupBindings() {}
}
