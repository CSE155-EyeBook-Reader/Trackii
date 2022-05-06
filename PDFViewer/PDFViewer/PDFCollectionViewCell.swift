//
//  PDFCollectionViewCell.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 5/5/22.
//

import UIKit
import Parse

class PDFCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pdfThumbnail: UIImageView!
    var pdfURLInfo: [PFFileObject] = []
}
