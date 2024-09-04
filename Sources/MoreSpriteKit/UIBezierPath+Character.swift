import UIKit
import CoreText

public extension UIBezierPath {

    convenience init? (character: String.Element, font: UIFont) {
        var unichars = [UniChar](String(character).utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs && character.isLetter {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
            self.init(cgPath: cgpath)
        } else {
            self.init()
            return nil
        }
    }
}
