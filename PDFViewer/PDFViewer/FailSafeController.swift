//
//  FailSafeController.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 6/29/22.
//

import UIKit
import MobileCoreServices
import PDFKit
import AVKit
import SeeSo
import Parse




class FailSafeController: UIViewController, UIDocumentPickerDelegate{

    let storage = UserDefaults.standard
    var segmentedPDFToJPGList = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true, completion: nil)
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
    
    func thumbnailFromPdf(withUrl url:URL, pageNumber:Int, width: CGFloat = 1000) -> UIImage? {

            guard let pdf = CGPDFDocument(url as CFURL),
                let page = pdf.page(at: pageNumber)
                else {
                    return nil
            }
            
            var pageRect = page.getBoxRect(.mediaBox)
            let pdfScale = width / pageRect.size.width
            pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
            pageRect.origin = .zero

            UIGraphicsBeginImageContext(pageRect.size)
            let context = UIGraphicsGetCurrentContext()!

            context.setFillColor(UIColor.white.cgColor)
            context.fill(pageRect)
            context.saveGState()

            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))

            context.drawPDFPage(page)
            context.restoreGState()

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        let pdfURL = storage.url(forKey: "PDFURL")!
                
//            let pageThree = thumbnailFromPdf(withUrl: pdfURL, pageNumber: 4)
            let doc = PDFDocument(url: pdfURL)
                
        //        var segmentedPDFImages = [UIImage]()
            for i in 1...doc!.pageCount{
                segmentedPDFToJPGList.append(thumbnailFromPdf(withUrl: pdfURL, pageNumber: i)!)
            }
            print("Size of segmentedPDFToPNG: \(segmentedPDFToJPGList.count)")
                
                
//            let pageFour = makeThumbnail(pdfDocument: doc, page:0)
              
            var stringVersion = [PFFileObject]()
            for i in 0...segmentedPDFToJPGList.count-1 {
                let imageData = segmentedPDFToJPGList[i].pngData()
                let file = PFFileObject(name: "image.png", data: imageData!)!
                stringVersion.append(file)
            }
            print("Size of stringVersion: \(stringVersion.count)")
                
            let parseObject = PFObject(className: "PDF")
            parseObject["pdfArr"] = stringVersion
                
                
                
            parseObject.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("Success")
                    //self.pdfListView.reloadData()
                    self.viewDidLoad()
                    
                } else {
                    print("Fail")
                    print("Error: \(error)")
                }

            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
