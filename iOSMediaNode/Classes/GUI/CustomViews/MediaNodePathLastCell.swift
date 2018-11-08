//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class MediaNodePathLastCell : UICollectionViewCell {
    @IBOutlet private weak var pathName: UILabel!
    
    internal func reset(_ pathName:String){
        self.pathName.text = pathName
    }
}
