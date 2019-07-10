import XCTest
import MoreSpriteKit

class ArithmeticTests: XCTestCase {

    func testCgfloatArithmetics() {
        // swiftlint:disable identifier_name
        let cgfloat_2_5: CGFloat = 2.5
        let int2 = 2

        let sumPlus1 = cgfloat_2_5 + int2
        assert(sumPlus1 == CGFloat(4.5), "sumPlus1 is not correctly calculated: \(sumPlus1)")

        let sumPlus2 = int2 + cgfloat_2_5
        assert(sumPlus2 == CGFloat(4.5), "sumPlus2 is not correctly calculated: \(sumPlus2)")

        let sumMinus1 = cgfloat_2_5 - int2
        assert(sumMinus1 == CGFloat(0.5), "sumMinus1 is not correctly calculated: \(sumMinus1)")

        let sumMinus2 = int2 - cgfloat_2_5
        assert(sumMinus2 == CGFloat(-0.5), "sumMinus2 is not correctly calculated: \(sumMinus2)")

        let multiply1 = cgfloat_2_5 * int2
        assert(multiply1 == CGFloat(5.0), "multiply1 is not correctly calculated: \(multiply1)")

        let multiply2 = int2 * cgfloat_2_5
        assert(multiply2 == CGFloat(5.0), "multiply2 is not correctly calculated: \(multiply2)")

        let divide1 = cgfloat_2_5 / int2
        assert(divide1 == CGFloat(1.25), "divide1 is not correctly calculated: \(divide1)")

        let divide2 = int2 / cgfloat_2_5
        assert(divide2 == CGFloat(0.8), "divide2 is not correctly calculated: \(divide2)")
        // swiftlint:enable identifier_name
    }
}
