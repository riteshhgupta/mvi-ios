//
//  ViewStateRenderer.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ViewStateRenderer {

	associatedtype State: ViewState
	associatedtype Intent: ViewIntent
	associatedtype Model: ViewModel

	var renderView: BindingTarget<State> { get }
	var mviController: MVIController<Model, Intent, State> { get }
	var initialState: State { get }
}

extension ViewStateRenderer {

	func renderSetup() {
		renderView <~ mviController
			.intent
			.producer
			.skipNil()
			.scan(initialState, mviController.stateReducer.reducer)
	}
}
