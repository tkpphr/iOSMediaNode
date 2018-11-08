//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class ChildMediaNodeTableView : UITableView,UITableViewDataSource {
    private var mediaNodeSelector : MediaNodeSelector?
    private var parentNode : MediaNode? {
        didSet {
            self.reloadData()
        }
    }
    internal var mediaNodeSelected : ((_ mediaNode:MediaNode) -> Void)? {
        didSet {
            if self.parentNode != nil {
                self.reloadData()
            }
        }
    }
    internal var selectableFilter:((_ mediaNode:MediaNode) -> Bool)? {
        didSet {
            if self.parentNode != nil {
                self.reloadData()
            }
        }
    }
    
    
    internal override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.commonInit()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    internal func reset(mediaNodeSelector:MediaNodeSelector,parentNode:MediaNode){
        self.mediaNodeSelector = mediaNodeSelector
        self.parentNode = parentNode
    }
    
    internal func refresh() {
        self.reloadData()
    }
    
    internal func scrollTo(_ mediaNode:MediaNode){
        DispatchQueue.main.async {
            [weak self] in
            if let index = self?.parentNode?.indexOfChild(mediaNode) {
                self?.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let parentNode = self.parentNode {
            return parentNode.childCount
        }else{
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "ChildMediaNodeInfo", for: indexPath) as! ChildMediaNodeInfoViewCell
        cell.mediaNodeSelected = self.mediaNodeSelected
        cell.selectableFilter = self.selectableFilter
        cell.reset(mediaNodeSelector: mediaNodeSelector!, mediaNode: parentNode!.getChild(index: indexPath.row))
        return cell
    }
    
    private func commonInit(){
        self.dataSource = self
        self.rowHeight = 128
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        self.register(UINib(nibName: "ChildMediaNodeInfoViewCell", bundle: bundle), forCellReuseIdentifier: "ChildMediaNodeInfo")
    }
    
}
