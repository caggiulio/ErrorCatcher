//
//  NCGHandleErrorManager.swift
//
//  Created by Nunzio Giulio Caggegi on 22/04/21.
//

import Foundation

public class NCGHandleErrorManager: NCGErrorHandeable {
  private var parent: NCGHandleErrorManager?
  private let action: HandleAction<Error>

  public convenience init(action: @escaping HandleAction<Error> = { throw $0 }) {
    self.init(action: action, parent: nil)
  }

  private init(action: @escaping HandleAction<Error>, parent: NCGHandleErrorManager? = nil) {
    self.action = action
    self.parent = parent
  }

  public func `throw`(_ error: Error, finally: @escaping (Bool) -> Void) {
    `throw`(error, previous: [], finally: finally)
  }

  private func `throw`(_ error: Error, previous: [NCGHandleErrorManager], finally: ((Bool) -> Void)? = nil) {
    if let parent = parent {
      parent.throw(error, previous: previous + [self], finally: finally)
      return
    }
    serve(error, next: AnyCollection(previous.reversed()), finally: finally)
  }

  private func serve(_ error: Error, next: AnyCollection<NCGHandleErrorManager>, finally: ((Bool) -> Void)? = nil) {
    do {
      try action(error)
      finally?(true)
    } catch {
      if let nextHandler = next.first {
        nextHandler.serve(error, next: next.dropFirst(), finally: finally)
      } else {
        finally?(false)
      }
    }
  }

  public func `catch`(action: @escaping HandleAction<Error>) -> NCGErrorHandeable {
    return NCGHandleErrorManager(action: action, parent: self)
  }
}
