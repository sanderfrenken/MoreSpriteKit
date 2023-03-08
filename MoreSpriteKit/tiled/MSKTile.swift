public struct MSKTile: Equatable, Hashable {
    public let column: Int
    public let row: Int

    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

    public static func == (lhs: MSKTile, rhs: MSKTile) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
}
