//Copyright (c) 2018-present tkpphr. All rights reserved.

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
