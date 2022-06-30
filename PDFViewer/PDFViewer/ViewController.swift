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



class ViewController: UIViewController, UIDocumentPickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    

    
    @IBOutlet weak var importFile: UIButton!
    
    @IBOutlet weak var uploadFile: UIButton!
    
    @IBOutlet weak var pdfListView: UICollectionView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var userIcon: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var myCollectionTitle: UILabel!
    
    
    let storage = UserDefaults.standard
    var pdfList = [PFObject]()

    var segmentedPDFToJPGList = [UIImage]()
    var imageIndexCur = 1
    var pulledJPGList = [UIImage]()
    @IBOutlet weak var name: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfListView.dataSource = self
        pdfListView.delegate = self
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor,
        ]
        view.layer.addSublayer(gradientLayer)
        
        pdfListView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        //usernameTextField.tintColor = UIColor.systemBrown
        view.addSubview(importFile)
        view.addSubview(uploadFile)
        view.addSubview(collection)
        view.addSubview(userIcon)
        view.addSubview(userName)
        view.addSubview(myCollectionTitle)
        
        
        //Uncomment to mess with constraints
        
        
//        let layout = pdfListView.collectionViewLayout as! UICollectionViewFlowLayout
//
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        let width = (view.frame.size.width - layout.minimumLineSpacing * 2 ) / 3
//        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
        
        let thisUser = PFUser.current()
        self.userName.text = thisUser?.username
        
        
        var query = PFQuery(className: "PDF")
        query.includeKeys(["ACL", "pdfArr"])
        //query limit is important to see what max amount of pdfs we want to load in
        query.limit = 40
        query.findObjectsInBackground { (pdfArr, error) in
        if pdfArr != nil{
            //change back to 14
            let a = pdfArr![3]
            let b = a["pdfArr"] as! [PFFileObject]
            self.pdfList = pdfArr!
            
            print("pdfList size:\(self.pdfList.count)")
            self.pdfListView.reloadData()
        } else {
            print("Error: \(error)")
        }
        }
        
        
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
    
    // This segment of code until line 244 (reference 6 from report).
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PDFCollectionViewCell
        
        let indexPath = pdfListView.indexPath(for: cell)
        
        
        let l = pdfList[indexPath!.item]
        let g = l["pdfArr"] as! [PFFileObject]
        
        
        let secondDetailsViewController = segue.destination as! PDFViewerController
        secondDetailsViewController.pdfPages = g

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("In collectionView (pdfLIst.count): \(self.pdfList.count)")
        return self.pdfList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFCollectionViewCell", for: indexPath) as! PDFCollectionViewCell
//        uncomment to debug
//        print("indexPath.item: \(indexPath.item)")
        
        let singlePDF = pdfList[indexPath.item]
        let thumbNailOfSingle = singlePDF["pdfArr"] as! [PFFileObject]
        let thumb = thumbNailOfSingle[0].url!
        let thumbnailURL = URL(string: thumb)!
        // This segment of code until line 281 (reference 7 from report).
        if let data = try? Data(contentsOf: thumbnailURL) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.pdfThumbnail.image = image
                }
            }
        }
        //
        cell.pdfURLInfo = thumbNailOfSingle
//        uncomment to debug
//        print("cell.pdfURLInfo.count = \(cell.pdfURLInfo.count)")
        
        cell.contentView.layer.cornerRadius = 5.0
        
        return cell
    }
    
    
    
    
}
