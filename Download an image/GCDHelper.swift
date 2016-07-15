//
//  GCDHelper.swift
//  Download an image
//
//  Created by Daniel J Janiak on 7/14/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
