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
class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let client = (NSApplication.shared.delegate as? AppDelegate)?.apollo
    @IBOutlet var arrayController: NSArrayController!
    @objc public var stories = NSArray()
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataSource = self
        let query = TestQueryQuery()
        client?.fetch(query: query){ (result, error) in
            debugPrint(result?.data?.me?.project?.stories!.compactMap{$0})
            self.stories = NSArray(array: result?.data?.me?.project?.stories!.compactMap{$0} ?? [Story(createdAt: "now", description: "test")])
            self.tableView.reloadData()

//            self.data?.me?.project?.stories?.compactMap{$0?.description as? String}.forEach{print($0)}
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        var str: String?
        switch tableColumn?.title {
        case "Description":
                        str = (stories[row] as! Story).description
        case "Created At":
                        str = (stories[row] as! Story).createdAt
        default:
            str = "oops"
        }
        print(str!)
        return str
//        let cell = tableView.
    }
}

