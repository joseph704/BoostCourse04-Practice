//
//  ImageZoomViewController.swift
//  BoostCourse04-Practice
//
//  Created by 차요셉 on 22/01/2020.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit
import Photos
class ImageZoomViewController: UIViewController,UIScrollViewDelegate {
    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    @IBOutlet weak var imamgeView: UIImageView!
    
    // Zoom을 해줄 뷰 설정
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imamgeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil, resultHandler: {image, _ in self.imamgeView.image = image})
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
