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

internal class FoundMediaNodeInfoViewCell : UITableViewCell {
    @IBOutlet private weak var shiftButton: UIButton!
    @IBOutlet private weak var selectButton: TransparentButton!
    @IBOutlet private weak var nodeName: UILabel!
    @IBOutlet private weak var nodeInfo: UILabel!
    internal var mediaNodeSelected:((_ mediaNode:MediaNode)->Void)?
    internal var selectableFilter:((_ mediaNode:MediaNode)->Bool)?
    private var mediaNodeSelector:MediaNodeSelector?
    private var mediaNode:MediaNode? {
        didSet {
            self.refresh()
        }
    }
    private var isSelectEnabled : Bool = true {
        didSet {
            if self.isSelectEnabled {
                self.nodeName.isEnabled = true
                self.nodeInfo.isEnabled = true
                self.selectButton.isEnabled = true
            }else{
                self.nodeName.isEnabled = false
                self.nodeInfo.isEnabled = false
                self.selectButton.isEnabled = false
            }
        }
    }
    
    
    internal override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
    }
    
    internal func reset(mediaNodeSelector:MediaNodeSelector,mediaNode:MediaNode){
        self.mediaNodeSelector = mediaNodeSelector
        self.mediaNode = mediaNode
    }
    
    internal func refresh(){
        guard let mediaNode = self.mediaNode else { return }
        self.isSelectEnabled = self.selectableFilter?(mediaNode) ?? true
        self.nodeName.text = mediaNode.nodeName
        self.nodeInfo.text = mediaNode.nodeInfo
    }
    
    @IBAction private func onTapSelect(_ sender:Any){
        guard let mediaNode = self.mediaNode else { return }
        self.mediaNodeSelected?(mediaNode)
    }
    
    @IBAction private func onTapShift(_ sender:Any){
        guard let mediaNode = self.mediaNode,
            let mediaNodeSelector = self.mediaNodeSelector
            else {
                return
        }
        mediaNodeSelector.currentNode = mediaNode
    }
    
}

