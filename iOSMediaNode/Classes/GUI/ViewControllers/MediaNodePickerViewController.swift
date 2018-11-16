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
