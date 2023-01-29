prefix operator ^

/// Creates a function form a key path
///
/// ```swift
/// ...
///   .map( ^\URL.scheme )
///   ...
/// ```
///
/// - Parameter keyPath: From which function should be created.
/// - Returns: Function of type `(Root) -> Value`
public prefix func ^ <Root, Value>(keyPath: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in root[keyPath: keyPath] }
}
