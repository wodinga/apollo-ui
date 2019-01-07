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
    private var stories = NSArray()
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetches query found in test.graphql
        let query = TestQueryQuery()
        client?.fetch(query: query){ (result, error) in
//            debugPrint(result?.data?.me?.project?.stories!.compactMap{$0})
            
            //Right now the graphQL
            self.stories = NSArray(array: result?.data?.me?.project?.stories!.compactMap{$0?.resultMap} ?? [Story(createdAt: "now", description: "test").resultMap])
            self.arrayController.content = self.stories
        }
    }
}

