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

open class MediaNodeSelector{
    public let rootNode:MediaNode
    public var currentNodeChanged:((_ currentNode:MediaNode) -> Void)?
    private(set) var selectedNodes:[MediaNode]
    open var currentNode : MediaNode? {
        get {
            return selectedNodes.last
        }
        set(node){
            guard let nextNode = node  else { return }
            if let currentNode = self.currentNode {
                if currentNode.fullPath != nextNode.fullPath {
                    self.selectedNodes.append(nextNode)
                }
            }
            self.currentNodeChanged?(nextNode)
        }
    }
    public var count : Int {
        return selectedNodes.count
    }
    
    public convenience init?(node:MediaNode){
        self.init(selectedNodes: [node])
    }
    
    public init?(selectedNodes:[MediaNode]){
        if selectedNodes.count == 0 {
            return nil
        }
        self.rootNode = selectedNodes.first!.root
        self.selectedNodes = selectedNodes
    }
    
    public func moveToAncestorPath(depth:Int) {
        guard let currentNode = self.currentNode else { return }
        let pathNames=currentNode.fullPath.components(separatedBy: "\\")
        if depth >= pathNames.count {
            return
        }
        var ancestorPath = ""
        ancestorPath.append(pathNames[0]);
        for i in 1..<depth+1 {
            ancestorPath.append("\\");
            ancestorPath.append(pathNames[i]);
        }
        if let ancestorNode = self.rootNode.find(path:ancestorPath) {
            self.currentNode = ancestorNode
        }
    }
    
    public func back() {
        self.selectedNodes = self.selectedNodes.filter{ self.rootNode.find(path: $0.fullPath) != nil }
        var previousNode = selectedNodes.popLast()
        while (self.count > 1 && previousNode === self.currentNode) {
            previousNode = self.selectedNodes.popLast()
        }
        if self.count >= 1 {
            self.currentNodeChanged?(currentNode!)
        } else {
            self.selectedNodes.append(previousNode!)
        }
    }
    
    public func shiftNodeUp(node:MediaNode){
        var dstNode:MediaNode? = nil
        if node.childCount<=0 || node.parent!.childCount>=2{
            dstNode = node.parent
        }else {
            dstNode = node.parent!.parent
        }
        if dstNode == nil {
            dstNode = self.rootNode
        }
        self.currentNode = dstNode
    }
    
    public func shiftNodeDown(node:MediaNode){
        var dstNode:MediaNode? = nil
        if(node.childCount<2){
            if(node.firstChild!.childCount == 0){
                dstNode = node
            }else {
                dstNode = node.firstChild
            }
        }else {
            dstNode = node
        }
        
        if dstNode != nil && dstNode!.fullPath != self.currentNode!.fullPath {
            self.currentNode = dstNode
        }
    }
}
