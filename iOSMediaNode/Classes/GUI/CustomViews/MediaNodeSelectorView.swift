//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class MediaNodeSelectorView : UIView {
    @IBOutlet private weak var parentMediaNodeInfoView: ParentMediaNodeInfoView!
    @IBOutlet private weak var childMediaNodeTableView: ChildMediaNodeTableView!
    internal var mediaNodeSelected:((_ mediaNode:MediaNode)->Void)? {
        didSet {
            self.parentMediaNodeInfoView.mediaNodeSelected = mediaNodeSelected
            self.childMediaNodeTableView.mediaNodeSelected = mediaNodeSelected
        }
    }
    internal var selectableFilter:((_ mediaNode:MediaNode) -> Bool)? {
        didSet {
            self.parentMediaNodeInfoView.selectableFilter = self.selectableFilter
            self.childMediaNodeTableView.selectableFilter = self.selectableFilter
        }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibFromMediaNode(nibName: "MediaNodeSelectorView")
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibFromMediaNode(nibName: "MediaNodeSelectorView")
    }
    
    internal func reset(mediaNodeSelector:MediaNodeSelector,mediaNode:MediaNode){
        self.parentMediaNodeInfoView.reset(mediaNodeSelector: mediaNodeSelector, mediaNode: mediaNode)
        self.childMediaNodeTableView.reset(mediaNodeSelector: mediaNodeSelector, parentNode: mediaNode)
    }
    
    internal func refresh(){
        self.parentMediaNodeInfoView.refresh()
        self.childMediaNodeTableView.refresh()
    }
    
    internal func scrollToChild(_ childMediaNode:MediaNode){
        self.childMediaNodeTableView.scrollTo(childMediaNode)
    }
    
}
