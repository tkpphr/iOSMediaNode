/*
 MIT License
 
 Copyright (c) 2018 tkpphr
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
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
