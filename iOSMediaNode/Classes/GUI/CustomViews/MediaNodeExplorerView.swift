//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class MediaNodeExplorerView : UIView,UISearchBarDelegate{
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var mediaNodeSelectorView: MediaNodeSelectorView!
    @IBOutlet private weak var mediaNodePathBar: MediaNodePathBar!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var mediaNodePathView: UIStackView!
    @IBOutlet private weak var foundMediaNodeTableView: FoundMediaNodeTableView!
    public override var isHidden: Bool {
        didSet {
            if self.isSearchEnabled && self.searchBar.isFirstResponder {
                self.searchBar.resignFirstResponder()
            }
        }
    }
    public var mediaNodeSelector: MediaNodeSelector? {
        didSet {
            guard let mediaNodeSelector = self.mediaNodeSelector else { return }
            self.mediaNodeSelector?.currentNodeChanged = self.onCurrentNodeChanged
            self.mediaNodeSelectorView.reset(mediaNodeSelector: mediaNodeSelector, mediaNode: mediaNodeSelector.currentNode!)
            self.backButton.isEnabled = false
            self.mediaNodePathBar.mediaNode = mediaNodeSelector.currentNode
            DispatchQueue.main.async {
                [weak self] in
                self?.mediaNodePathBar?.scrollToEnd()
                self?.mediaNodeSelectorView?.refresh()
            }
        }
    }
    public var currentNode:MediaNode? {
        get {
            return self.mediaNodeSelector?.currentNode
        }
        set(currentNode) {
            guard let mediaNode = currentNode,
                let mediaNodeSelector = self.mediaNodeSelector
                else {
                    return
            }
            mediaNodeSelector.currentNode = mediaNode
        }
    }
    public var mediaNodeSelected:((_ mediaNode:MediaNode) -> Void)? {
        didSet {
            self.mediaNodeSelectorView.mediaNodeSelected = self.mediaNodeSelected
            self.foundMediaNodeTableView.mediaNodeSelected = self.mediaNodeSelected
        }
    }
    public var selectableFilter:((_ mediaNode:MediaNode) -> Bool)? {
        didSet {
            self.mediaNodeSelectorView.selectableFilter = self.selectableFilter
            self.foundMediaNodeTableView.selectableFilter = self.selectableFilter
        }
    }
    private var isSearchEnabled : Bool = false {
        didSet {
            if self.isSearchEnabled {
                self.searchBar.isHidden = false
                self.foundMediaNodeTableView.isHidden = false
                self.mediaNodePathView.isHidden = true
                self.mediaNodeSelectorView.isHidden = true
                self.backButton.isEnabled = true
            }else{
                self.searchBar.isHidden = true
                self.foundMediaNodeTableView.isHidden = true
                self.mediaNodePathView.isHidden = false
                self.mediaNodeSelectorView.isHidden = false
                if self.searchBar.isFirstResponder {
                    self.searchBar.resignFirstResponder()
                }
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibFromMediaNode(nibName: "MediaNodeExplorerView")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibFromMediaNode(nibName: "MediaNodeExplorerView")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        self.searchBar.delegate = self
        self.searchBar.placeholder = bundle.localizedString(forKey: "search_by_node_name", value:nil, table:nil)
        if let image = ((self.searchBar.value(forKey: "_searchField") as? UITextField)?.leftView as? UIImageView)?.image {
            self.searchButton.setImage(image, for: .normal)
        }else{
            self.searchButton.setTitle(bundle.localizedString(forKey: "search", value:nil, table: "Localizable"), for: .normal)
        }
        self.mediaNodePathBar.ancestorTapped = self.onTapPath
        
    }
    
    @IBAction private func onTapSearch(_ sender:Any){
        self.isSearchEnabled = true
    }
    
    @IBAction private func onTapBack(_ sender:Any){
        self.back()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let mediaNodeSelector = self.mediaNodeSelector {
            self.foundMediaNodeTableView.reset(mediaNodeSelector: mediaNodeSelector, searchString: searchText.lowercased())
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    public func moveTo(_ mediaNode:MediaNode){
        guard let mediaNodeSelector = self.mediaNodeSelector else { return }
        self.isSearchEnabled = false
        if mediaNodeSelector.currentNode === mediaNode {
            self.refresh()
        }else {
            mediaNodeSelector.currentNode = mediaNode
        }
    }
    
    public func moveTo(parentMediaNode:MediaNode,childMediaNode:MediaNode){
        self.moveTo(parentMediaNode)
        self.mediaNodeSelectorView.scrollToChild(childMediaNode)
    }
    
    public func refresh(){
        self.mediaNodePathBar.refresh()
        self.mediaNodeSelectorView.refresh()
        self.foundMediaNodeTableView.refresh()
    }
    
    public func back(){
        guard let mediaNodeSelector = self.mediaNodeSelector else { return }
        if self.isSearchEnabled {
            self.isSearchEnabled = false
        } else {
            mediaNodeSelector.back()
        }
        self.backButton.isEnabled = mediaNodeSelector.count > 1
    }
    
    private func onTapPath(_ depth:Int) {
        self.mediaNodeSelector?.moveToAncestorPath(depth: depth)
    }
    
    private func onCurrentNodeChanged(_ mediaNode:MediaNode) {
        self.isSearchEnabled = false
        self.backButton.isEnabled = mediaNodeSelector!.count > 1
        self.mediaNodePathBar.mediaNode = mediaNode
        self.mediaNodeSelectorView.reset(mediaNodeSelector: mediaNodeSelector!, mediaNode: mediaNode)
    }
}
