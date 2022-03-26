//
//  NCGErrorConvenience.swift
//
//  Created by Nunzio Giulio Caggegi on 22/04/21.
//

import Foundation

/// Protocol extensions for convenience API
public extension NCGErrorHandeable {
  func `do`<A>(_ section: () throws -> A) {
    do {
      _ = try section()
    } catch {
      `throw`(error)
    }
  }
}

public extension NCGErrorHandeable {
  func `throw`(_ error: Error) {
    `throw`(error, finally: { _ in })
  }
}

public extension NCGErrorHandeable {
  func `catch`<K: Error>(_: K.Type, action: @escaping HandleAction<K>) -> NCGErrorHandeable {
    return `catch`(action: { e in
      if let k = e as? K {
        try action(k)
      } else {
        throw e
      }
    })
  }

  func `catch`<K: Error>(_ value: K, action: @escaping HandleAction<K>) -> NCGErrorHandeable where K: Equatable {
    return `catch`(action: { e in
      if let k = e as? K, k == value {
        try action(k)
      } else {
        throw e
      }
    })
  }
}

public extension NCGErrorHandeable {
  func listen(action: @escaping (Error) -> Void) -> NCGErrorHandeable {
    return `catch`(action: { e in
      action(e)
      throw e
    })
  }

  func listen<K: Error>(_ type: K.Type, action: @escaping (K) -> Void) -> NCGErrorHandeable {
    return `catch`(type, action: { e in
      action(e)
      throw e
    })
  }

  func listen<K: Error>(_ value: K, action: @escaping (K) -> Void) -> NCGErrorHandeable where K: Equatable {
    return `catch`(value, action: { e in
      action(e)
      throw e
    })
  }
}
