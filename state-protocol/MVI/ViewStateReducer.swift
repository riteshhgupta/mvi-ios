//
//  ViewStateReducer.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 08/07/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation

class ViewStateReducer<State: ViewState, Intent: ViewIntent> {

	let reducer: (State, Intent) -> State

	init(_ reducer: @escaping (State, Intent) -> State) {
		self.reducer = reducer
	}
}
