//
//  NCGErrorHandeable.swift
//
//  Created by Nunzio Giulio Caggegi on 22/04/21.
//

import Foundation

public typealias HandleAction<T> = (T) throws -> Void

// MARK: - NCGErrorHandeable

public protocol NCGErrorHandeable: AnyObject {
  func `throw`(_: Error, finally: @escaping (Bool) -> Void)
  func `catch`(action: @escaping HandleAction<Error>) -> NCGErrorHandeable
}
