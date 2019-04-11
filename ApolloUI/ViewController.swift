//
//  ViewController.swift
//  ApolloUI
//
//  Created by David Garcia on 12/27/18.
//  Copyright © 2018 David Garcia. All rights reserved.
//

import Cocoa
import Apollo


typealias Story = StoryDetails
typealias Label = Story.Label
typealias ProjectLabel = TestQueryQuery.Data.Me.Project.Label
typealias ProjectMember = TestQueryQuery.Data.Me.Project.Member.Person
typealias Owner = Story.Owner
typealias Person = PersonDetails

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let client = (NSApplication.shared.delegate as? AppDelegate)?.apollo
    private var stories: [Story]?
    private var projectLabels: [ProjectLabel]?
    private var projectMembers: [Person]?
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
        query = TestQueryQuery(token: defaults.string(forKey: "api_key")!, project_id: defaults.string(forKey: "project_id")!, limit: 30, filter: defaults.string(forKey: "filter") ?? "inventory commons")
        client?.fetch(query: query!){ (result, error) in
            if(error == nil){
                self.stories = result?.data?.me?.project?.stories?.compactMap{$0!.fragments.storyDetails}
                self.projectLabels = result?.data?.me?.project?.labels?.compactMap{$0}.sorted{label1, label2 in
                    label1.updatedAt! > label2.updatedAt!
                }
                self.projectMembers = result?.data?.me?.project?.members?.compactMap{$0?.person.fragments.personDetails}
                self.storyList.reloadData()
                self.labelList.reloadData()
                self.membersList.reloadData()
                self.storyViewController?.updateView(story: self.stories![0])
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
        
        switch tableView {
            case storyList:
                let details = stories?[row]
                switch tableColumn?.identifier.rawValue {
                case "Description":
                    return details?.name ?? ""
                case "Date":
                    return details?.createdAt
                default:
                    return "🚫"
                }
            case membersList:
                return projectMembers?[row].name
            case labelList:
                return projectLabels?[row].name
            default:
                return "🚫"
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = storyList.selectedRow
        if index >= 0{
            self.storyViewController?.updateView(story: self.stories![index])
        }
        
    }
}

