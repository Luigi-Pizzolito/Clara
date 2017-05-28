//
//  ViewController.swift
//  clara
//
//  Created by Luigi Pizzolito on 21/05/2017.
//  Copyright © 2017 Luigi Pizzolito. All rights reserved.
//

import Cocoa
var path :URL = NSURL(fileURLWithPath: "null") as URL;
var text :String = "";
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func dialogOKCancel(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.informational
        myPopup.addButton(withTitle: "Yes")
        myPopup.addButton(withTitle: "No")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    func dialogOK(question: String, text: String) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: "OK")
    }
    @IBOutlet var textbox: NSTextView!
    @IBAction func newtxt(_ sender: Any?) {
        let savbn :Bool = dialogOKCancel(question: "Reminder", text: "Save document ?");
        if savbn {
            if !(path == NSURL(fileURLWithPath: "null") as URL) {
                do {
                    text = (textbox.textStorage as NSAttributedString!).string;
                    try text.write(to: path as URL, atomically: false, encoding: String.Encoding.utf8)
                } catch {dialogOK(question: "ERROR", text: "Could not save.")}
            }
            if (path == NSURL(fileURLWithPath: "null") as URL) {
                let savePanel = NSSavePanel();
                savePanel.title = "Select a file to save:"
                savePanel.message = "This file will be saved as plain text."
                savePanel.prompt = "Save";
                savePanel.canCreateDirectories = true;
                savePanel.showsHiddenFiles = true;
                savePanel.showsTagField = true;
                savePanel.tagNames = ["clara"];
                savePanel.isExtensionHidden = false;
                savePanel.canSelectHiddenExtension = true;
                savePanel.treatsFilePackagesAsDirectories = true;
                savePanel.allowedFileTypes = ["txt"];
                savePanel.allowsOtherFileTypes = true;
                savePanel.delegate = self as? NSOpenSavePanelDelegate;
                savePanel.begin { (result) -> Void in
                    if(result == NSFileHandlingPanelOKButton){
                        let pth = savePanel.url!.path
                        print("selected folder is \(pth)");
                        path = NSURL(fileURLWithPath: pth) as URL
                        print("URL  :  is \(path)")
                        do {
                            text = (self.textbox.textStorage as NSAttributedString!).string;
                            try text.write(to: path as URL, atomically: false, encoding: String.Encoding.utf8)
                        } catch {self.dialogOK(question: "ERROR", text: "Could not save.")}
                        text = (self.textbox.textStorage as NSAttributedString!).string;
                        self.textbox.textStorage?.replaceCharacters(in: NSMakeRange(0,text.characters.count), with: "")
                        path = NSURL(fileURLWithPath: "null") as URL;
                    }
                }
            }

        }
        if !savbn {
        text = (textbox.textStorage as NSAttributedString!).string;
        textbox.textStorage?.replaceCharacters(in: NSMakeRange(0,text.characters.count), with: "")
        path = NSURL(fileURLWithPath: "null") as URL;
        }
    }
    @IBAction func opntxt(_ sender: Any?) {
        let openPanel = NSOpenPanel();
        openPanel.title = "Select a file to read:"
        openPanel.message = "This file will be opened as plain text."
        openPanel.showsResizeIndicator=true;
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.allowsMultipleSelection = false;
        openPanel.canCreateDirectories = true;
        openPanel.resolvesAliases = true;
        openPanel.canDownloadUbiquitousContents = true;
        openPanel.canResolveUbiquitousConflicts = true;
        openPanel.delegate = self as? NSOpenSavePanelDelegate;
        openPanel.begin { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                let pth = openPanel.url!.path
                print("selected folder is \(pth)");
                path = NSURL(fileURLWithPath: pth) as URL
                print("URL  :  is \(path)")
                do {
                    let text2 = try String(contentsOf: path as URL, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
                    let text = (self.textbox.textStorage as NSAttributedString!).string;
                    self.textbox.textStorage?.replaceCharacters(in: NSMakeRange(0,text.characters.count), with: text2)
                }
                catch {self.dialogOK(question: "ERROR", text: "Could not read.")}
            }
        }
    }
    @IBAction func savatxt(_ sender: Any?) {
        let savePanel = NSSavePanel();
        savePanel.title = "Select a file to save:"
        savePanel.message = "This file will be saved as plain text."
        savePanel.prompt = "Save";
        savePanel.canCreateDirectories = true;
        savePanel.showsHiddenFiles = true;
        savePanel.showsTagField = true;
        savePanel.tagNames = ["clara"];
        savePanel.isExtensionHidden = false;
        savePanel.canSelectHiddenExtension = true;
        savePanel.treatsFilePackagesAsDirectories = true;
        savePanel.allowedFileTypes = ["txt"];
        savePanel.allowsOtherFileTypes = true;
        savePanel.delegate = self as? NSOpenSavePanelDelegate;
        savePanel.begin { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                let pth = savePanel.url!.path
                print("selected folder is \(pth)");
                path = NSURL(fileURLWithPath: pth) as URL
                print("URL  :  is \(path)")
                do {
                    text = (self.textbox.textStorage as NSAttributedString!).string;
                    try text.write(to: path as URL, atomically: false, encoding: String.Encoding.utf8)
                } catch {self.dialogOK(question: "ERROR", text: "Could not save.")}
                
            }
        }
    }

    @IBAction func savtxt(_ sender: Any?) {
        if !(path == NSURL(fileURLWithPath: "null") as URL) {
            do {
                text = (textbox.textStorage as NSAttributedString!).string;
                try text.write(to: path as URL, atomically: false, encoding: String.Encoding.utf8)
            } catch {dialogOK(question: "ERROR", text: "Could not save.")}
        }
        if (path == NSURL(fileURLWithPath: "null") as URL) {
            let savePanel = NSSavePanel();
            savePanel.title = "Select a file to save:"
            savePanel.message = "This file will be saved as plain text."
            savePanel.prompt = "Save";
            savePanel.canCreateDirectories = true;
            savePanel.showsHiddenFiles = true;
            savePanel.showsTagField = true;
            savePanel.tagNames = ["clara"];
            savePanel.isExtensionHidden = false;
            savePanel.canSelectHiddenExtension = true;
            savePanel.treatsFilePackagesAsDirectories = true;
            savePanel.allowedFileTypes = ["txt"];
            savePanel.allowsOtherFileTypes = true;
            savePanel.delegate = self as? NSOpenSavePanelDelegate;
            savePanel.begin { (result) -> Void in
                if(result == NSFileHandlingPanelOKButton){
                    let pth = savePanel.url!.path
                    print("selected folder is \(pth)");
                    path = NSURL(fileURLWithPath: pth) as URL
                    print("URL  :  is \(path)")
                    do {
                        text = (self.textbox.textStorage as NSAttributedString!).string;
                        try text.write(to: path as URL, atomically: false, encoding: String.Encoding.utf8)
                    } catch {self.dialogOK(question: "ERROR", text: "Could not save.")}
                }
            }
        }
    } 
    


}
