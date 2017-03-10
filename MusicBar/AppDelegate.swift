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
    let CoverArtSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let Separator2SI = NSStatusBar.system().statusItem(withLength: 10)
    let FwdSI = NSStatusBar.system().statusItem(withLength: 20)
    let PlayPauseSI = NSStatusBar.system().statusItem(withLength: 20)
    let BackSI = NSStatusBar.system().statusItem(withLength: 20)
    let MusicBarSI = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let menu = NSMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Target applications
        iTunes = SBApplication.init(bundleIdentifier: "com.apple.iTunes")
        
        // Style
        /// Not implemented yet
        
        // MusicBar Button and menu setup
        MusicBarSI.menu = menu
        
        let musicBarButton = MusicBarSI.button
        musicBarButton?.image = NSImage(named: "Menu-Icon")
        musicBarButton?.image?.isTemplate = true
        
        menu.addItem(NSMenuItem(title: "Play/Pause", action: #selector(playpauseFunc), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.shared().terminate), keyEquivalent: "q"))
        
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
        updateDisplay()
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(updateDisplay), name:NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // Buttons functions
    
    func playpauseFunc(sender: NSStatusBar) {
        iTunes.playpause()
    }
    func backFunc(sender :NSStatusBar){
        iTunes.previousTrack()
    }
    func fwdFunc(sender :NSStatusBar){
        iTunes.nextTrack()
    }
    
    func star0Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 0
            upddateRatingInfo()
        }
    }
    func star1Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 20
            upddateRatingInfo()
        }
    }
    func star2Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 40
            upddateRatingInfo()
        }
    }
    func star3Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 60
            upddateRatingInfo()
        }
    }
    func star4Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 80
            upddateRatingInfo()
        }
    }
    func star5Func(sender :NSStatusBar){
        if let track: iTunesTrack = iTunes.currentTrack {
            track.rating = 100
            upddateRatingInfo()
        }
    }

    // Update functions
    func updateDisplay() {
        
        let track: iTunesTrack = iTunes.currentTrack;
        
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
        
        upddateRatingInfo()
        
        // Cover art display
        
        /*
        let artworks = track.artworks().get()
        print(artworks?[0] ?? "damned")

        let coverArt = artworks?[0] as! iTunesArtwork
        if let CoverArtButton = CoverArtSI.button {
            CoverArtButton.image = coverArt.data
        }
        */
        
        // Other tests
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
        let title: String?
        let artist: String?
        
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
        
        
        let TitleButton = TitleBarSI.button
        let ArtistButton = ArtistBarSI.button
        
        //let titleStyle = NSMutableParagraphStyle()
        //titleStyle.alignment = NSTextAlignment.center
        
        if title != "" {
            //TitleButton?.attributedTitle = NSAttributedString(string: title!, attributes: [NSForegroundColorAttributeName: NSColor.gray, NSParagraphStyleAttributeName: titleStyle])
            TitleButton?.title = title!;
            //print(TitleButton!.intrinsicContentSize)
        } else {
            TitleButton?.title = ""
        }
        

        if artist != ""{
            ArtistButton?.title = artist!;
        } else {
            ArtistButton?.title = ""
        }
        
    }
    
    func upddateRatingInfo() {
        
        let track: iTunesTrack = iTunes.currentTrack;
        
        if let Star1Button = Star1SI.button {
            if track.rating >= 20 {
                Star1Button.image = NSImage(named: "Star-Icon")
            } else {
                Star1Button.image = NSImage(named: "StarEmpty-Icon")
            }
        }
        if let Star2Button = Star2SI.button {
            if track.rating >= 40 {
                Star2Button.image = NSImage(named: "Star-Icon")
            } else {
                Star2Button.image = NSImage(named: "StarEmpty-Icon")
            }
        }
        if let Star3Button = Star3SI.button {
            if track.rating >= 60 {
                Star3Button.image = NSImage(named: "Star-Icon")
            } else {
                Star3Button.image = NSImage(named: "StarEmpty-Icon")
            }
        }
        if let Star4Button = Star4SI.button {
            if track.rating >= 80 {
                Star4Button.image = NSImage(named: "Star-Icon")
            } else {
                Star4Button.image = NSImage(named: "StarEmpty-Icon")
            }
        }
        if let Star5Button = Star5SI.button {
            if track.rating >= 100 {
                Star5Button.image = NSImage(named: "Star-Icon")
            } else {
                Star5Button.image = NSImage(named: "StarEmpty-Icon")
            }
        }
    }
    
}

