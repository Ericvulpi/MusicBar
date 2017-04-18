//
//  MessageViewController.swift
//  MusicBar
//
//  Created by Eric de Vulpillières on 18/03/2017.
//  Copyright © 2017 Tungsten. All rights reserved.
//

import Cocoa

class MessageViewController: NSViewController {

    dynamic var Message: String = "Search Error"
    
    func displayMessage (message: String) -> MessageViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let View: MessageViewController = storyboard.instantiateController(withIdentifier: "MessageViewController") as! MessageViewController
        View.Message = message
        return View
    }
    
}
