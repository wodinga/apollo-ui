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
typealias ProjectLabel = TestQueryQuery.Data.Me.Project.Label
typealias ProjectMember = TestQueryQuery.Data.Me.Project.Member
typealias Owner = StoryDetails.Owner

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let client = (NSApplication.shared.delegate as? AppDelegate)?.apollo
    private var stories: [Story]?
    private var projectLabels: [ProjectLabel]?
    private var projectMembers: [ProjectMember]?
    private var storyViewController: StoryViewController?
    @IBOutlet weak var storyList: NSTableView!
    @IBOutlet weak var membersList: NSTableView!
    @IBOutlet weak var labelList: NSTableView!
    let defaults = NSUserDefaultsController.shared.defaults
    var query: TestQueryQuery?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyList.delegate = self
        storyList.dataSource = self
        membersList.delegate = self
        membersList.dataSource = self
        labelList.delegate = self
        labelList.dataSource = self
        let windowController = NSStoryboard.main!.instantiateController(withIdentifier: "details") as? NSWindowController
        windowController?.showWindow(self)
        
        storyViewController = windowController?.contentViewController as? StoryViewController

        
        //Fetches query found in test.graphql
        query = TestQueryQuery(token: defaults.string(forKey: "api_key")!, project_id: defaults.string(forKey: "project_id")!, limit: 30, filter: defaults.string(forKey: "filter") ?? "")
        client?.fetch(query: query!){ (result, error) in
            if(error == nil){
                self.stories = result?.data?.me?.project?.stories as? [Story]
                self.projectLabels = result?.data?.me?.project?.labels as? [ProjectLabel]
                self.projectMembers = result?.data?.me?.project?.members as? [ProjectMember]
                self.storyList.reloadData()
                self.labelList.reloadData()
                self.membersList.reloadData()
                self.storyViewController?.updateView(story: self.stories![0].fragments.storyDetails)
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == storyList{
            return stories?.count ?? 0
        } else if tableView == labelList {
            return projectLabels?.count ?? 0
        } else if tableView == membersList {
            return projectMembers?.count ?? 0

        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let details = stories?[row].fragments.storyDetails
        if tableView == storyList {
            if tableColumn?.identifier.rawValue == "name" {
                return details?.name ?? ""
            } else if tableColumn?.title == "Label" {
                return details?.labels?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
            } else if tableColumn?.title == "Owners" {
                return details?.owners?.compactMap{$0!.name}.reduce("", {"\($0!)\($1), "})
            } else if tableColumn?.identifier.rawValue == "time" {
                return details?.createdAt
            } else if tableColumn?.identifier.rawValue == "type" {
                return details?.storyType?.rawValue
            } else if tableColumn?.identifier.rawValue == "state" {
                return details?.currentState?.rawValue
            }
        } else if tableView == membersList {
            return projectMembers?[row].name
        } else if tableView == labelList {
            return projectLabels?[row].name
        }
        return "🚫"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = storyList.selectedRow
        self.storyViewController?.updateView(story: self.stories![index].fragments.storyDetails)
        
    }
}

