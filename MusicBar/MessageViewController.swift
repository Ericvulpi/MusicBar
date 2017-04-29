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

class QueryViewController: NSViewController {
    
    dynamic var QueryText: String = "Error"
    
    @IBOutlet weak var QueryResult: NSTextField!
    
    func displayMessage (query: String) -> QueryViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let View: QueryViewController = storyboard.instantiateController(withIdentifier: "QueryViewController") as! QueryViewController
        View.QueryText = query
        return View
    }
    
    @IBAction func QueryEditFinished(_ sender: Any) {
        self.QueryFinished(self)
    }
    
    @IBAction func QueryFinished(_ sender: Any) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.closeQueryWindow(sender as AnyObject)
    }
    
}
