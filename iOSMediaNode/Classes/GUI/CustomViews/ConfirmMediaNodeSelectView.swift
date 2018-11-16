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
import AVKit

internal class ConfirmMediaNodeSelectView : UIView,AVAudioPlayerDelegate {
    @IBOutlet private weak var nodeName: UILabel!
    @IBOutlet private weak var nodeInfo: UILabel!
    @IBOutlet private weak var nodeImage: UIImageView!
    @IBOutlet private weak var playSoundButton: UIButton!
    @IBOutlet private weak var stopSoundButton: UIButton!
    @IBOutlet private weak var noneImageLabel: UILabel!
    internal var mediaNode:MediaNode? {
        didSet {
            self.refresh()
        }
    }
    private var sound : AVAudioPlayer?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibFromMediaNode(nibName: "ConfirmMediaNodeSelectView")
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibFromMediaNode(nibName: "ConfirmMediaNodeSelectView")
    }
    
    @IBAction private func onTapPlaySound(_ sender:Any){
        self.playSound()
    }
    
    @IBAction private func onTapStopSound(_ sender:Any){
        self.stopSound()
    }
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playSoundButton.isEnabled = true
        self.stopSoundButton.isEnabled = false
    }
    
    internal func refresh(){
        guard let mediaNode = self.mediaNode else { return }
        self.nodeName.text = mediaNode.nodeName
        self.nodeInfo.text = mediaNode.nodeInfo
        if let imageData = mediaNode.getImageData() {
            self.nodeImage.image = UIImage(data: imageData)
            self.nodeImage.isHidden = false
            self.noneImageLabel.isHidden = true
        } else {
            self.nodeImage.image = nil
            self.nodeImage.isHidden = true
            self.noneImageLabel.isHidden = false
        }
        if let soundData = mediaNode.getSoundData() {
            do {
                self.sound = try AVAudioPlayer(data: soundData)
                self.sound!.delegate = self
                self.playSoundButton.isEnabled = true
            }catch {
                print(error.localizedDescription)
                self.playSoundButton.isEnabled = false
            }
        }else{
            self.playSoundButton.isEnabled = false
        }
        self.stopSoundButton.isEnabled = false
    }
    
    internal func playSound(){
        if let sound = self.sound {
            if !sound.isPlaying {
                sound.play()
                self.playSoundButton.isEnabled = false
                self.stopSoundButton.isEnabled = true
            }
        }
    }
    
    internal func stopSound(){
        if let sound = self.sound {
            if sound.isPlaying {
                sound.stop()
                sound.currentTime = 0
                self.playSoundButton.isEnabled = true
                self.stopSoundButton.isEnabled = false
            }
        }
    }
    
    private func loadNib(){
        let nib = UINib(nibName: "ConfirmMediaNodeSelectView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}

