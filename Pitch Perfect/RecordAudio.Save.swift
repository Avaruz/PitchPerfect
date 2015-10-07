//
//  RecordAudio.Save.swift
//  Pitch Perfect
//
//  Created by Adhemar Soria Galvarro on 5/10/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//

import Foundation

class RecordedAudio:NSObject {
    var filePathUrl:NSURL!
    var title: String!
    
    init(filePathUrl:NSURL, title:String) {
        self.filePathUrl=filePathUrl
        self.title=title
    }
}
