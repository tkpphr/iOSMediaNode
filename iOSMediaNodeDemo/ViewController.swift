//Copyright (c) 2018-present tkpphr. All rights reserved.

import UIKit
import iOSMediaNode
import AVKit

public class ViewController: UIViewController,UIDocumentPickerDelegate,AVAudioPlayerDelegate {
    @IBOutlet private weak var selectNodeButton: UIButton!
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var selectSoundButton: UIButton!
    @IBOutlet private weak var playSoundButton: UIButton!
    @IBOutlet private weak var stopSoundButton: UIButton!
    @IBOutlet private weak var selectedNodeLabel: UILabel!
    @IBOutlet private weak var nodeImageView: UIImageView!
    public var selectedNode : MediaNode? {
        didSet {
            guard let selectedNode = self.selectedNode else { return }
            self.selectedNodeLabel.text = NSLocalizedString("selected", comment: "") + ": " + selectedNode.nodeName
            self.imageData = selectedNode.getImageData()
            self.soundData = selectedNode.getSoundData()
        }
    }
    public var imageData :Data? {
        didSet{
            if let imageData = self.imageData {
                self.nodeImageView.image = UIImage(data: imageData)
                self.nodeImageView.isHidden = false
            }else{
                self.nodeImageView.isHidden = true
            }
        }
    }
    public var soundData :Data? {
        didSet {
            if let soundData = self.soundData {
                do {
                    self.sound = try AVAudioPlayer(data: soundData)
                    self.sound!.delegate = self
                    self.playSoundButton.isEnabled = true
                    self.stopSoundButton.isEnabled = false
                }catch {
                    print(error.localizedDescription)
                    self.playSoundButton.isEnabled = false
                    self.stopSoundButton.isEnabled = false
                }
            }else{
                self.playSoundButton.isEnabled = false
                self.stopSoundButton.isEnabled = false
            }
        }
    }
    public var sound : AVAudioPlayer?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedNode = self.createTree()
    }
    
    @IBAction private func selectNodeTapped(_ sender:Any) {
        let startNode = self.selectedNode!.childCount > 0 ? self.selectedNode : self.selectedNode?.parent
        let picker = MediaNodePickerViewController(pickerTitle: NSLocalizedString("test", comment: ""), startNode: startNode!)
        
        picker.selectableFilter = { mediaNode in mediaNode !== self.selectedNode }
        picker.selected = self.onSelected
        picker.cancelled = self.onCancelled
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func selectImageTapped(_ sender:Any) {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .open)
        if #available(iOS 11.0, *) {
            picker.allowsMultipleSelection = false
        }
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func selectSoundTapped(_ sender:Any) {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .open)
        if #available(iOS 11.0, *) {
            picker.allowsMultipleSelection = false
        }
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func playSoundTapped(_ sender:Any) {
        if let sound = self.sound {
            if !sound.isPlaying {
                sound.play()
                self.playSoundButton.isEnabled = false
                self.stopSoundButton.isEnabled = true
            }
        }
    }
    
    @IBAction private func stopSoundTapped(_ sender:Any) {
        if let sound = self.sound {
            if sound.isPlaying {
                sound.stop()
                sound.currentTime = 0
                self.playSoundButton.isEnabled = true
                self.stopSoundButton.isEnabled = false
            }
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        print(url.pathExtension)
        if url.pathExtension == "wav" || url.pathExtension == "mp3" {
            self.selectedNode!.soundPath = url.path
            if let soundData = selectedNode!.getSoundData() {
                do {
                    self.sound = try AVAudioPlayer(data: soundData)
                    self.sound!.delegate = self
                    self.playSoundButton.isEnabled = true
                    self.stopSoundButton.isEnabled = false
                }catch {
                    print(error.localizedDescription)
                    self.playSoundButton.isEnabled = false
                    self.stopSoundButton.isEnabled = false
                }
            }else{
                self.playSoundButton.isEnabled = false
                self.stopSoundButton.isEnabled = false
            }
        }else{
            self.selectedNode!.imagePath = url.path
            if let imageData = selectedNode!.getImageData() {
                self.nodeImageView.image = UIImage(data: imageData)
                self.nodeImageView.isHidden = false
            }else{
                self.nodeImageView.isHidden = true
            }
        }
        print(url)
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playSoundButton.isEnabled = true
        self.stopSoundButton.isEnabled = false
    }
    
    private func onSelected(_ mediaNode:MediaNode){
        self.selectedNode = mediaNode
    }
    
    private func onCancelled(){
        print("Cancelled")
    }
    
    private func createTree() -> DemoMediaNode {
        let root = DemoMediaNode(parent: nil, nodeName: "root", imagePath: Bundle.main.path(forResource: "parent_root", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav"))
        root.addChild(node: DemoMediaNode(parent: root, nodeName: "child1", imagePath: Bundle.main.path(forResource: "child_1", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_2", ofType: ".wav")))
        root.addChild(node: DemoMediaNode(parent: root, nodeName: "child2", imagePath: Bundle.main.path(forResource: "child_2", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav")))
        root.addChild(node: DemoMediaNode(parent: root, nodeName: "child3", imagePath: Bundle.main.path(forResource: "child_3", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_3", ofType: ".wav")))
        root.addChild(node: DemoMediaNode(parent: root, nodeName: "child4", imagePath: Bundle.main.path(forResource: "child_4", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav")))
        let child1 = root.getChild(index: 0)
        child1.addChild(node: DemoMediaNode(parent: child1, nodeName: "grandchild1", imagePath: Bundle.main.path(forResource: "grand_child_1", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav")))
        child1.addChild(node: DemoMediaNode(parent: child1, nodeName: "grandchild2", imagePath: Bundle.main.path(forResource: "grand_child_2", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav")))
        let child2 = root.getChild(index: 1)
        child2.addChild(node: DemoMediaNode(parent: child2, nodeName: "grandchild3", imagePath: Bundle.main.path(forResource: "grand_child_3", ofType: ".png"), soundPath: Bundle.main.path(forResource: "sound_1", ofType: ".wav")))
        return root
    }
    
    
    
    
}

