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

internal class MediaNodePathBar : UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var collectionView: UICollectionView!
    internal var mediaNode: MediaNode?{
        didSet{
            self.refresh()
        }
    }
    internal var ancestorTapped:((_ depth:Int) -> Void)? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var pathNames:[String]? {
        didSet {
            self.collectionView.reloadData()
            self.scrollToEnd()
        }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibFromMediaNode(nibName: "MediaNodePathBar")
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibFromMediaNode(nibName: "MediaNodePathBar")
    }
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        self.collectionView.register(UINib(nibName:"MediaNodePathAncestorCell",bundle:bundle), forCellWithReuseIdentifier: "MediaNodePathAncestor")
        self.collectionView.register(UINib(nibName:"MediaNodePathLastCell",bundle:bundle), forCellWithReuseIdentifier: "MediaNodePathLast")
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let components = self.pathNames {
            return components.count
        }else{
            return 0
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.pathNames!.count - 1 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MediaNodePathLast", for: indexPath) as! MediaNodePathLastCell
            cell.reset(self.pathNames![indexPath.row])
            return cell
        }else{
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MediaNodePathAncestor", for: indexPath) as! MediaNodePathAncestorCell
            cell.reset(pathName: pathNames![indexPath.row], depth: indexPath.row)
            cell.tapped = self.ancestorTapped
            return cell
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 48)
    }
    
    internal func refresh(){
        self.pathNames = self.mediaNode?.fullPath.components(separatedBy: "\\")
    }
    
    internal func scrollToEnd(){
        DispatchQueue.main.async {
            [weak self] in
            guard let itemCount = self?.pathNames?.count else { return }
            self?.collectionView?.scrollToItem(at: IndexPath(item: itemCount - 1, section: 0), at:.right , animated: false)
        }
    }
}
