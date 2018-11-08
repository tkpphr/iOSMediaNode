//Copyright (c) 2018-present tkpphr. All rights reserved.
import Foundation
import UIKit

internal class MediaNodePathAncestorCell : UICollectionViewCell {
    @IBOutlet private weak var pathButton: UIButton!
    internal var tapped:((_ depth:Int) -> Void)?
    private var depth:Int = 0
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        self.pathButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.pathButton.titleLabel?.numberOfLines = 2
    }
    
    internal func reset(pathName:String,depth:Int) {
        self.pathButton.setTitle(pathName, for: .normal)
        self.depth = depth
    }
    
    @IBAction private func onTapPath(_ sender:Any) {
        self.tapped?(self.depth)
    }
    
    
    
    
    
}
