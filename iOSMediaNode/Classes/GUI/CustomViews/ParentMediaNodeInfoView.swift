//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class ParentMediaNodeInfoView : UIView {
    @IBOutlet private weak var selectButton: TransparentButton!
    @IBOutlet private weak var nodeName: UILabel!
    @IBOutlet private weak var shiftButton: UIButton!
    @IBOutlet private weak var nodeInfo: UILabel!
    private var mediaNodeSelector:MediaNodeSelector?
    private var mediaNode:MediaNode? {
        didSet {
            self.refresh()
        }
    }
    internal var selectableFilter:((_ mediaNode:MediaNode)->Bool)? {
        didSet {
            if mediaNode != nil {
                self.refresh()
            }
        }
    }
    internal var mediaNodeSelected:((_ mediaNode:MediaNode)->Void)? {
        didSet {
            if mediaNode != nil {
                self.refresh()
            }
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
    
    internal override init(frame: CGRect) {
        super.init(frame:frame)
        self.loadNibFromMediaNode(nibName: "ParentMediaNodeInfoView")
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.loadNibFromMediaNode(nibName: "ParentMediaNodeInfoView")
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
        self.shiftButton.isHidden = mediaNode.parent == nil
        
    }
    
    @IBAction private func onTapSelect(_ sender:Any){
        guard let mediaNode = self.mediaNode else { return }
        self.mediaNodeSelected?(mediaNode)
    }
    
    @IBAction private func onTapShift(_ sender:Any){
        guard let mediaNode = self.mediaNode,
              let mediaNodeSelector = self.mediaNodeSelector
        else { return }
        mediaNodeSelector.shiftNodeUp(node: mediaNode)
    }
    
}
