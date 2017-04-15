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

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    var iTunes: AnyObject!
    var spotify: AnyObject!
    var currentApp: String!
    var title: String!
    var artist: String!
    
    let DefaultCurrentApp: String = "iTunes"
    
    let MusicBarSI = NSStatusBar.system().statusItem(withLength: 20)
    let menu = NSMenu()
    let SwitchAppSI = NSStatusBar.system().statusItem(withLength: 48)
    let FwdSI = NSStatusBar.system().statusItem(withLength: 18)
    let PlayPauseSI = NSStatusBar.system().statusItem(withLength: 18)
    let BackSI = NSStatusBar.system().statusItem(withLength: 26)
    let ArtistBarSI = NSStatusBar.system().statusItem(withLength: -1)
    let SeparatorSI = NSStatusBar.system().statusItem(withLength: -1)
    let TitleBarSI = NSStatusBar.system().statusItem(withLength: -1)
    let ArtworkSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star5SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star4SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star3SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star2SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star1SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star0SI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
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
        
        if let musicBarButton = MusicBarSI.button {
            musicBarButton.image = NSImage(named: "Menu-IconB")
            musicBarButton.image?.isTemplate = true
        }
            
        menu.addItem(NSMenuItem(title: "Search YouTube", action: #selector(searchYouTube), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Search iTunes Store", action: #selector(searchITunesStore), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Track information", action: #selector(toggleTrackInfo), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared().terminate), keyEquivalent: ""))
        
        // Initiate settings
        
        //UserDefaults.standard.set(false, forKey: "viewTrackInfo")
        
        if UserDefaults.standard.bool(forKey: "viewTrackInfo") {
            menu.item(withTitle: "Track information")?.state = 1
        } else {
            menu.item(withTitle: "Track information")?.state = 0
        }
        
        
        
        // Switch music application button
        if let CurrentAppButton = SwitchAppSI.button {
            CurrentAppButton.action = #selector(switchMusicApp)
        }
        
        
        // Music controls setup
        if let BackButton = BackSI.button {
            BackButton.image = NSImage(named: "Back-IconB")
            BackButton.image?.isTemplate = true
            BackButton.action = #selector(backFunc)
        }
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.action = #selector(playpauseFunc)
        }
        if let FwdButton = FwdSI.button {
            FwdButton.image = NSImage(named: "Fwd-IconB")
            FwdButton.image?.isTemplate = true
            FwdButton.action = #selector(fwdFunc)
        }
        
        // Song & artist display
        if let ArtistBarButton = ArtistBarSI.button {
            ArtistBarButton.alignment = .left
        }
        if let Separator1Button = SeparatorSI.button {
            Separator1Button.image = NSImage(named: "Separator-IconB")
            Separator1Button.image?.isTemplate = true
        }
        if let TitleBarButton = TitleBarSI.button {
            TitleBarButton.alignment = .left;
        }

    
        // Rating control setup
        if let Star0Button = Star0SI.button {
            Star0Button.image = NSImage(named: "Left-IconB")
            Star0Button.image?.isTemplate = true
            Star0Button.action = #selector(star0Func)
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
        
        musicBarStandBy()
        iTunesNotificationHandler()
        spotifyNotificationHandler()
        
        
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
    
    func toggleTrackInfo() {
        if UserDefaults.standard.bool(forKey: "viewTrackInfo") {
            UserDefaults.standard.set(false, forKey: "viewTrackInfo")
            menu.item(withTitle: "Track information")?.state = 0
        } else {
            UserDefaults.standard.set(true, forKey: "viewTrackInfo")
            menu.item(withTitle: "Track information")?.state = 1
        }
        updateTrackDisplay()
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
    
    func star0Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 0
            upddateITunesRatingDisplay()
        }
    }
    func star1Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 20
            upddateITunesRatingDisplay()
        }
    }
    func star2Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 40
            upddateITunesRatingDisplay()
        }
    }
    func star3Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 60
            upddateITunesRatingDisplay()
        }
    }
    func star4Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 80
            upddateITunesRatingDisplay()
        }
    }
    func star5Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 100
            upddateITunesRatingDisplay()
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
    
    
    // Update display functions
    
    func updateITunesDisplay() {
        
        let track: iTunesTrack = iTunes.currentTrack;

        // Remove spotify display if necessary
        if currentApp == "spotify" {
            currentApp = "iTunes"
            if let CurrentAppButton = SwitchAppSI.button {
                CurrentAppButton.image = NSImage(named: "iTunes-Spotify-IconB")
                CurrentAppButton.image?.isTemplate = true
                
            }
        }
        
        // Play/pause button update
        if iTunesEPlSPlaying == iTunes.playerState {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Pause-Icon")
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Play-Icon")
                PlayPauseButton.image?.isTemplate = true
            }
        }
        
        // Rating display
        upddateITunesRatingDisplay()
        
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
            if let CurrentAppButton = SwitchAppSI.button {
                CurrentAppButton.image = NSImage(named: "Spotify-iTunes-IconB")
                CurrentAppButton.image?.isTemplate = true
            }
            upddateITunesRatingDisplay()
        }
        
        // Play/pause button update
        if spotify.playerState == SpotifyEPlSPlaying {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Pause-Icon")
                PlayPauseButton.image?.isTemplate = true
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Play-Icon")
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
        
        if let CurrentAppButton = SwitchAppSI.button {
            CurrentAppButton.image = NSImage(named: "iTunes-Spotify-IconB")
            CurrentAppButton.image?.isTemplate = true
        }
        
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.image = NSImage(named: "Power-Icon")
            PlayPauseButton.image?.isTemplate = true
        }
        
        title = ""
        artist = ""
        updateTrackDisplay()
        
        upddateITunesRatingDisplay()
        
    }
    
    func updateTrackDisplay() {
        
        if UserDefaults.standard.bool(forKey: "viewTrackInfo") {
            
            TitleBarSI.length = 100
            SeparatorSI.length = 13
            ArtistBarSI.length = 100
            
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
            SeparatorSI.length = 0
            ArtistBarSI.length = 0
            
        }
    }
    
    
    func upddateITunesRatingDisplay() {
        
        if iTunes.isRunning && currentApp == "iTunes" {
            
            let track: iTunesTrack = iTunes.currentTrack;

            
            Star0SI.length = 6
            if let Star0Button = Star0SI.button {
                Star0Button.image = NSImage(named: "Left-IconB")
                Star0Button.image?.isTemplate = true
            }
            
            Star1SI.length = 20
            if let Star1Button = Star1SI.button {
                if track.rating >= 20 {
                    Star1Button.image = NSImage(named: "Star-IconB")
                    Star1Button.image?.isTemplate = true
                } else {
                    Star1Button.image = NSImage(named: "StarEmpty-IconB")
                    Star1Button.image?.isTemplate = true
                }
            }
            Star2SI.length = 20
            if let Star2Button = Star2SI.button {
                if track.rating >= 40 {
                    Star2Button.image = NSImage(named: "Star-IconB")
                    Star2Button.image?.isTemplate = true
                } else {
                    Star2Button.image = NSImage(named: "StarEmpty-IconB")
                    Star2Button.image?.isTemplate = true
                }
            }
            Star3SI.length = 20
            if let Star3Button = Star3SI.button {
                if track.rating >= 60 {
                    Star3Button.image = NSImage(named: "Star-IconB")
                    Star3Button.image?.isTemplate = true
                } else {
                    Star3Button.image = NSImage(named: "StarEmpty-IconB")
                    Star3Button.image?.isTemplate = true
                }
            }
            Star4SI.length = 20
            if let Star4Button = Star4SI.button {
                if track.rating >= 80 {
                    Star4Button.image = NSImage(named: "Star-IconB")
                    Star4Button.image?.isTemplate = true
                } else {
                    Star4Button.image = NSImage(named: "StarEmpty-IconB")
                    Star4Button.image?.isTemplate = true
                }
            }
            Star5SI.length = 29
            if let Star5Button = Star5SI.button {
                if track.rating >= 100 {
                    Star5Button.image = NSImage(named: "Star5-IconB")
                    Star5Button.image?.isTemplate = true
                } else {
                    Star5Button.image = NSImage(named: "StarEmpty5-IconB")
                    Star5Button.image?.isTemplate = true
                }
            }

        } else {
            
            Star0SI.length = 11
            if let Star0Button = Star0SI.button {
                Star0Button.image = NSImage(named: "LeftAlt-IconB")
                Star0Button.image?.isTemplate = true
            }
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
        
    }
    
}

