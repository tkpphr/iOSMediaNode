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
