import Foundation

extension Float {
    var weightDifferenceFormatted: String {
        var sign = ""
        if (self > 0) {
            sign = "+"
        }
        
        var difference = ""
        
        let isRound = (self - floor(self)) < 0.1
        if isRound {
            difference = "\(Int(floor(self)))"
        } else {
            difference = String(format: "%.1f", self)
        }
        
        return sign + difference
    }
    
    var weightFormatted: String {
        String(format: "%.1f", self)
    }
}
