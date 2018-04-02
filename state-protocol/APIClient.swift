//
//  APIClient.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 03/04/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

struct User {

	let id: Int
}

class APIClient {
	
	func usersAPIRequest() -> SignalProducer<[User], APIError>  {
		return SignalProducer { (observer, lifetime) in
			DispatchQueue.main.asyncAfter(deadline: 3.0.dispatchTime) {
				let users = (0..<10).map { User(id: $0) }
				observer.send(value: users)
				observer.sendCompleted()
				// similarly handle error as well
			}
		}
	}
}

class DataStore {
	
	func usersCacheRequest() -> SignalProducer<[User], DataStoreError>  {
		return SignalProducer { (observer, lifetime) in
			DispatchQueue.main.asyncAfter(deadline: 1.0.dispatchTime) {
				let users = (7..<10).map { User(id: $0) }
				observer.send(value: users)
				observer.sendCompleted()
				// similarly handle error as well
			}
		}
	}
}
