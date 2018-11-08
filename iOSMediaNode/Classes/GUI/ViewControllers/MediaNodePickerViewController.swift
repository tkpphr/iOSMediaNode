//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import UIKit

public class MediaNodePickerViewController : UIViewController,UINavigationBarDelegate {
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navigationTitle: UINavigationItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var selectButton: UIBarButtonItem!
    @IBOutlet private weak var mediaNodeExplorerView: MediaNodeExplorerView!
    @IBOutlet private weak var confirmMediaNodeSelectView: ConfirmMediaNodeSelectView!
    public var selected:((_ mediaNode:MediaNode) -> Void)?
    public var cancelled:(() -> Void)?
    public var selectableFilter:((_ mediaNode:MediaNode) -> Bool)?
    private var pickerTitle:String?
    private var startNode:MediaNode?
    private var isConfirming : Bool = false {
        didSet {
            if self.isConfirming {
                self.mediaNodeExplorerView.isHidden = true
                self.confirmMediaNodeSelectView.isHidden = false
                self.selectButton.isEnabled = true
            }else{
                self.mediaNodeExplorerView.isHidden = false
                self.confirmMediaNodeSelectView.isHidden = true
                self.selectButton.isEnabled = false
            }
        }
    }
    
    public init(pickerTitle:String?,startNode:MediaNode) {
        var bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        super.init(nibName: "MediaNodePickerViewController", bundle: bundle)
        self.pickerTitle = pickerTitle
        self.startNode = startNode
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.delegate = self
        if let pickerTitle = self.pickerTitle {
            self.navigationTitle.title = pickerTitle
        }
        if let mediaNode = self.startNode {
            self.mediaNodeExplorerView.mediaNodeSelected = self.onMediaNodeSelected
            self.mediaNodeExplorerView.selectableFilter = self.selectableFilter
            self.mediaNodeExplorerView.mediaNodeSelector = MediaNodeSelector(node: mediaNode)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction private func onTapCancel(_ sender:Any){
        self.confirmMediaNodeSelectView.stopSound()
        if self.isConfirming {
            self.isConfirming = false
        }else {
            self.dismiss(animated: true){
                [weak self] in
                self?.cancelled?()
            }
        }
    }
    
    @IBAction private func onTapSelect(_ sender:Any){
        self.confirmMediaNodeSelectView.stopSound()
        if let mediaNode = confirmMediaNodeSelectView.mediaNode {
            self.dismiss(animated: true){
                [weak self] in
                self?.selected?(mediaNode)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func didEnterBackground(){
        self.confirmMediaNodeSelectView.stopSound()
    }
    
    private func onMediaNodeSelected(_ mediaNode:MediaNode) {
        self.confirmMediaNodeSelectView.mediaNode = mediaNode
        self.isConfirming = true
    }
    
    
}
