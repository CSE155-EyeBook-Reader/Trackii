//
//  ViewController.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 4/9/22.
//

import UIKit
import MobileCoreServices
import PDFKit
import AVKit
import SeeSo



//let UserDefaults = UserDefaults.default

class ViewController: UIViewController, UIDocumentPickerDelegate{
    let storage = UserDefaults.standard
    
    @IBOutlet weak var name: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = 
        
        
        
        

        // Do any additional setup after loading the view.
    }
    @IBAction func importFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func openFileInScreen(_ sender: Any) {
        
        // Add PDFView to view controller.
            let pdfView = PDFView(frame: self.view.bounds)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(pdfView)
            
            // Fit content in PDFView.
            pdfView.autoScales = true
            
            // Load Sample.pdf file from app bundle.
            let fileURL = storage.url(forKey: "PDFURL")
            pdfView.document = PDFDocument(url: fileURL!)
        
    }
    
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("k")
        
        let selectedFileURL = urls.first
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL!.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path){
            
            print("Already exists! Do not copy, but store URL")
            storage.set(urls.first, forKey: "PDFURL")
            
        } else {
            do {
                
                try FileManager.default.copyItem(at: selectedFileURL!, to: sandboxFileURL)
                storage.set(urls.first, forKey: "PDFURL")
                print("Copied file")
            } catch {
                
                print("Error: \(error)")
                
            }
        }
    }
    
}
