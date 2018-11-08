//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal extension UIView {
    internal func loadNibFromMediaNode(nibName:String){
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        let nib = UINib(nibName: nibName,bundle:bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
