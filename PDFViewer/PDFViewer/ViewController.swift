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
import Parse


//let UserDefaults = UserDefaults.default

class ViewController: UIViewController, UIDocumentPickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    
    
    
    @IBOutlet weak var pdfListView: UICollectionView!
    
    let storage = UserDefaults.standard
    var pdfList = [PFObject]()
//    var pdfList = [PFFileObject]()

    var segmentedPDFToJPGList = [UIImage]()
    var imageIndexCur = 1
    var pulledJPGList = [UIImage]()
    @IBOutlet weak var name: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfListView.dataSource = self
        pdfListView.delegate = self
        
//        let layout = pdfListView.collectionViewLayout as! UICollectionViewFlowLayout
//
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        let width = (view.frame.size.width - layout.minimumLineSpacing * 2 ) / 3
//        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
        
        let thisUser = PFUser.current()
        
        //let query =
        
        var query = PFQuery(className: "PDF")
        query.includeKeys(["ACL", "pdfArr"])
        query.limit = 25
        query.findObjectsInBackground { (pdfArr, error) in
        if pdfArr != nil{
            let a = pdfArr![14]
            let b = a["pdfArr"] as! [PFFileObject]
//            self.pdfList = b
            self.pdfList = pdfArr!
            
            print("pdfList size:\(self.pdfList.count)")
//            for i in 0...b.count-1 {
//
//                let c = b[i].url!
//                let d = URL(string: c)!
//                if let data = try? Data(contentsOf: d) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            let pdfPage = PDFPage(image: image)
//
//                            pdfDocument.insert(pdfPage!, at: i)
//                        }
//                    }
//                }
            self.pdfListView.reloadData()
        } else {
            print("Error: \(error)")
        }
        }
//        let layout = pdfListView.collectionViewLayout as! UICollectionViewFlowLayout
//
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        let width = (view.frame.size.width - layout.minimumLineSpacing * 2 ) / 3
//        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
    }
        
        
        
        
    @IBAction func importFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        present(documentPicker, animated: true, completion: nil)
    }
    
//    @IBAction func openFileInScreen(_ sender: Any) {
//
//        // Add PDFView to view controller.
//            let pdfView = PDFView(frame: self.view.bounds)
//            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            self.view.addSubview(pdfView)
//
//            // Fit content in PDFView.
//            pdfView.autoScales = true
//
//            // Load Sample.pdf file from app bundle.
//            let fileURL = storage.url(forKey: "PDFURL")
//            pdfView.document = PDFDocument(url: fileURL!)
//
//    }
    
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
    
    @IBAction func uploadPDF(_ sender: Any) {
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
    
//    @IBAction func diplayFunc(_ sender: Any) {
//        let pdfDocument = PDFDocument()
//
//        var url = URL(string: "https://www.zerotoappstore.com/")
//        var query = PFQuery(className: "PDF")
//        query.includeKeys(["ACL", "pdfArr"])
//        query.limit = 25
//        query.findObjectsInBackground { (pdfArr, error) in
//        if pdfArr != nil{
//            let a = pdfArr![14]
//            let b = a["pdfArr"] as! [PFFileObject]
//            for i in 0...b.count-1 {
//
//                let c = b[i].url!
//                let d = URL(string: c)!
//                if let data = try? Data(contentsOf: d) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            let pdfPage = PDFPage(image: image)
//
//                            pdfDocument.insert(pdfPage!, at: i)
//                        }
//                    }
//                }
//            }
//
//                        print(pdfArr!)
//                        print("pulledJPGList count: \(self.pulledJPGList.count)")
//                    }else{
//                        print("Error: \(error)")
//                    }
//
//        }
//
//
//
////                var example = PDFInfo()
////                example.pdfFile = pdfDocument
//        //
//        //        //To display for testing purposes
//                pdfView = PDFView(frame: self.view.bounds)
//                pdfView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                self.view.addSubview(pdfView!)
//        //
//                pdfView!.autoScales = true
//        //
//                pdfView!.document = pdfDocument
//    }
    
//    func thumbnailFromPdf(withUrl url:URL, pageNumber:Int, width: CGFloat = 240) -> UIImage? {
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

            // White BG
            context.setFillColor(UIColor.white.cgColor)
            context.fill(pageRect)
            context.saveGState()

            // Next 3 lines makes the rotations so that the page look in the right direction
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))

            context.drawPDFPage(page)
            context.restoreGState()

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PDFCollectionViewCell
        
        let indexPath = pdfListView.indexPath(for: cell)
        
//        let singlePDF = pdfList[indexPath.item]
//        let thumbNailOfSingle = singlePDF["pdfArr"] as! [PFFileObject]
        
        let l = pdfList[indexPath!.item]
        let g = l["pdfArr"] as! [PFFileObject]
//        let pdfPages = pdfList[indexPath!.item]
        
        
        let secondDetailsViewController = segue.destination as! PDFViewerController
        secondDetailsViewController.pdfPages = g

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("In collectionView (pdfLIst.count): \(self.pdfList.count)")
        return self.pdfList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFCollectionViewCell", for: indexPath) as! PDFCollectionViewCell
        print("indexPath.item: \(indexPath.item)")
//        let b = a["pdfArr"] as! [PFFileObject]
        let singlePDF = pdfList[indexPath.item]
        let thumbNailOfSingle = singlePDF["pdfArr"] as! [PFFileObject]
        let thumb = thumbNailOfSingle[0].url!
        let thumbnailURL = URL(string: thumb)!
        
        if let data = try? Data(contentsOf: thumbnailURL) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.pdfThumbnail.image = image
                }
            }
        }
        
        cell.pdfURLInfo = thumbNailOfSingle
        print("cell.pdfURLInfo.count = \(cell.pdfURLInfo.count)")
        
        return cell
    }
    
    
    
    
}
