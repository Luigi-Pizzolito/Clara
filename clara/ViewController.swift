//
//  ViewController.swift
//  clara
//
//  Created by Luigi Pizzolito on 21/05/2017.
//  Copyright © 2017 Luigi Pizzolito. All rights reserved.
//

import Cocoa
import AppKit
var path :URL = NSURL(fileURLWithPath: "null") as URL;
var outpath :URL = NSURL(fileURLWithPath: "null") as URL;
var txtcpathurl :URL = NSURL(fileURLWithPath: "null") as URL;
var ppmcpathurl :URL = NSURL(fileURLWithPath: "null") as URL;
var aescpathurl :URL = NSURL(fileURLWithPath: "null") as URL;
var text :String = "";
var passerror:Bool = false;
class ViewController: NSViewController {
    var outputPipe:Pipe!
    var buildTask:Process!
    var outputPipe2:Pipe!
    var buildTask2:Process!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded");
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
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlertStyle.critical
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    func getString(title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = title
        msg.informativeText = question
        
        let txt = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = defaultValue
        
        msg.accessoryView = txt
        let response: NSModalResponse = msg.runModal()
        
        if (response == NSAlertFirstButtonReturn) {
            return txt.stringValue
        } else {
            return ""
        }
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
    
    
    @IBAction func savtxtclara(_ sender: Any?) {
        let savePanel = NSSavePanel();
        savePanel.title = "Select a file to save:"
        savePanel.message = "This file will be saved as clara (compressed and encrypted)."
        savePanel.prompt = "Save";
        savePanel.canCreateDirectories = true;
        savePanel.showsHiddenFiles = true;
        savePanel.showsTagField = true;
        savePanel.tagNames = ["clara"];
        savePanel.isExtensionHidden = false;
        savePanel.canSelectHiddenExtension = true;
        savePanel.treatsFilePackagesAsDirectories = true;
        savePanel.allowedFileTypes = ["clara"];
        savePanel.allowsOtherFileTypes = false;
        savePanel.delegate = self as? NSOpenSavePanelDelegate;
        savePanel.begin { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                
                //get output path
                let pth = savePanel.url!.path
                print("selected folder is \(pth)");
                outpath = NSURL(fileURLWithPath: pth) as URL
                print("OutPath  :  is \(outpath)")
                //get paths for caches
                guard let txtcpath = Bundle.main.path(forResource: "cache",ofType:"txt") else {
                        print("error txtcache")
                        return
                    }
                txtcpathurl = NSURL(fileURLWithPath: txtcpath) as URL
                print("txtCache  :  is \(txtcpathurl)")
                guard let ppmcpath = Bundle.main.path(forResource: "cache",ofType:"ppm") else {
                    print("error ppmcache")
                    return
                }
                ppmcpathurl = NSURL(fileURLWithPath: ppmcpath) as URL
                print("ppmCache  :  is \(ppmcpathurl)")
                guard let aescpath = Bundle.main.path(forResource: "cache.ppm",ofType:"aes") else {
                    print("error aescache")
                    return
                }
                aescpathurl = NSURL(fileURLWithPath: aescpath) as URL
                print("aesCache  :  is \(aescpathurl)")
                
                //prompt for password
                let password = self.getString(title: "Encryption Password",question:"This will be used to encrypt your file, don't forget it.",defaultValue: "")
                print(password)
                
                //output text-box to cache
                do {
                    text = (self.textbox.textStorage as NSAttributedString!).string;
                    try text.write(to: txtcpathurl as URL, atomically: false, encoding: String.Encoding.utf8)
                } catch {self.dialogOK(question: "ERROR", text: "Could not save.")}
                
                
                //compress/encrypt
                //get executables
                guard let aespath = Bundle.main.path(forResource: "aescrypt",ofType:"") else {
                    print("error aescrypt")
                    return
                }
                guard let ppmpath = Bundle.main.path(forResource: "ppm",ofType:"") else {
                    print("error ppm")
                    return
                }
                print("aesCache  :  is \(aespath)")
                var arguments:[String] = []
                arguments.append(txtcpath)
                arguments.append(ppmcpath)
                arguments.append(aescpath)
                arguments.append(pth)
                arguments.append(password)
                arguments.append(aespath)
                arguments.append(ppmpath)
                self.runScriptCompress(arguments)
                
                
                
            }
        }

    }
    
    
    

    @IBAction func opntxtclara(_ sender: Any?) {
        let openPanel = NSOpenPanel();
        openPanel.title = "Select a file to read:"
        openPanel.message = "This file will be opened as clara (compressed and encrypted)."
        openPanel.showsResizeIndicator=true;
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.allowedFileTypes = ["clara"];
        openPanel.allowsMultipleSelection = false;
        openPanel.canCreateDirectories = true;
        openPanel.resolvesAliases = true;
        openPanel.canDownloadUbiquitousContents = true;
        openPanel.canResolveUbiquitousConflicts = true;
        openPanel.delegate = self as? NSOpenSavePanelDelegate;
        openPanel.begin { (result) -> Void in
            if(result == NSFileHandlingPanelOKButton){
                
                //get input path
                let pth = openPanel.url!.path
                print("selected folder is \(pth)");
                path = NSURL(fileURLWithPath: pth) as URL
                print("URL  :  is \(path)")
                
                //get paths for caches
                guard let txtcpath = Bundle.main.path(forResource: "cache",ofType:"txt") else {
                    print("error txtcache")
                    return
                }
                txtcpathurl = NSURL(fileURLWithPath: txtcpath) as URL
                print("txtCache  :  is \(txtcpathurl)")
                guard let ppmcpath = Bundle.main.path(forResource: "cache",ofType:"ppm") else {
                    print("error ppmcache")
                    return
                }
                ppmcpathurl = NSURL(fileURLWithPath: ppmcpath) as URL
                print("ppmCache  :  is \(ppmcpathurl)")
                guard let aescpath = Bundle.main.path(forResource: "cache.ppm",ofType:"aes") else {
                    print("error aescache")
                    return
                }
                aescpathurl = NSURL(fileURLWithPath: aescpath) as URL
                print("aesCache  :  is \(aescpathurl)")
                
                //prompt for password
                let password = self.getString(title: "De-Encryption Password",question:"This will be used to decrypt your file, make sure it's right.",defaultValue: "")
                print(password)
                
                //de-compress/decrypt
                //get executables
                guard let aespath = Bundle.main.path(forResource: "aescrypt",ofType:"") else {
                    print("error aescrypt")
                    return
                }
                print("aesscript :  is \(aespath)")
                guard let ppmpath = Bundle.main.path(forResource: "ppm",ofType:"") else {
                    print("error ppm")
                    return
                }
                print("ppmscript :  is \(ppmpath)")
                print("aesCache  :  is \(aespath)")
                var arguments:[String] = []
                arguments.append(pth)
                arguments.append(aescpath)
                arguments.append(ppmcpath)
                arguments.append(txtcpath)
                arguments.append(password)
                arguments.append(aespath)
                arguments.append(ppmpath)
                self.runScriptDeCompress(arguments)
                //doesnot work?
                if(passerror == false) {
                    self.dialogOK(question: "Could not open file", text: "The password entered was incorrect");
                    //passerror = true;
                } else {
                    //output to text box
                    self.opntxtcache(sender: Any?.self)
                }
                

            }
        }
    }

    
    
    func runScriptCompress(_ arguments:[String]) {
        
        //1.
        //isRunning = true
        
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        //2.
        taskQueue.async {
            
            //1.
            guard let pathc = Bundle.main.path(forResource: "compression",ofType:"command") else {
                print("Unable to locate compression.command")
                return
            }
            
            //2.
            self.buildTask = Process()
            self.buildTask.launchPath = pathc
            self.buildTask.arguments = arguments
            
            //3.
            self.buildTask.terminationHandler = {
                
                task in
                DispatchQueue.main.async(execute: {
                    print(" Compressed clara file! ");
                })
                
            }
            
            //self.captureStandardOutputAndRouteToTextView(self.buildTask)
            
            //4.
            self.buildTask.launch()
            
            //5.
            self.buildTask.waitUntilExit()
            
        }
        
    }
    
    func runScriptDeCompress(_ arguments:[String]) {
        
        //1.
        //isRunning = true
        
        let taskQueue2 = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        //2.
        taskQueue2.async {
            
            //1.
            guard let pathc2 = Bundle.main.path(forResource: "decompression",ofType:"command") else {
                print("Unable to locate decompression.command")
                return
            }
            
            //2.
            self.buildTask2 = Process()
            self.buildTask2.launchPath = pathc2
            self.buildTask2.arguments = arguments
            
            //3.
            self.buildTask2.terminationHandler = {
                
                task in
                DispatchQueue.main.async(execute: {
                    print(" Decompressed clara file! ");
                })
                
            }
            
            //self.captureStandardOutputAndRouteToTextView(self.buildTask)
            
            //4.
            let pipe = Pipe()
            self.buildTask2.standardOutput = pipe
            self.buildTask2.launch()
            
            //5.
            self.buildTask2.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print("just ran")
            print(output!)
            

            let string = output!
            
            if (string.contains("File decompressed successfully.") == false) {
                print("password error")
                //does not work?
                passerror = true
            } else {
                passerror = false
            }
            //self.dialogOK(question: "output", text: output! as String);
            
        }
        // Create a Task instance (was NSTask on swift pre 3.0)
//        let task = Process()
//        guard let pathc2 = Bundle.main.path(forResource: "decompression",ofType:"command") else {
//                            print("Unable to locate decompression.command")
//                            return
//                        }
//    
//
//        // Set the task parameters
//        task.launchPath = pathc2
//        print(pathc2);
//        task.arguments = arguments
//        
//        // Create a Pipe and make the task
//        // put all the output there
//        let pipe = Pipe()
//        task.standardOutput = pipe
//        
//        print("about to run")
//        // Launch the task
//        task.launch()
//        
//        // Get the data
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//        print("just ran")
//        print(output!)

        
    }



    
    @IBAction func opntxtcache(_ sender: Any) {
        //get paths for caches
        guard let txtcpath = Bundle.main.path(forResource: "cache",ofType:"txt") else {
            print("error txtcache")
            return
        }
        txtcpathurl = NSURL(fileURLWithPath: txtcpath) as URL
        print("txtCache  :  is \(txtcpathurl)")
        do {
            let text2 = try String(contentsOf: txtcpathurl as URL, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            let text = (self.textbox.textStorage as NSAttributedString!).string;
            self.textbox.textStorage?.replaceCharacters(in: NSMakeRange(0,text.characters.count), with: text2)
        }
        catch {self.dialogOK(question: "ERROR", text: "Could not read.")}
    }
    
}
