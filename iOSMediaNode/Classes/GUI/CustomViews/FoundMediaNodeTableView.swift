//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

internal class FoundMediaNodeTableView : UITableView,UITableViewDataSource {
    internal var mediaNodeSelected : ((_ mediaNode:MediaNode) -> Void)? {
        didSet {
            if self.mediaNodeSelector != nil {
                self.reloadData()
            }
        }
    }
    internal var selectableFilter:((_ mediaNode:MediaNode) -> Bool)? {
        didSet {
            if self.mediaNodeSelector != nil {
                self.reloadData()
            }
        }
    }
    private var mediaNodeSelector:MediaNodeSelector?
    private var foundList:[MediaNode]? {
        didSet {
            self.reloadData()
        }
    }
    private var searchString:String? {
        didSet {
            guard let searchString = self.searchString,let mediaNodeSelector = self.mediaNodeSelector else { return }
            if searchString.isEmpty {
                return
            }
            var foundList = mediaNodeSelector.rootNode.findAll{ $0.nodeName.contains(searchString) }
            foundList.sort(by: { (left,right) -> Bool in left.nodeName < right.nodeName })
            self.foundList = foundList
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
    
    
    internal func reset(mediaNodeSelector:MediaNodeSelector,searchString:String){
        self.mediaNodeSelector = mediaNodeSelector
        self.searchString = searchString
    }
    
    internal func refresh(){
        self.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let foundList = self.foundList {
            return foundList.count
        }else{
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "FoundMediaNodeInfo", for: indexPath) as! FoundMediaNodeInfoViewCell
        cell.mediaNodeSelected = self.mediaNodeSelected
        cell.selectableFilter = self.selectableFilter
        cell.reset(mediaNodeSelector: mediaNodeSelector!, mediaNode: self.foundList![indexPath.row])
        return cell
    }
    
    private func commonInit(){
        
        self.dataSource = self
        self.rowHeight = 128.0
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        self.register(UINib(nibName: "FoundMediaNodeInfoViewCell", bundle: bundle), forCellReuseIdentifier: "FoundMediaNodeInfo")
    }
}
