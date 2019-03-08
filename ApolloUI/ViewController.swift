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
typealias Label = StoryDetails.Label
typealias Owner = StoryDetails.Owner

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let client = (NSApplication.shared.delegate as? AppDelegate)?.apollo
    private var stories: [Story]?
    private var storyViewController: StoryViewController?
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let windowController = NSStoryboard.main!.instantiateController(withIdentifier: "details") as? NSWindowController
        windowController?.showWindow(self)
        
        storyViewController = windowController?.contentViewController as? StoryViewController
        
        //Fetches query found in test.graphql
//        let query = TestQueryQuery(token: "6460ea07df7608e56028f7f8a009c08d", limit: 3, filter: "ic release")
        let query = TestQueryQuery(token: "6460ea07df7608e56028f7f8a009c08d", project_id: "1890409", limit: 30, filter: "ic release")
        client?.fetch(query: query){ (result, error) in
            self.stories = result?.data?.me?.project?.stories as? [Story]
            self.tableView.reloadData()
            self.storyViewController?.updateView(story: self.stories![0].fragments.storyDetails)
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stories?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let details = stories?[row].fragments.storyDetails
        if tableColumn?.title == "Story" {
            return details?.name ?? ""
        } else if tableColumn?.title == "Label" {
          return details?.labels?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
        } else if tableColumn?.title == "Owners" {
            return details?.owners?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
        } else if tableColumn?.title == "Date" {
            return details?.createdAt
        } else if tableColumn?.title == "Story Type" {
          return details?.storyType?.rawValue
        } else if tableColumn?.title == "Current State" {
            return details?.currentState?.rawValue
        }
        return "🚫"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = tableView.selectedRow
        self.storyViewController?.updateView(story: self.stories![index].fragments.storyDetails)
        
    }
}

