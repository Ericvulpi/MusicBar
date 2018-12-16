//
//  AppDelegate.swift
//  MusicBar
//
//  Created by Eric de Vulpillières on 28/01/2017.
//  Copyright © 2017 Tungsten. All rights reserved.
//

import Cocoa
import AppleScriptObjC
import Foundation
import ServiceManagement

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    // AppleScriptObjC object for communicating with iTunes
    var iTunesBridge: iTunesBridge
    var spotifyBridge: spotifyBridge
    
    var iTunes: AnyObject!
    var spotify: AnyObject!
    var currentApp: String!
    var title: NSString!
    var artist: NSString!
    var album: NSString!
    var iconDic = [String: String]()
    let DefaultCurrentApp: String = "iTunes"
    
    let menu = NSMenu()
    let viewSettingsSubmenu = NSMenu()
    let otherSettingsSubmenu = NSMenu()
    let countryCodeButton = NSMenuItem()

    let MusicBarSI = NSStatusBar.system().statusItem(withLength: 20)
    let Separator1SI = NSStatusBar.system().statusItem(withLength: 10)
    let FwdSI = NSStatusBar.system().statusItem(withLength: 18)
    let PlayPauseSI = NSStatusBar.system().statusItem(withLength: 18)
    let BackSI = NSStatusBar.system().statusItem(withLength: 18)
    let Separator2SI = NSStatusBar.system().statusItem(withLength: -1)
    let SwitchAppSI = NSStatusBar.system().statusItem(withLength: -1)
    let TextEdgeRightSI = NSStatusBar.system().statusItem(withLength: -1)
    let ArtistBarSI = NSStatusBar.system().statusItem(withLength: -1)
    let Separator3SI = NSStatusBar.system().statusItem(withLength: -1)
    let TitleBarSI = NSStatusBar.system().statusItem(withLength: -1)
    let TextEdgeLeftSI = NSStatusBar.system().statusItem(withLength: -1)
    let ArtworkSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star5SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star4SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star3SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star2SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star1SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
//    let HeartSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let LeftEdgeSI = NSStatusBar.system().statusItem(withLength: 10)
    
    let Popover = NSPopover()
    var eventMonitor: EventMonitor?

    // Cocoa Bindings
    @objc dynamic var trackName: NSString!
    @objc dynamic var trackArtist: NSString!
    @objc dynamic var trackAlbum: NSString!
    
    @objc dynamic var trackDuration: NSNumber!
    
    @objc dynamic var soundVolume: NSNumber! {
        get {
            if currentApp == "iTunes" {
                return self.iTunesBridge.isRunning ? self.iTunesBridge.soundVolume : 0
            } else {
                return self.spotifyBridge.isRunning ? self.spotifyBridge.soundVolume : 0
            }
        }
        set(value) {
            if currentApp == "iTunes" {
                self.iTunesBridge.soundVolume = value
            } else {
                self.spotifyBridge.soundVolume = value
            }
        }
    }
    
    override init() {
        currentApp = DefaultCurrentApp
        // AppleScriptObjC setup
        Bundle.main.loadAppleScriptObjectiveCScripts()
        
        // create an instance of iTunesBridge script object for Swift code to use
        let iTunesBridgeClass: AnyClass = NSClassFromString("iTunesBridge")!
        self.iTunesBridge = iTunesBridgeClass.alloc() as! iTunesBridge
        
        if LSCopyApplicationURLsForBundleIdentifier("com.spotify.client" as CFString, nil) != nil {
            let spotifyBridgeClass: AnyClass = NSClassFromString("spotifyBridge")!
            self.spotifyBridge = spotifyBridgeClass.alloc() as! spotifyBridge
        } else {
            let spotifyBridgeClass: AnyClass = NSClassFromString("emptyBridge")!
            self.spotifyBridge = spotifyBridgeClass.alloc() as! spotifyBridge
        }
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Variables initialization
        //iTunes = SBApplication.init(bundleIdentifier: "com.apple.iTunes")
        //spotify = SBApplication.init(bundleIdentifier: "com.spotify.client")
    
        
        // MusicBar Button and menu setup
        MusicBarSI.menu = menu
        
        menu.addItem(NSMenuItem(title: "Search YouTube", action: #selector(searchYouTube), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Search iTunes Store", action: #selector(searchITunesStore), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Search Last.fm", action: #selector(searchLastFM), keyEquivalent: ""))
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "View Settings", action: nil, keyEquivalent: ""))
        menu.item(withTitle: "View Settings")?.submenu = viewSettingsSubmenu
        viewSettingsSubmenu.addItem(NSMenuItem(title: "Black Style", action: #selector(toggleBlackStyle), keyEquivalent: ""))
        viewSettingsSubmenu.addItem(NSMenuItem(title: "Switch Player Button", action: #selector(toggleSwitchAppButton), keyEquivalent: ""))
        viewSettingsSubmenu.addItem(NSMenuItem(title: "Track information", action: #selector(toggleTrackInfo), keyEquivalent: ""))
        viewSettingsSubmenu.addItem(NSMenuItem(title: "iTunes Ratings", action: #selector(toggleRatings), keyEquivalent: ""))
        
        menu.addItem(NSMenuItem(title: "Other Settings", action: nil, keyEquivalent: ""))
        menu.item(withTitle: "Other Settings")?.submenu = otherSettingsSubmenu
        otherSettingsSubmenu.addItem(NSMenuItem(title: "Auto launch at login", action: #selector(toggleAutoLaunch), keyEquivalent: ""))
        countryCodeButton.action = #selector(changeItunesStoreCountry)
        otherSettingsSubmenu.addItem(countryCodeButton)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "About MusicBar", action: #selector(aboutMusicBar), keyEquivalent: ""))
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared().terminate), keyEquivalent: ""))
        
        
        // Initiate settings buttons
        
        if UserDefaults.standard.bool(forKey: "MusicBarBlackStyle") {
            viewSettingsSubmenu.item(withTitle: "Black Style")?.state = 1
        } else {
            viewSettingsSubmenu.item(withTitle: "Black Style")?.state = 0
        }
        
        if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
            viewSettingsSubmenu.item(withTitle: "Switch Player Button")?.state = 1
        } else {
            viewSettingsSubmenu.item(withTitle: "Switch Player Button")?.state = 0
        }
        
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo") {
            viewSettingsSubmenu.item(withTitle: "Track information")?.state = 1
        } else {
            viewSettingsSubmenu.item(withTitle: "Track information")?.state = 0
        }
        
        if UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            viewSettingsSubmenu.item(withTitle: "iTunes Ratings")?.state = 1
        } else {
            viewSettingsSubmenu.item(withTitle: "iTunes Ratings")?.state = 0
        }
        
        if UserDefaults.standard.bool(forKey: "MusicBarAutoLaunch") {
            otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 1
        } else {
            otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 0
        }
                
        if UserDefaults.standard.string(forKey: "MusicBarITunesStoreCountry") == nil {
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                UserDefaults.standard.setValue(countryCode, forKey: "MusicBarITunesStoreCountry")
            }
        }
        countryCodeButton.title = "Edit iTunes Store Country"

        
        // Switch music application button
        if let CurrentAppButton = SwitchAppSI.button {
            CurrentAppButton.action = #selector(switchMusicApp)
        }
        
        
        // Music controls setup
        if let BackButton = BackSI.button {
            BackButton.action = #selector(backFunc)
        }
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.action = #selector(playpauseFunc)
        }
        if let FwdButton = FwdSI.button {
            FwdButton.action = #selector(fwdFunc)
        }

    
        // Rating control setup
        if let LeftEdge = LeftEdgeSI.button {
            LeftEdge.action = #selector(leftEdgeFunc)
        }
        if let Star1Button = Star1SI.button {
            Star1Button.action = #selector(star1Func)
        }
        if let Star2Button = Star2SI.button {
            Star2Button.action = #selector(star2Func)
        }
        if let Star3Button = Star3SI.button {
            Star3Button.action = #selector(star3Func)
        }
        if let Star4Button = Star4SI.button {
            Star4Button.action = #selector(star4Func)
        }
        if let Star5Button = Star5SI.button {
            Star5Button.action = #selector(star5Func)
        }
        
//        if let HeartButton = HeartSI.button {
//            HeartButton.action = #selector(heartFunc)
//        }
        
        // Popover control setup
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.Popover.isShown {
                self.closePopover(self.Popover)
            }
        }

        
        // Initialize display
        
        initializeDisplay()
        
        // Setting up observers
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(iTunesNotificationHandler), name:NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
        
        if LSCopyApplicationURLsForBundleIdentifier("com.spotify.client" as CFString, nil) != nil {
            print("spotify installed")
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(spotifyNotificationHandler), name:NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil)
        } else {
            print("spotify not installed")
        }
        

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // Menu buttons functions
    
    func searchString() -> String {
        var SearchString: String = ""
        SearchString = (artist as String) + "+" + (title as String)
        SearchString = SearchString.replacingOccurrences(of: " ", with: "+")
        SearchString = SearchString.replacingOccurrences(of: "-", with: "+")
        SearchString = SearchString.replacingOccurrences(of: "\"", with: "+")
        SearchString = SearchString.replacingOccurrences(of: ":", with: "+")
        SearchString = SearchString.replacingOccurrences(of: "++", with: "+")
        SearchString = SearchString.folding(options: .diacriticInsensitive, locale: .current)
        SearchString = SearchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        return SearchString
    }
    
    func searchYouTube(sender:NSStatusBar) {
        let SearchString: String = searchString()
        NSWorkspace.shared().open(URL(string: "https://www.youtube.com/results?search_query=" + SearchString)!)
    }
    
    func searchITunesStore(sender:NSStatusBar) {
        
        var countryCode = String()
        if UserDefaults.standard.string(forKey: "MusicBarITunesStoreCountry")! == "" {
            countryCode = "empty"
        } else {
            countryCode = UserDefaults.standard.string(forKey: "MusicBarITunesStoreCountry")!
        }
        
        let SearchString: String = searchString()
        let SearchURLRequest: URLRequest = URLRequest(url: URL(string: "https://itunes.apple.com/search?country=" + countryCode + "&term=" + SearchString)!)
        
        print(SearchURLRequest)
        
        var searchError = String()
        
        let search = URLSession.shared.dataTask(with: SearchURLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        if json["errorMessage"] != nil {
                            if json["errorMessage"] as! String == "Invalid value(s) for key(s): [country]" {
                                searchError = "iTunes Store country code invalid. \nPlease correct it in the menu : \nOther Settings / Edit iTunes Store Country"
                            } else {
                                searchError = json["errorMessage"] as! String
                            }
                        } else {
                            if json["resultCount"] as! NSInteger > 0 {
                                var trackURL: NSString = ((json["results"] as! NSArray)[0] as! NSDictionary)["trackViewUrl"] as! NSString
                                trackURL =  trackURL.replacingOccurrences(of: "https://", with: "itms://") as NSString
                                
                                NSWorkspace.shared().open(URL(string: "\(trackURL)&app=itunes" as String)!)
                            } else {
                                DispatchQueue.main.async {
                                    self.showPopover(message: "Track not found in iTunes")
                                }
                            }
                        }

                    }
                    
                } catch {
                    print("error in JSONSerialization")
                }
                if searchError != "" {
                    DispatchQueue.main.async {
                        self.showPopover(message: searchError)
                    }
                }
                
            }
            
        })
        
        search.resume()
        
        
        
    }
    
    func searchLastFM() {
        let SearchString: String = searchString()
        NSWorkspace.shared().open(URL(string: "https://www.last.fm/search?q=" + SearchString)!)
    }
    
    func toggleBlackStyle() {
        if UserDefaults.standard.bool(forKey: "MusicBarBlackStyle") {
            UserDefaults.standard.set(false, forKey: "MusicBarBlackStyle")
            viewSettingsSubmenu.item(withTitle: "Black Style")?.state = 0
        } else {
            UserDefaults.standard.set(true, forKey: "MusicBarBlackStyle")
            viewSettingsSubmenu.item(withTitle: "Black Style")?.state = 1
        }
        initializeDisplay()
    }
    
    func toggleSwitchAppButton() {
        if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
            UserDefaults.standard.set(false, forKey: "MusicBarSwitchApp")
            viewSettingsSubmenu.item(withTitle: "Switch Player Button")?.state = 0
        } else if LSCopyApplicationURLsForBundleIdentifier("com.spotify.client" as CFString, nil) != nil {
            UserDefaults.standard.set(true, forKey: "MusicBarSwitchApp")
            viewSettingsSubmenu.item(withTitle: "Switch Player Button")?.state = 1
        } else {
            self.showPopover(message: "It looks like Spotify is not \ninstalled on your computer. \nTo install Spotify, go to : \nhttps://www.spotify.com")
        }
        updateSwitchAppDisplay()
    }
    
    func toggleTrackInfo() {
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo") {
            UserDefaults.standard.set(false, forKey: "MusicBarTrackInfo")
            viewSettingsSubmenu.item(withTitle: "Track information")?.state = 0
        } else {
            UserDefaults.standard.set(true, forKey: "MusicBarTrackInfo")
            viewSettingsSubmenu.item(withTitle: "Track information")?.state = 1
        }
        updateTrackDisplay()
    }
    
    func toggleRatings() {
        if UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            UserDefaults.standard.set(false, forKey: "MusicBarViewRatings")
            viewSettingsSubmenu.item(withTitle: "iTunes Ratings")?.state = 0
        } else {
            UserDefaults.standard.set(true, forKey: "MusicBarViewRatings")
            viewSettingsSubmenu.item(withTitle: "iTunes Ratings")?.state = 1
        }
        
        updateRatingDisplay()
    }
    
    func toggleAutoLaunch() {
        if UserDefaults.standard.bool(forKey: "MusicBarAutoLaunch") {
            if SMLoginItemSetEnabled("tungsten.MusicBarHelper" as CFString, false) {
                UserDefaults.standard.set(false, forKey: "MusicBarAutoLaunch")
                otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 0
            } else {
                self.showPopover(message: "Failed to remove login item")
            }
        } else {
            if SMLoginItemSetEnabled("tungsten.MusicBarHelper" as CFString, true) {
                UserDefaults.standard.set(true, forKey: "MusicBarAutoLaunch")
                otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 1
            } else {
                self.showPopover(message: "Failed to add login item")
            }
        }
    }
    
    func changeItunesStoreCountry() {
        var countryCode = String()
        if UserDefaults.standard.string(forKey: "MusicBarITunesStoreCountry")! == "" {
            countryCode = "empty"
        } else {
            countryCode = UserDefaults.standard.string(forKey: "MusicBarITunesStoreCountry")!
        }
        let title : String = ("Change the Country code of your iTunes Store search "
        + "(in case MusicBar is not opening the iTunes Store of the correct country). "
        + "Current country code is : " + countryCode)
        showQuery(value: title)
    }

    
    func aboutMusicBar() {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        self.showAboutPopover(message: "MusicBar " + version + "." + build)
    }

    
    // Popover management
    
    func showPopover(message: String) {
        if let button = MusicBarSI.button {
            if let messageViewController = MessageViewController(nibName: "MessageViewController", bundle: nil) {
                Popover.contentViewController = messageViewController.displayMessage(message: message)
            }
            Popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(_ sender: AnyObject?) {
        Popover.performClose(sender)
        Popover.contentViewController = nil
        eventMonitor?.stop()
    }
    
    func displayTest() {
        if let button = MusicBarSI.button {
            Popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func showQuery(value: String) {
        if let button = MusicBarSI.button {
            if let queryViewController = QueryViewController(nibName: "QueryViewController", bundle: nil) {
                Popover.contentViewController = queryViewController.displayMessage(query: value)
            }
            Popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func okQueryWindow(_ sender: AnyObject?) {
        if let queryViewController = Popover.contentViewController as? QueryViewController {
            if queryViewController.QueryResult != nil {
                if queryViewController.QueryResult.stringValue != "" {
                    UserDefaults.standard.setValue(queryViewController.QueryResult.stringValue, forKey: "MusicBarITunesStoreCountry")
                }
            }
        }
        closePopover(sender)
    }

    
    func showAboutPopover(message: String) {
        if let button = MusicBarSI.button {
            if let aboutViewController = AboutViewController(nibName: "MessageViewController", bundle: nil) {
                Popover.contentViewController = aboutViewController.displayMessage(message: message)
            }
            Popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    

    // Menu bar button functions
    
    
    func switchMusicApp(sender:NSStatusBar) {
        if currentApp == "iTunes" {
            if LSCopyApplicationURLsForBundleIdentifier("com.spotify.client" as CFString, nil) != nil {
                if spotifyBridge.isRunning == true {
                    spotifyBridge.play()
                    iTunesBridge.pause()
                } else {
                    DispatchQueue.main.async {
                        self.spotifyBridge.play()
                    }
                    if let CurrentAppButton = SwitchAppSI.button {
                        if UserDefaults.standard.bool(forKey: "MusicBarBlackStyle") {
                            CurrentAppButton.image = NSImage(named: "WaitB")
                        } else {
                            CurrentAppButton.image = NSImage(named: "WaitW")
                        }
                        CurrentAppButton.image?.isTemplate = true
                    }
                    currentApp = "wait"
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        if self.currentApp == "wait" {
                            self.spotifyBridge.play()
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                        if self.currentApp == "wait" {
                            self.spotifyBridge.play()
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
                        if self.currentApp == "wait" {
                            self.spotifyBridge.play()
                        }
                    })
                }
            } else {
                self.showPopover(message: "It looks like Spotify is not \ninstalled on your computer. \nTo install Spotify, go to : \nhttps://www.spotify.com")
            }
        } else if currentApp == "spotify" {
            iTunesBridge.play()
            if spotifyBridge.isRunning {
                spotifyBridge.pause()
            }
        } else {
            initializeDisplay()
        }
    }
    
    func playpauseFunc(sender: NSStatusBar) {
        if currentApp == "iTunes" {
            iTunesBridge.playPause()
        } else if currentApp == "spotify" {
            spotifyBridge.playPause()
        }
    }
    func backFunc(sender :NSStatusBar){
        if currentApp == "iTunes" {
            iTunesBridge.gotoPreviousTrack()
        } else if currentApp == "spotify" {
            spotifyBridge.gotoPreviousTrack()
        }
    }
    func fwdFunc(sender :NSStatusBar){
        if currentApp == "iTunes" {
            iTunesBridge.gotoNextTrack()
        } else if currentApp == "spotify" {
            spotifyBridge.gotoNextTrack()
        }
    }
    
    func leftEdgeFunc(sender :NSStatusBar){
        if iTunesBridge.isRunning && currentApp == "iTunes" {
            iTunesBridge.rating = 0
            updateRatingDisplay()
        }
    }
    func star1Func(sender :NSStatusBar){
        iTunesBridge.rating = 20
        updateRatingDisplay()
    }
    func star2Func(sender :NSStatusBar){
        iTunesBridge.rating = 40
        updateRatingDisplay()
    }
    func star3Func(sender :NSStatusBar){
        iTunesBridge.rating = 60
        updateRatingDisplay()
    }
    func star4Func(sender :NSStatusBar){
        iTunesBridge.rating = 80
        updateRatingDisplay()
    }
    func star5Func(sender :NSStatusBar){
        iTunesBridge.rating = 100
        updateRatingDisplay()
    }
    
//    func heartFunc(sender :NSStatusBar){
//        //spotifyBridge.starred = true
//        updateRatingDisplay()
//    }
    
    // Notification handlers
    
    func iTunesNotificationHandler() {
        
        print("iTunes notification")
        
        // If iTunes is closed
        if iTunesBridge.isRunning == false || iTunesBridge.playerState == 0 {
            // If Spotify is open => switch to spotify
            if spotifyBridge.isRunning == true {
                updateSpotifyDisplay()
            // If Spotify is closed => switch to standby
            } else {
                musicBarStandBy()
            }
            print("1")
        
        // If iTunes is running & playing
        } else if iTunesBridge.playerState == 2 {
            
            // => Update display to iTunes
            updateITunesDisplay()
            
            // If Spotify is open => pause
            if spotifyBridge.isRunning == true {
                spotifyBridge.pause()
            }
            print("2")
        
        // If iTunes is running & paused
        } else {
            
            // If display is set on iTunes => Update display
            if currentApp == "iTunes" {
                updateITunesDisplay()
            }
            print("3")
            
            // If display is not set on iTunes => do nothing
        }
    }
    
    func spotifyNotificationHandler() {
        
        
        // If spotify is closed
        if spotifyBridge.isRunning == false {
            print("test1")
            // If iTunes is open => switch to iTunes
            if iTunesBridge.isRunning == true {
                updateITunesDisplay()
            // If iTunes is closed => switch to standby
            } else {
                musicBarStandBy()
            }
            
        // If spotify is running & playing (value = 2)
        } else if spotifyBridge.playerState == 2 {
            // => Update display to spotify
            updateSpotifyDisplay()
            
            // If iTunes is open => pause
            if iTunesBridge.isRunning == true {
                iTunesBridge.pause() as Void
            }
            
        // If spotify is running & paused
        } else {
            // If display is set on spotify => Update display
            if currentApp == "spotify" {
                updateSpotifyDisplay()
            }
            
            // If display is not set on spotify => do nothing
        }
    }
    
    
    // Display functions
    
    func initializeDisplay() {
        
        // Set Icons Names
        if UserDefaults.standard.bool(forKey: "MusicBarBlackStyle") {
            iconDic["MusicBarSI"] = "Logo-RightB"
            iconDic["SeparatorSI"] = "Separator-IconB"
            iconDic["FwdSI"] = "Fwd-IconB"
            iconDic["Play"] = "Play-IconB"
            iconDic["Pause"] = "Pause-IconB"
            iconDic["Power"] = "Power-IconB"
            iconDic["BackSI"] = "Back-IconB"
            iconDic["Spotify-iTunes"] = "Spotify-iTunes-IconB"
            iconDic["iTunes-Spotify"] = "iTunes-Spotify-IconB"
            iconDic["TextEdgeRightSI"] = "Text-Edge-RightB"
            iconDic["TextSeparator"] = "Text-SeparatorB"
            iconDic["NoTextSeparator"] = "Separator-IconB"
            iconDic["TextEdgeLeftSI"] = "Text-Edge-LeftB"
            iconDic["Star"] = "Star-IconB"
            iconDic["StarEmpty"] = "StarEmpty-IconB"
            iconDic["LeftEdgeSI"] = "Left-IconB"
        } else {
            iconDic["MusicBarSI"] = "Logo-Right"
            iconDic["SeparatorSI"] = "Separator-Icon"
            iconDic["FwdSI"] = "Fwd-Icon"
            iconDic["Play"] = "Play-Icon"
            iconDic["Pause"] = "Pause-Icon"
            iconDic["Power"] = "Power-Icon"
            iconDic["BackSI"] = "Back-Icon"
            iconDic["Spotify-iTunes"] = "Spotify-iTunes-Icon"
            iconDic["iTunes-Spotify"] = "iTunes-Spotify-Icon"
            iconDic["TextEdgeRightSI"] = "Text-Edge-Right"
            iconDic["TextSeparator"] = "Text-Separator"
            iconDic["NoTextSeparator"] = "Separator-Icon"
            iconDic["TextEdgeLeftSI"] = "Text-Edge-Left"
            iconDic["Star"] = "Star-Icon"
            iconDic["StarEmpty"] = "StarEmpty-Icon"
            iconDic["LeftEdgeSI"] = "Left-Icon"
        }
        
        // Standard Display
        if let musicBarButton = MusicBarSI.button {
            musicBarButton.image = NSImage(named: iconDic["MusicBarSI"]!)
            musicBarButton.image?.isTemplate = true
        }
        if let Separator1Button = Separator1SI.button {
            Separator1Button.image = NSImage(named: iconDic["SeparatorSI"]!)
            Separator1Button.image?.isTemplate = true
        }
        if let BackButton = BackSI.button {
            BackButton.image = NSImage(named: iconDic["BackSI"]!)
            BackButton.image?.isTemplate = true
        }
        if let FwdButton = FwdSI.button {
            FwdButton.image = NSImage(named: iconDic["FwdSI"]!)
            FwdButton.image?.isTemplate = true
        }
        if let LeftEdgeButton = LeftEdgeSI.button {
            LeftEdgeButton.image = NSImage(named: iconDic["LeftEdgeSI"]!)
            LeftEdgeButton.image?.isTemplate = true
        }
        
        // Switch music application button
        if let Separator2Button = Separator2SI.button {
            Separator2Button.image = NSImage(named: iconDic["SeparatorSI"]!)
            Separator2Button.image?.isTemplate = true
        }
        
        // Song & artist display
        if let ArtistBarButton = ArtistBarSI.button {
            ArtistBarButton.alignment = .left
        }
        if let TitleBarButton = TitleBarSI.button {
            TitleBarButton.alignment = .left;
        }
        
        musicBarStandBy()
        iTunesNotificationHandler()
        if spotifyBridge.isRunning == true {
            spotifyNotificationHandler()
        }
    }
    
    func updateSwitchAppDisplay() {
        if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") &&
            LSCopyApplicationURLsForBundleIdentifier("com.spotify.client" as CFString, nil) != nil {
            Separator2SI.length = 10
            SwitchAppSI.length = 36
            if currentApp == "spotify" {
                if let CurrentAppButton = SwitchAppSI.button {
                    CurrentAppButton.image = NSImage(named: iconDic["Spotify-iTunes"]!)
                    CurrentAppButton.image?.isTemplate = true
                }
            } else {
                if let CurrentAppButton = SwitchAppSI.button {
                    CurrentAppButton.image = NSImage(named: iconDic["iTunes-Spotify"]!)
                    CurrentAppButton.image?.isTemplate = true
                }
            }
        } else {
            Separator2SI.length = 0
            SwitchAppSI.length = 0
        }
    }

    func updateITunesDisplay() {
        
        if iTunesBridge.isRunning == false {
            if spotifyBridge.isRunning == true {
                updateSpotifyDisplay()
            } else {
                musicBarStandBy()
            }
            return
        }
            
        if let trackInfo = self.iTunesBridge.trackInfo { // nil indicates error, e.g. current track not available
            title = trackInfo["trackName"] as? NSString
            artist = trackInfo["trackArtist"] as? NSString
            album = trackInfo["trackAlbum"] as? NSString
        } else {
            title = ""
            artist = ""
        }
        if title == nil {
            title = ""
        }
        if artist == nil {
            artist = ""
        }

        // Remove spotify display if necessary
        if currentApp != "iTunes" {
            currentApp = "iTunes"
            if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
                updateSwitchAppDisplay()
            }
        }
        
        // Play/pause button update (playing = 2)
        if iTunesBridge.playerState == 2 {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: iconDic["Pause"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: iconDic["Play"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        }
        
        updateTrackDisplay()
        
        // Rating display
        updateRatingDisplay()
        
        // Cover art display
        
        /*
        let artworks = track.artworks().get()
        print(artworks?[0] ?? "damned")

        let artwork = artworks?[0] as! iTunesArtwork
        if let artworkButton = artworkSI.button {
            artworkButton.image = artwork.data
        }
        */
        
        /// Other tests
        /*
        let playlists = iTunes.playlists()
        print(playlists?[0] as Any)

        var playlist: iTunesPlaylist
         
        if let dummyPlaylist = playlists?[0] {
            playlist = dummyPlaylist as! iTunesPlaylist
        print(playlist.name)
        }
        */
        
    }
    
    func updateSpotifyDisplay() {
        
        if spotifyBridge.isRunning == false {
            if iTunesBridge.isRunning == true {
                updateITunesDisplay()
            } else {
                musicBarStandBy()
            }
            return
        }
        
        if let trackInfo = self.spotifyBridge.trackInfo { // nil indicates error, e.g. current track not available
            title = trackInfo["trackName"] as? NSString
            artist = trackInfo["trackArtist"] as? NSString
            album = trackInfo["trackAlbum"] as? NSString
        }
        if title == nil {
            title = ""
        }
        if artist == nil {
            artist = ""
        }
        
        // Switch App
        if currentApp != "spotify" {
            currentApp = "spotify"
            updateSwitchAppDisplay()
        }
        
        
        // Play/pause button update
        if spotifyBridge.playerState == 2 {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: iconDic["Pause"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: iconDic["Play"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        }
        
        // Is track in "Your music" ?
        /// upddateSpotifyVStatusDisplay() => no access through AppleScript API, need to investigate web API (much richer but i'm tired)
        
        // Cover art display
        /*
        let artworkURL: String = track.artworkUrl
        
        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = NSImage(contentsOfFile: filePath) {
            if let ArtworkButton = ArtworkSI.button {
                ArtworkButton.image = image
            }
        }
        */
        
        updateTrackDisplay()
        
        updateRatingDisplay()
        
    }
    
    func  musicBarStandBy() {
        
        currentApp = DefaultCurrentApp
        updateSwitchAppDisplay()
        
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.image = NSImage(named: iconDic["Power"]!)
            PlayPauseButton.image?.isTemplate = true
        }
        
        title = ""
        artist = ""
        
        updateTrackDisplay()
        
        updateRatingDisplay()
        
    }
    
    func updateTrackDisplay() {
        
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo") {
            
            TitleBarSI.length = 100
            Separator3SI.length = 13
            ArtistBarSI.length = 100
            TextEdgeRightSI.length = 10
            
            if let SeparatorTextButton = Separator3SI.button {
                SeparatorTextButton.image = NSImage(named: iconDic["TextSeparator"]!)
                SeparatorTextButton.image?.isTemplate = true
            }
            if let TextEdgeRightButton = TextEdgeRightSI.button {
                TextEdgeRightButton.image = NSImage(named: iconDic["TextEdgeRightSI"]!)
                TextEdgeRightButton.image?.isTemplate = true
            }
            
            let NoTitleMessage : String = "Song title"
            let NoArtistMessage : String = "Song artist"
            
            let TitleButton = TitleBarSI.button
            let ArtistButton = ArtistBarSI.button
            
            let titleStyle = NSMutableParagraphStyle()
            titleStyle.alignment = NSTextAlignment.center
            
            if title != "" {
                TitleButton?.title = title! as String;
            } else {
                TitleButton?.attributedTitle = NSAttributedString(string: NoTitleMessage, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
            }
            
            if artist != ""{
                ArtistButton?.title = artist! as String;
            } else {
                ArtistButton?.attributedTitle = NSAttributedString(string: NoArtistMessage, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
            }
            
        } else {
            
            TitleBarSI.length = 0
            Separator3SI.length = 0
            ArtistBarSI.length = 0
            TextEdgeRightSI.length = 0

        }
        
        updateTextEdgeLeftDisplay()
    }
    
    
    func updateRatingDisplay() {
        
        if iTunesBridge.isRunning && currentApp == "iTunes"
            && UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            
            Star1SI.length = 20
            if let Star1Button = Star1SI.button {
                if Int(iTunesBridge.rating) >= 20 {
                    Star1Button.image = NSImage(named: iconDic["Star"]!)
                    Star1Button.image?.isTemplate = true
                } else {
                    Star1Button.image = NSImage(named: iconDic["StarEmpty"]!)
                    Star1Button.image?.isTemplate = true
                }
            }
            Star2SI.length = 20
            if let Star2Button = Star2SI.button {
                if Int(iTunesBridge.rating) >= 40 {
                    Star2Button.image = NSImage(named: iconDic["Star"]!)
                    Star2Button.image?.isTemplate = true
                } else {
                    Star2Button.image = NSImage(named: iconDic["StarEmpty"]!)
                    Star2Button.image?.isTemplate = true
                }
            }
            Star3SI.length = 20
            if let Star3Button = Star3SI.button {
                if Int(iTunesBridge.rating) >= 60 {
                    Star3Button.image = NSImage(named: iconDic["Star"]!)
                    Star3Button.image?.isTemplate = true
                } else {
                    Star3Button.image = NSImage(named: iconDic["StarEmpty"]!)
                    Star3Button.image?.isTemplate = true
                }
            }
            Star4SI.length = 20
            if let Star4Button = Star4SI.button {
                if Int(iTunesBridge.rating) >= 80 {
                    Star4Button.image = NSImage(named: iconDic["Star"]!)
                    Star4Button.image?.isTemplate = true
                } else {
                    Star4Button.image = NSImage(named: iconDic["StarEmpty"]!)
                    Star4Button.image?.isTemplate = true
                }
            }
            Star5SI.length = 20
            if let Star5Button = Star5SI.button {
                if Int(iTunesBridge.rating) >= 100 {
                    Star5Button.image = NSImage(named: iconDic["Star"]!)
                    Star5Button.image?.isTemplate = true
                } else {
                    Star5Button.image = NSImage(named: iconDic["StarEmpty"]!)
                    Star5Button.image?.isTemplate = true
                }
            }
            
//            HeartSI.length = 0

        } else if spotifyBridge.isRunning && currentApp == "spotify"
            && UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            
            Star1SI.length = 0
            Star2SI.length = 0
            Star3SI.length = 0
            Star4SI.length = 0
            Star5SI.length = 0
            
//            HeartSI.length = 20
//            if let HeartButton = HeartSI.button {
//                if spotifyBridge.starred {
//                    HeartButton.image = NSImage(named: iconDic["Star"]!)
//                    HeartButton.image?.isTemplate = true
//                } else {
//                    HeartButton.image = NSImage(named: iconDic["StarEmpty"]!)
//                    HeartButton.image?.isTemplate = true
//                }
//            }
            
        } else {
            Star1SI.length = 0
            Star2SI.length = 0
            Star3SI.length = 0
            Star4SI.length = 0
            Star5SI.length = 0
//            HeartSI.length = 0
        }
        
        updateTextEdgeLeftDisplay()
        
    }
    
    func updateTextEdgeLeftDisplay() {
        
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo")
            && UserDefaults.standard.bool(forKey: "MusicBarBlackStyle"){
            
            TextEdgeLeftSI.length = 9
            if let TextEdgeLeftButton = TextEdgeLeftSI.button {
                TextEdgeLeftButton.image = NSImage(named: iconDic["TextEdgeLeftSI"]!)
                TextEdgeLeftButton.image?.isTemplate = true
            }
            
        } else {
            if UserDefaults.standard.bool(forKey: "MusicBarViewRatings")
                && iTunesBridge.isRunning && currentApp == "iTunes" {
                TextEdgeLeftSI.length = 10
                if let TextEdgeLeftButton = TextEdgeLeftSI.button {
                    TextEdgeLeftButton.image = NSImage(named: iconDic["SeparatorSI"]!)
                    TextEdgeLeftButton.image?.isTemplate = true
                }
            } else {
                TextEdgeLeftSI.length = 0
            }
        }
    }
}

