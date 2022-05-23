internal enum LogLevel: String {
    case debug
    case warning
    case error
}

internal func log(logLevel: LogLevel, message: String) {
    #if DEBUG
    print("[\(logLevel.rawValue)]: \(message)")
    #endif
}
