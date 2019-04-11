//
//  StoryViewController.swift
//  ApolloUI
//
//  Created by Garcia, David on 3/5/19.
//  Copyright © 2019 David Garcia. All rights reserved.
//

import Cocoa

//typealias Owner = TestQueryQuery.Data.St

class StoryViewController: NSViewController, NSTableViewDataSource {

    @IBOutlet weak var labelsList: NSTableView!
    @IBOutlet weak var ownersList: NSTableView!
    @IBOutlet weak var dateField: NSTextField!
    @IBOutlet weak var typeField: NSTextField!
    @IBOutlet weak var stateField: NSTextField!
    @IBOutlet weak var nameField: NSTextField!
    
    public var labels = [String?]()
    public var owners = [String?]()
    public var date: String? {
        didSet{
            dateField.stringValue = date ?? ""
        }
    }
    public var type: String? {
        didSet{
            typeField.stringValue = type ?? ""
        }
    }
    public var state: String? {
        didSet{
            stateField.stringValue = state ?? ""
        }
    }
    
    public var name: String? {
        didSet{
            nameField.stringValue = name ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    public func updateView(story: StoryDetails){
        labels = (story.labels?.compactMap{$0!.name})!
        owners = (story.owners?.compactMap{$0!.fragments.personDetails.name})!
//        owners = (story.owners?.compactMap{$0)!
        date = story.createdAt
        type = story.storyType?.rawValue
        state = story.currentState?.rawValue
        name = story.name
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == labelsList {
            return labels.count
        } else if tableView == ownersList {
            return owners.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView == labelsList {
            return labels[row]
        } else if tableView == ownersList {
            return owners[row]
        }
        return nil
    }
}
