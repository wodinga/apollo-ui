//
//  Story.swift
//  ApolloUI
//
//  Created by David Garcia on 4/8/19.
//  Copyright © 2019 David Garcia. All rights reserved.
//

import Cocoa

class StoryModel: NSObject {
    var labels: [LabelModel]?
    var owners: [PersonModel]
    
    init(owners: [PersonModel]) {
        self.owners = owners
        super.init()
    }
}
