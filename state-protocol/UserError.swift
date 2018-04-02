//
//  UserError.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 02/04/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation

protocol PresentableError: Error {
	
	var title: String { get }
	var message: String { get }
}

struct APIError: PresentableError {
	
	let title: String = "API Error"
	let message: String = "Something went wrong, please try again!"
}

struct DataStoreError: PresentableError {
	
	let title: String = "Datastore Error"
	let message: String = "Something went wrong, please try again!"
}

enum EntityError: Equatable {
	
	case noError
	case api(APIError)
	case store(DataStoreError)
}

extension EntityError {
	
	static func == (lhs: EntityError, rhs: EntityError) -> Bool {
		switch (lhs, rhs) {
		case (.noError, .noError),
				 (.api, .api),
				 (.store, .store):
			return true
		default:
			return false
		}
	}
}

extension EntityError: PresentableError {
	
	var title: String {
		switch self {
		case .api(let error): return error.title
		case .store(let error): return error.title
		case .noError:
			fatalError("NoError shouldn't be presented on screen")
		}
	}

	var message: String {
		switch self {
		case .api(let error): return error.message
		case .store(let error): return error.message
		case .noError:
			fatalError("NoError shouldn't be presented on screen")
		}
	}
}
