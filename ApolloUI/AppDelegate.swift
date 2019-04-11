//
//  AppDelegate.swift
//  ApolloUI
//
//  Created by David Garcia on 12/27/18.
//  Copyright © 2018 David Garcia. All rights reserved.
//

import Cocoa
import Apollo

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

//    let apollo = ApolloClient(url: URL(string: "http://tracker-graphql.apps-np.homedepot.com")!)
    let apollo = ApolloClient(url: URL(string: "http://192.168.1.6:8080")!)
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        let query = TestQueryQuery()
//        apollo.fetch(query: query){ (result, error) in
//            guard let data = result?.data else { return }
//            data.me?.project?.stories?.compactMap{$0?.description as? String}.forEach{print($0)}
//        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

