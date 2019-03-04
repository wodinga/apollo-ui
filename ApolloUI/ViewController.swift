//
//  ViewController.swift
//  ApolloUI
//
//  Created by David Garcia on 12/27/18.
//  Copyright © 2018 David Garcia. All rights reserved.
//

import Cocoa
import Apollo

typealias Story = TestQueryQuery.Data.Me.Project.Story
typealias Label = TestQueryQuery.Data.Me.Project.Story.Label
typealias Owner = TestQueryQuery.Data.Me.Project.Story.Owner

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let client = (NSApplication.shared.delegate as? AppDelegate)?.apollo
    private var stories: [Story]?
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Fetches query found in test.graphql
//        let query = TestQueryQuery()
        let query = TestQueryQuery(token: "6460ea07df7608e56028f7f8a009c08d", limit: 3, filter: "ic release")
        client?.fetch(query: query){ (result, error) in
            self.stories = result?.data?.me?.project?.stories as? [Story]
            self.tableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stories?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "Story" {
            return stories?[row].name ?? ""
        } else if tableColumn?.title == "Label" {
          return stories?[row].labels?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
        } else if tableColumn?.title == "Owners" {
            return stories?[row].owners?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
        } else if tableColumn?.title == "Date" {
            return stories?[row].createdAt
        } else if tableColumn?.title == "Story Type" {
          return stories?[row].storyType?.rawValue
        } else if tableColumn?.title == "Current State" {
            return stories?[row].currentState?.rawValue
        }
        return "🚫"
    }
}

