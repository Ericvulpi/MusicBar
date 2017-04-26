//
//  AppDelegate.swift
//  MusicBar
//
//  Created by Eric de Vulpillières on 28/01/2017.
//  Copyright © 2017 Tungsten. All rights reserved.
//

import Cocoa
import AppleScriptKit
import Foundation
import ScriptingBridge
import ServiceManagement

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    var iTunes: AnyObject!
    var spotify: AnyObject!
    var currentApp: String!
    var title: String!
    var artist: String!
    var IconDic = [String: String]()
    
    let menu = NSMenu()
    let viewSettingsSubmenu = NSMenu()
    let otherSettingsSubmenu = NSMenu()
    let DefaultCurrentApp: String = "iTunes"

    let MusicBarSI = NSStatusBar.system().statusItem(withLength: 16)
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
    let LeftEdgeSI = NSStatusBar.system().statusItem(withLength: 6)
    
    let Popover = NSPopover()
    var eventMonitor: EventMonitor?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Target applications
        
        iTunes = SBApplication.init(bundleIdentifier: "com.apple.iTunes")
        spotify = SBApplication.init(bundleIdentifier: "com.spotify.client")
        
        // Style
        /// Not implemented yet
        
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
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared().terminate), keyEquivalent: ""))
        
        // Initiate setting buttons
        
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
        
        // Popover control setup
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.Popover.isShown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()

        
        // Initialize display
        
        initializeDisplay()
        
        // Setting up observers
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(iTunesNotificationHandler), name:NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(spotifyNotificationHandler), name:NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    
    // Menu buttons functions
    
    func searchString() -> String {
        var SearchString: String = ""
        SearchString = artist + "+" + title
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
        
        let SearchString: String = searchString()
        let SearchURLRequest: URLRequest = URLRequest(url: URL(string: "https://itunes.apple.com/search?country=fr&term=" + SearchString)!)
        
        let search = URLSession.shared.dataTask(with: SearchURLRequest, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
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
                    
                } catch {
                    print("error in JSONSerialization")
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
        } else {
            UserDefaults.standard.set(true, forKey: "MusicBarSwitchApp")
            viewSettingsSubmenu.item(withTitle: "Switch Player Button")?.state = 1
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
        
        updateITunesRatingDisplay()
    }
    
    func toggleAutoLaunch() {
        if UserDefaults.standard.bool(forKey: "MusicBarAutoLaunch") {
            if SMLoginItemSetEnabled("Tungsten.MusicBarHelper" as CFString, false) {
                UserDefaults.standard.set(false, forKey: "MusicBarAutoLaunch")
                otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 0
            } else {
                self.showPopover(message: "Failed to remove login item")
            }
        } else {
            if SMLoginItemSetEnabled("Tungsten.MusicBarHelper" as CFString, true) {
                UserDefaults.standard.set(false, forKey: "MusicBarAutoLaunch")
                otherSettingsSubmenu.item(withTitle: "Auto launch at login")?.state = 1
            } else {
                self.showPopover(message: "Failed to add login item")
            }
        }
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
        eventMonitor?.stop()
    }
    
    func displayTest () {
        if let button = MusicBarSI.button {
            Popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    
    // Menu bar button functions
    
    func switchMusicApp(sender:NSStatusBar) {
        if currentApp == "iTunes" {
            iTunes.pause() as Void
            spotify.play() as Void
        } else if currentApp == "spotify" {
            if iTunesEPlSPlaying != iTunes.playerState {
                iTunes.playpause()
            }
            spotify.pause() as Void
        }
    }
    
    func playpauseFunc(sender: NSStatusBar) {
        if currentApp == "iTunes" {
            iTunes.playpause()
        } else if currentApp == "spotify" {
            spotify.playpause()
        }
    }
    func backFunc(sender :NSStatusBar){
        if currentApp == "iTunes" {
            iTunes.previousTrack()
        } else if currentApp == "spotify" {
            spotify.previousTrack()
        }
    }
    func fwdFunc(sender :NSStatusBar){
        if currentApp == "iTunes" {
            iTunes.nextTrack()
        } else if currentApp == "spotify" {
            spotify.nextTrack()
        }
    }
    
    func leftEdgeFunc(sender :NSStatusBar){
        if iTunes.isRunning && currentApp == "iTunes" {
            if let track: iTunesTrack = iTunes.currentTrack {
                track.rating = 0
                updateITunesRatingDisplay()
            }
        }
    }
    func star1Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 20
            updateITunesRatingDisplay()
        }
    }
    func star2Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 40
            updateITunesRatingDisplay()
        }
    }
    func star3Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 60
            updateITunesRatingDisplay()
        }
    }
    func star4Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 80
            updateITunesRatingDisplay()
        }
    }
    func star5Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 100
            updateITunesRatingDisplay()
        }
    }
    
    
    // Notification handlers
    
    func iTunesNotificationHandler() {
        
        // If iTunes is closed
        if iTunes.isRunning == false || iTunes.playerState == iTunesEPlS(rawValue: 0) {
            // If Spotify is open => switch to spotify
            if spotify.isRunning == true {
                updateSpotifyDisplay()
            // If Spotify is closed => switch to standby
            } else {
                musicBarStandBy()
            }
        
        // If iTunes is running & playing
        } else if iTunes.playerState == iTunesEPlSPlaying {
            
            // => Update display to iTunes
            updateITunesDisplay()
            
            // If Spotify is open => pause
            if spotify.isRunning == true {
                spotify.pause() as Void
            }
        
        // If iTunes is running & paused
        } else {
            
            // If display is set on iTunes => Update display
            if currentApp == "iTunes" {
                updateITunesDisplay()
            }
            
            // If display is not set on iTunes => do nothing
        }
    }
    
    func spotifyNotificationHandler() {
        
        // If spotify is closed
        if spotify.isRunning == false || spotify.playerState == SpotifyEPlS(rawValue: 0) {
            // If iTunes is open => switch to iTunes
            if iTunes.isRunning == true {
                updateITunesDisplay()
            // If iTunes is closed => switch to standby
            } else {
                musicBarStandBy()
            }
            
        // If spotify is running & playing
        } else if spotify.playerState == SpotifyEPlSPlaying {
            
            // => Update display to spotify
            updateSpotifyDisplay()
            
            // If iTunes is open => pause
            if iTunes.isRunning == true {
                iTunes.pause() as Void
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
            IconDic["MusicBarSI"] = "Logo-RightB"
            IconDic["SeparatorSI"] = "Separator-IconB"
            IconDic["FwdSI"] = "Fwd-IconB"
            IconDic["Play"] = "Play-IconB"
            IconDic["Pause"] = "Pause-IconB"
            IconDic["Power"] = "Power-IconB"
            IconDic["BackSI"] = "Back-IconB"
            IconDic["Spotify-iTunes"] = "Spotify-iTunes-IconB"
            IconDic["iTunes-Spotify"] = "iTunes-Spotify-IconB"
            IconDic["TextEdgeRightSI"] = "Text-Edge-RightB"
            IconDic["TextSeparator"] = "Text-SeparatorB"
            IconDic["NoTextSeparator"] = "Separator-IconB"
            IconDic["TextEdgeLeftSI"] = "Text-Edge-LeftB"
            IconDic["Star"] = "Star-IconB"
            IconDic["StarEmpty"] = "StarEmpty-IconB"
            IconDic["LeftEdgeSI"] = "Left-IconB"
        } else {
            IconDic["MusicBarSI"] = "Logo-Right"
            IconDic["SeparatorSI"] = "Separator-Icon"
            IconDic["FwdSI"] = "Fwd-Icon"
            IconDic["Play"] = "Play-Icon"
            IconDic["Pause"] = "Pause-Icon"
            IconDic["Power"] = "Power-Icon"
            IconDic["BackSI"] = "Back-Icon"
            IconDic["Spotify-iTunes"] = "Spotify-iTunes-Icon"
            IconDic["iTunes-Spotify"] = "iTunes-Spotify-Icon"
            IconDic["TextEdgeRightSI"] = "Text-Edge-Right"
            IconDic["TextSeparator"] = "Text-Separator"
            IconDic["NoTextSeparator"] = "Separator-Icon"
            IconDic["TextEdgeLeftSI"] = "Text-Edge-Left"
            IconDic["Star"] = "Star-Icon"
            IconDic["StarEmpty"] = "StarEmpty-Icon"
            IconDic["LeftEdgeSI"] = "Left-Icon"
        }
        
        // Standard Display
        if let musicBarButton = MusicBarSI.button {
            musicBarButton.image = NSImage(named: IconDic["MusicBarSI"]!)
            musicBarButton.image?.isTemplate = true
        }
        if let Separator1Button = Separator1SI.button {
            Separator1Button.image = NSImage(named: IconDic["SeparatorSI"]!)
            Separator1Button.image?.isTemplate = true
        }
        if let BackButton = BackSI.button {
            BackButton.image = NSImage(named: IconDic["BackSI"]!)
            BackButton.image?.isTemplate = true
        }
        if let FwdButton = FwdSI.button {
            FwdButton.image = NSImage(named: IconDic["FwdSI"]!)
            FwdButton.image?.isTemplate = true
        }
        if let LeftEdgeButton = LeftEdgeSI.button {
            LeftEdgeButton.image = NSImage(named: IconDic["LeftEdgeSI"]!)
            LeftEdgeButton.image?.isTemplate = true
        }
        
        // Switch music application button
        if let Separator2Button = Separator2SI.button {
            Separator2Button.image = NSImage(named: IconDic["SeparatorSI"]!)
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
        spotifyNotificationHandler()
    }
    
    func updateSwitchAppDisplay() {
        if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
            Separator2SI.length = 10
            SwitchAppSI.length = 36
            if currentApp == "spotify" {
                if let CurrentAppButton = SwitchAppSI.button {
                    CurrentAppButton.image = NSImage(named: IconDic["Spotify-iTunes"]!)
                    CurrentAppButton.image?.isTemplate = true
                }
            } else {
                if let CurrentAppButton = SwitchAppSI.button {
                    CurrentAppButton.image = NSImage(named: IconDic["iTunes-Spotify"]!)
                    CurrentAppButton.image?.isTemplate = true
                }
            }
        } else {
            Separator2SI.length = 0
            SwitchAppSI.length = 0
        }
    }

    func updateITunesDisplay() {
        
        let track: iTunesTrack = iTunes.currentTrack;

        // Remove spotify display if necessary
        if currentApp == "spotify" {
            currentApp = "iTunes"
            if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
                updateSwitchAppDisplay()
            }
        }
        
        // Play/pause button update
        if iTunesEPlSPlaying == iTunes.playerState {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: IconDic["Pause"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: IconDic["Play"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        }
        
        // Rating display
        updateITunesRatingDisplay()
        
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
        
        
        // Track display
        
        if track.name == nil{
            title = ""
        } else {
            title = track.name
        }
        
        if track.artist == nil {
            artist = ""
        } else {
            artist = track.artist
        }
        
        updateTrackDisplay()
        
    }
    
    func updateSpotifyDisplay() {
        
        let track: SpotifyTrack = spotify.currentTrack;
        
        // Remove iTunes display if necessary
        if currentApp == "iTunes" {
            currentApp = "spotify"
            updateSwitchAppDisplay()
            if UserDefaults.standard.bool(forKey: "MusicBarSwitchApp") {
                updateITunesRatingDisplay()
            }
        }
        
        // Play/pause button update
        if spotify.playerState == SpotifyEPlSPlaying {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: IconDic["Pause"]!)
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: IconDic["Play"]!)
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
        
        
        // Track display
        
        if track.name == nil{
            title = ""
        } else {
            title = track.name
        }
        
        if track.artist == nil {
            artist = ""
        } else {
            artist = track.artist
        }
        
        updateTrackDisplay()
        
    }
    
    func  musicBarStandBy() {
        
        currentApp = DefaultCurrentApp
        updateSwitchAppDisplay()
        
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.image = NSImage(named: IconDic["Power"]!)
            PlayPauseButton.image?.isTemplate = true
        }
        
        title = ""
        artist = ""
        
        updateTrackDisplay()
        
        updateITunesRatingDisplay()
        
    }
    
    func updateTrackDisplay() {
        
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo") {
            
            TitleBarSI.length = 100
            Separator3SI.length = 13
            ArtistBarSI.length = 100
            TextEdgeRightSI.length = 10
            
            if let SeparatorTextButton = Separator3SI.button {
                SeparatorTextButton.image = NSImage(named: IconDic["TextSeparator"]!)
                SeparatorTextButton.image?.isTemplate = true
            }
            if let TextEdgeRightButton = TextEdgeRightSI.button {
                TextEdgeRightButton.image = NSImage(named: IconDic["TextEdgeRightSI"]!)
                TextEdgeRightButton.image?.isTemplate = true
            }
            
            let NoTitleMessage : String = "Song title"
            let NoArtistMessage : String = "Song artist"
            
            let TitleButton = TitleBarSI.button
            let ArtistButton = ArtistBarSI.button
            
            let titleStyle = NSMutableParagraphStyle()
            titleStyle.alignment = NSTextAlignment.center
            
            if title != "" {
                TitleButton?.title = title!;
            } else {
                TitleButton?.attributedTitle = NSAttributedString(string: NoTitleMessage, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
            }
            
            if artist != ""{
                ArtistButton?.title = artist!;
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
    
    
    func updateITunesRatingDisplay() {
        
        if iTunes.isRunning && currentApp == "iTunes"
            && UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            
            let track: iTunesTrack = iTunes.currentTrack;
            
            Star1SI.length = 20
            if let Star1Button = Star1SI.button {
                if track.rating >= 20 {
                    Star1Button.image = NSImage(named: IconDic["Star"]!)
                    Star1Button.image?.isTemplate = true
                } else {
                    Star1Button.image = NSImage(named: IconDic["StarEmpty"]!)
                    Star1Button.image?.isTemplate = true
                }
            }
            Star2SI.length = 20
            if let Star2Button = Star2SI.button {
                if track.rating >= 40 {
                    Star2Button.image = NSImage(named: IconDic["Star"]!)
                    Star2Button.image?.isTemplate = true
                } else {
                    Star2Button.image = NSImage(named: IconDic["StarEmpty"]!)
                    Star2Button.image?.isTemplate = true
                }
            }
            Star3SI.length = 20
            if let Star3Button = Star3SI.button {
                if track.rating >= 60 {
                    Star3Button.image = NSImage(named: IconDic["Star"]!)
                    Star3Button.image?.isTemplate = true
                } else {
                    Star3Button.image = NSImage(named: IconDic["StarEmpty"]!)
                    Star3Button.image?.isTemplate = true
                }
            }
            Star4SI.length = 20
            if let Star4Button = Star4SI.button {
                if track.rating >= 80 {
                    Star4Button.image = NSImage(named: IconDic["Star"]!)
                    Star4Button.image?.isTemplate = true
                } else {
                    Star4Button.image = NSImage(named: IconDic["StarEmpty"]!)
                    Star4Button.image?.isTemplate = true
                }
            }
            Star5SI.length = 20
            if let Star5Button = Star5SI.button {
                if track.rating >= 100 {
                    Star5Button.image = NSImage(named: IconDic["Star"]!)
                    Star5Button.image?.isTemplate = true
                } else {
                    Star5Button.image = NSImage(named: IconDic["StarEmpty"]!)
                    Star5Button.image?.isTemplate = true
                }
            }

        } else {
            
            if let Star1Button = Star1SI.button {
                Star1Button.image = nil
            }
            Star1SI.length = 0
            if let Star2Button = Star2SI.button {
                Star2Button.image = nil
            }
            Star2SI.length = 0
            if let Star3Button = Star3SI.button {
                Star3Button.image = nil
            }
            Star3SI.length = 0
            if let Star4Button = Star4SI.button {
                Star4Button.image = nil
            }
            Star4SI.length = 0
            if let Star5Button = Star5SI.button {
                Star5Button.image = nil
            }
            Star5SI.length = 0
        }
        
        updateTextEdgeLeftDisplay()
        
    }
    
    func updateTextEdgeLeftDisplay() {
        
        if UserDefaults.standard.bool(forKey: "MusicBarTrackInfo")
            && UserDefaults.standard.bool(forKey: "MusicBarBlackStyle"){
            
            TextEdgeLeftSI.length = 9
            if let TextEdgeLeftButton = TextEdgeLeftSI.button {
                TextEdgeLeftButton.image = NSImage(named: IconDic["TextEdgeLeftSI"]!)
                TextEdgeLeftButton.image?.isTemplate = true
            }
            
        } else {
            if iTunes.isRunning && currentApp == "iTunes"
                && UserDefaults.standard.bool(forKey: "MusicBarViewRatings") {
            
                TextEdgeLeftSI.length = 10
                if let TextEdgeLeftButton = TextEdgeLeftSI.button {
                    TextEdgeLeftButton.image = NSImage(named: IconDic["SeparatorSI"]!)
                    TextEdgeLeftButton.image?.isTemplate = true
                }
            } else {
                TextEdgeLeftSI.length = 0
            }
        }
    }
}

