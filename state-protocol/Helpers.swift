//
//  Extensions.swift
//  state-protocol
//
//  Created by Ritesh Gupta on 02/04/18.
//  Copyright © 2018 Ritesh Gupta. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: UIViewController {
	
	var presentController: BindingTarget<String> {
		return makeBindingTarget { (controller, identifier) in
			let destinationVC = controller
				.storyboard!
				.instantiateViewController(withIdentifier: identifier)
			controller.present(destinationVC, animated: true)
		}
	}
}

extension UIActivityIndicatorView {
	
	func animate(_ shouldStart: Bool) {
		if shouldStart {
			startAnimating()
		} else {
			stopAnimating()
		}
	}
}

extension Reactive where Base: UIButton {

	var didTap: Signal<Void, NoError> {
		return controlEvents(.touchUpInside)
			.map { _ in () }
	}
}

extension MutableProperty where Value: OptionalProtocol {
	
	func filter(_ callback: @escaping (Value.Wrapped) -> Bool) -> SignalProducer<Value.Wrapped, NoError> {
		return producer
			.skipNil()
			.filter(callback)
	}
}

extension MutableProperty {
	
	func filter(_ callback: @escaping (Value) -> Bool) -> SignalProducer<Value, NoError> {
		return producer
			.filter(callback)
	}
}

extension SignalProducer where Error == NoError {
	
	func toVoid() -> SignalProducer<Void, NoError> {
		return map { _ in () }
	}
}

extension Double {
	
	var dispatchTime: DispatchTime {
		return DispatchTime.now() + self
	}

	func executeAfter(_ closure: @escaping () -> Void) {
		DispatchQueue.main.asyncAfter(deadline: dispatchTime) { closure() }
	}
}

final class RefreshControl: UIRefreshControl {

	let (didRefreshSignal, didRefreshObserver) = Signal<Void, NoError>.pipe()

	override init() {
		super.init()
		setup()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	func setup() {
		frame = CGRect(x: 0, y: 0, width: 375.0, height: 128.0)
		tintColor = .black
		addTarget(
			self,
			action: #selector(handleDidChangeValue),
			for: .valueChanged
		)
	}

	@objc func handleDidChangeValue() {
		didRefreshObserver.send(value: ())
	}
}

extension UserListViewController {

	func showAlert(for error: PresentableError) {
		let alert = UIAlertController(
			title: error.title,
			message: error.message,
			preferredStyle: .alert
		)
		let okAction = UIAlertAction(title: "Ok", style: .default)
		alert.addAction(okAction)
		present(alert, animated: true)
	}
}

extension SignalProducer {

	func async() -> SignalProducer {
		return delay(0.0, on: QueueScheduler())
			.observe(on: UIScheduler())
	}
}

extension Signal {

	func async() -> Signal {
		return delay(0.0, on: QueueScheduler())
			.observe(on: UIScheduler())
	}
}

extension ActionError {

	var entityError: EntityError {
		switch self {
		case .disabled:
			return .noError
		case .producerFailed(let error):
			switch error {
			case is APIError: return .api(error as! APIError)
			case is DataStoreError: return .store(error as! DataStoreError)
			default: return .noError
			}
		}
	}
}
