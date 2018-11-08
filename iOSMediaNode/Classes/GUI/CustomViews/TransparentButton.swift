//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class TransparentButton : UIButton {
    internal override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.1)
            } else {
                UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations:{ self.backgroundColor = UIColor.clear } , completion: nil)
            }
        }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }
    
}
