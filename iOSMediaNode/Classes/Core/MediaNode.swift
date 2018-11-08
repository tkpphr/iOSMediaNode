//Copyright (c) 2018-present tkpphr. All rights reserved.

import Foundation

open class MediaNode {
    private weak var _parent:MediaNode?
    private var _children:[MediaNode]
    open var nodeName:String
    open var imagePath: String
    open var soundPath: String
    open var nodeInfo:String{
        let ellipseLen = 30
        return "\(self.getFullPathInfo(ellipseLen))\n\(self.getImagePathInfo(ellipseLen))\n\(self.getSoundPathInfo(ellipseLen))"
    }
    
    public var parent:MediaNode?{
        return self._parent
    }
    public var children:[MediaNode]{
        return self._children
    }
    public var root:MediaNode{
        if let parent = self._parent{
            return parent.root
        }else{
            return self
        }
    }
    public var fullPath:String{
        get{
            return createFullPath(parent:self.parent,path:self.nodeName)
        }
    }
    public var firstChild:MediaNode? {
        get{
            return self._children.first
        }
    }
    public var lastChild:MediaNode? {
        get{
            return self._children.last
        }
    }
    public var childCount:Int{
        get{
            return self._children.count
        }
    }
    
    
    public convenience init(fullPath:String,parent:MediaNode?){
        let split=fullPath.components(separatedBy: "\\")
        self.init(parent:parent,nodeName:split[split.count-1])
    }
    
    public convenience init(nodeName:String){
        self.init(parent: nil, nodeName: nodeName)
    }
    
    public init(parent:MediaNode?,nodeName:String){
        self._parent = parent
        self._children = []
        self.nodeName = nodeName
        self.soundPath = ""
        self.imagePath = ""
    }
    
    public func find(path:String) -> MediaNode?{
        if self.fullPath == path {
            return self;
        }else{
            for child in self.children{
                if path.hasPrefix(child.fullPath) {
                    if path == child.fullPath {
                        return child
                    }else{
                        if let node = child.find(path: path){
                            return node
                        }
                    }
                }
            }
            return nil;
        }
    }
    
    public func findAll(filter:(_ node:MediaNode)->Bool) -> [MediaNode] {
        var foundList:[MediaNode]=[]
        if filter(self) {
            foundList.append(self)
        }
        self.children.forEach{ foundList.append(contentsOf: $0.findAll(filter: filter)) }
        return foundList
    }
    
    open func addChild(node: MediaNode) {
        self._children.append(node)
    }
    
    open func getChild(index: Int) -> MediaNode {
        return self._children[index]
    }
    
    open func setChild(index:Int){
        self._children = children
    }
    
    open func insertChild(index: Int, node: MediaNode) {
        self._children.insert(node, at: index)
    }
    
    open func removeChild(mediaNode: MediaNode) {
        if let index=self._children.index(where:{$0===mediaNode}){
            self._children.remove(at:index)
        }
    }
    
    open func removeChildAt(index: Int) {
        self._children.remove(at: index)
    }
    
    open func clearChildren() {
        self._children=[];
    }
    
    open func getImageData() -> Data? {
        return nil
    }
    
    open func getSoundData() -> Data? {
        return nil
    }
    
    public func indexOfChild(_ child:MediaNode) -> Int? {
        return self._children.index{ $0 === child}
    }
    
    private func createFullPath(parent:MediaNode?,path:String) -> String{
        if let parent = parent {
            return createFullPath(parent: parent.parent, path: parent.nodeName+"\\"+path)
        }else{
            return path
        }
    }
    
    public func getFullPathInfo(_ ellipseLen:Int) -> String{
        class dummy {}
        var bundle = Bundle(for: type(of: dummy()))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        var fullPath = self.fullPath
        if fullPath.count > ellipseLen {
            fullPath = "..." + String(fullPath.suffix(ellipseLen))
        }
        return "\(bundle.localizedString(forKey: "path", value: nil, table: nil)): \(fullPath)"
    }
    
    public func getImagePathInfo(_ ellipseLen:Int) -> String {
        class dummy {}
        var bundle = Bundle(for: type(of: dummy()))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        var imagePath = self.imagePath
        if FileManager.default.fileExists(atPath: imagePath) {
            imagePath = URL(fileURLWithPath: imagePath).lastPathComponent
        }else if imagePath.isEmpty || self.fullPath == imagePath {
            imagePath = bundle.localizedString(forKey: "none", value: nil, table: nil)
        }
        if imagePath.count > ellipseLen {
            imagePath="..."+String(imagePath.suffix(ellipseLen))
        }
        return "\(bundle.localizedString(forKey: "image", value: nil, table: nil)): \(imagePath)"
    }
    
    public func getSoundPathInfo(_ ellipseLen:Int) -> String {
        class dummy {}
        var bundle = Bundle(for: type(of: dummy()))
        if let path = bundle.path(forResource: "iOSMediaNode", ofType: "bundle"){
            bundle = Bundle(path: path)!
        }
        var soundPath = self.soundPath
        if FileManager.default.fileExists(atPath: soundPath) {
            soundPath = URL(fileURLWithPath: soundPath).lastPathComponent
        }else if soundPath.isEmpty || self.fullPath == soundPath {
            soundPath = bundle.localizedString(forKey: "none", value: nil, table: nil)
        }
        if soundPath.count > ellipseLen {
            soundPath="..."+String(soundPath.suffix(ellipseLen))
        }
        return "\(bundle.localizedString(forKey: "sound", value: nil, table: nil)): \(soundPath)"
    }
    
}
