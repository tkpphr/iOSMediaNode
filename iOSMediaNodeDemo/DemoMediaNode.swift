//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation
import iOSMediaNode

public class DemoMediaNode : MediaNode {
    
    init(parent: MediaNode?, nodeName: String,imagePath:String?,soundPath:String?) {
        super.init(parent: parent, nodeName: nodeName)
        self.imagePath = imagePath ?? ""
        self.soundPath = soundPath ?? ""
    }
    
    public override func getImageData() -> Data? {
        if FileManager.default.fileExists(atPath: self.imagePath){
            do {
                return try Data(contentsOf: URL(fileURLWithPath: self.imagePath))
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public override func getSoundData() -> Data? {
        if FileManager.default.fileExists(atPath: self.soundPath){
            do {
                return try Data(contentsOf: URL(fileURLWithPath: self.soundPath))
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

