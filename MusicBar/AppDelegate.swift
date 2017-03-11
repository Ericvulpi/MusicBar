//
//  AppDelegate.swift
//  MusicBar
//
//  Created by Eric de Vulpillières on 28/01/2017.
//  Copyright © 2017 Tungsten. All rights reserved.
//

import Cocoa
import AppleScriptKit
import ScriptingBridge

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    var iTunes: AnyObject!
    var spotify: AnyObject!
    var currentApp: String!
    var title: String!
    var artist: String!
    
    let DefaultCurrentApp: String = "iTunes"
    
    let RightEdgeSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Star5SI = NSStatusBar.system().statusItem(withLength: 20)
    let Star4SI = NSStatusBar.system().statusItem(withLength: 20)
    let Star3SI = NSStatusBar.system().statusItem(withLength: 20)
    let Star2SI = NSStatusBar.system().statusItem(withLength: 20)
    let Star1SI = NSStatusBar.system().statusItem(withLength: 20)
    let Star0SI = NSStatusBar.system().statusItem(withLength: 10)
    let ArtistBarSI = NSStatusBar.system().statusItem(withLength: 100)
    let Separator1SI = NSStatusBar.system().statusItem(withLength: 10)
    let TitleBarSI = NSStatusBar.system().statusItem(withLength: 100)
    let ArtworkSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Separator2SI = NSStatusBar.system().statusItem(withLength: 10)
    let FwdSI = NSStatusBar.system().statusItem(withLength: 20)
    let PlayPauseSI = NSStatusBar.system().statusItem(withLength: 20)
    let BackSI = NSStatusBar.system().statusItem(withLength: 20)
    let CurrentAppSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let MusicBarSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()

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
            musicBarButton.image = NSImage(named: "Menu-Icon")
            musicBarButton.image?.isTemplate = true
        }
            
        menu.addItem(NSMenuItem(title: "Play/Pause", action: #selector(playpauseFunc), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared().terminate), keyEquivalent: "q"))
        
        // Current music application button
        if let CurrentAppButton = CurrentAppSI.button {
            currentApp = DefaultCurrentApp
            CurrentAppButton.title = currentApp
            CurrentAppButton.action = #selector(switchMusicApp)
        }
        
        
        // Music controls setup
        if let BackButton = BackSI.button {
            BackButton.image = NSImage(named: "Back-Icon")
            BackButton.action = #selector(backFunc)
        }
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.image = NSImage(named: "Play-Icon")
            PlayPauseButton.action = #selector(playpauseFunc)
            PlayPauseButton.image?.isTemplate = true
        }
        if let FwdButton = FwdSI.button {
            FwdButton.image = NSImage(named: "Fwd-Icon")
            FwdButton.action = #selector(fwdFunc)
        }
        
        // Song & artist display
        if let ArtistBarButton = ArtistBarSI.button {
            ArtistBarButton.alignment = .left
        }
        if let Separator1Button = Separator1SI.button {
            Separator1Button.image = NSImage(named: "Bar-Icon")
        }
        if let TitleBarButton = TitleBarSI.button {
            TitleBarButton.alignment = .left;
        }
        if let Separator2Button = Separator2SI.button {
            Separator2Button.image = NSImage(named: "Bar-Icon")
        }

    
        // Rating control setup
        if let Star0Button = Star0SI.button {
            Star0Button.image = NSImage(named: "Bar-Icon")
            Star0Button.action = #selector(star0Func)
        }
        if let Star1Button = Star1SI.button {
            Star1Button.image = NSImage(named: "StarEmpty-Icon")
            Star1Button.action = #selector(star1Func)
        }
        if let Star2Button = Star2SI.button {
            Star2Button.image = NSImage(named: "StarEmpty-Icon")
            Star2Button.action = #selector(star2Func)
        }
        if let Star3Button = Star3SI.button {
            Star3Button.image = NSImage(named: "StarEmpty-Icon")
            Star3Button.action = #selector(star3Func)
        }
        if let Star4Button = Star4SI.button {
            Star4Button.image = NSImage(named: "StarEmpty-Icon")
            Star4Button.action = #selector(star4Func)
        }
        if let Star5Button = Star5SI.button {
            Star5Button.image = NSImage(named: "StarEmpty-Icon")
            Star5Button.action = #selector(star5Func)
        }
        if let RightEdgeButton = RightEdgeSI.button {
            RightEdgeButton.image = NSImage(named: "Right-Logo")
            RightEdgeButton.image?.isTemplate = true
        }
        
        // Update display
        
        updateITunesDisplay()
        
        
        // Setting up observers
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(iTunesNotificationHandler), name:NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(spotifyNotificationHandler), name:NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"), object: nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // Buttons functions
    
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

    
    // Notification handlers
    
    func iTunesNotificationHandler() {
        
        // If iTunes is closed
        if iTunes.isRunning == false || iTunes.playerState == iTunesEPlS(rawValue: 0) {
            print("iTunes closing")
            // If Spotify is open => switch to spotify
            if spotify.isRunning == true {
                updateSpotifyDisplay()
                print("switch to spotify")
            // If Spotify is closed => switch to standby
            } else {
                musicBarStandBy()
                print("standby")
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
            print("spotify closing")
            // If iTunes is open => switch to iTunes
            if iTunes.isRunning == true {
                updateITunesDisplay()
                print("switch to iTunes")
            // If iTunes is closed => switch to standby
            } else {
                musicBarStandBy()
                print("standby")
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
            if let CurrentAppButton = CurrentAppSI.button {
                CurrentAppButton.title = currentApp
            }
        }
        
        // Play/pause button update
        if iTunesEPlSPlaying == iTunes.playerState {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Pause-Icon")
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Play-Icon")
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
            if let CurrentAppButton = CurrentAppSI.button {
                CurrentAppButton.title = currentApp
            }
            upddateITunesRatingDisplay()
        }
        
        // Play/pause button update
        if spotify.playerState == SpotifyEPlSPlaying {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Pause-Icon")
            }
        } else {
            if let PlayPauseButton = PlayPauseSI.button {
                PlayPauseButton.image = NSImage(named: "Play-Icon")
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
        
        if let PlayPauseButton = PlayPauseSI.button {
            PlayPauseButton.image = NSImage(named: "Power-Icon")
        }
        
        title = ""
        artist = ""
        updateTrackDisplay()
        
        upddateITunesRatingDisplay()
        
    }
    
    func updateTrackDisplay() {
        
        let NoTitleMessage : String = "Song title"
        let NoArtistMessage : String = "Song artist"
        
        let TitleButton = TitleBarSI.button
        let ArtistButton = ArtistBarSI.button
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = NSTextAlignment.center
        
        if title != "" {
            TitleButton?.title = title!;
            //print(TitleButton!.intrinsicContentSize)
        } else {
            TitleButton?.attributedTitle = NSAttributedString(string: NoTitleMessage, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
        }
        
        if artist != ""{
            ArtistButton?.title = artist!;
        } else {
            ArtistButton?.attributedTitle = NSAttributedString(string: NoArtistMessage, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
        }
    }
    
    
    func upddateITunesRatingDisplay() {
        
        if iTunes.isRunning && currentApp == "iTunes" {
            
            let track: iTunesTrack = iTunes.currentTrack;
            
            Star1SI.length = 20
            if let Star1Button = Star1SI.button {
                if track.rating >= 20 {
                    Star1Button.image = NSImage(named: "Star-Icon")
                } else {
                    Star1Button.image = NSImage(named: "StarEmpty-Icon")
                }
            }
            Star2SI.length = 20
            if let Star2Button = Star2SI.button {
                if track.rating >= 40 {
                    Star2Button.image = NSImage(named: "Star-Icon")
                } else {
                    Star2Button.image = NSImage(named: "StarEmpty-Icon")
                }
            }
            Star3SI.length = 20
            if let Star3Button = Star3SI.button {
                if track.rating >= 60 {
                    Star3Button.image = NSImage(named: "Star-Icon")
                } else {
                    Star3Button.image = NSImage(named: "StarEmpty-Icon")
                }
            }
            Star4SI.length = 20
            if let Star4Button = Star4SI.button {
                if track.rating >= 80 {
                    Star4Button.image = NSImage(named: "Star-Icon")
                } else {
                    Star4Button.image = NSImage(named: "StarEmpty-Icon")
                }
            }
            Star5SI.length = 20
            if let Star5Button = Star5SI.button {
                if track.rating >= 100 {
                    Star5Button.image = NSImage(named: "Star-Icon")
                } else {
                    Star5Button.image = NSImage(named: "StarEmpty-Icon")
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
        
    }
    
}

