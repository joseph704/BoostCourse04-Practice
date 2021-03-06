//
//  ViewController.swift
//  BoostCourse04-Practice
//
//  Created by 차요셉 on 20/01/2020.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit
import Photos
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PHPhotoLibraryChangeObserver {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func touchUpDownloadButton(_ sender: Any) {
        guard let imageURL: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg") else { return }
        // 자식 스레드에는 데이터 다운로드 부분
        OperationQueue().addOperation {
            let imageData:Data = try! Data.init(contentsOf: imageURL)
            guard let image:UIImage = UIImage(data: imageData) else { return }
            // 애플리케이션 뷰 부분은 메인 스레드에서 동작해야함!
            OperationQueue.main.addOperation {
                self.imageView.image = image
            }
        }
    }
    @IBAction func touchUpRefreshButton(_ sender:UIBarButtonItem) {
        self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
    }
    
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "cell"
    
    func requestCollection() {
        
        // fetchResult 클래스를 사용해
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: . smartAlbum, subtype: . smartAlbumUserLibrary, options:nil)
        guard let cameraRollCollection = cameraRoll.firstObject else { return }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 사진첩 접근 권한
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
            self.tableView.reloadData()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                    case .authorized:
                        print("접근 허가됨")
                        self.requestCollection()
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                        }
                    case .denied:
                        print("접근 불허")
                default: break
                }
                
            })
        case .restricted:
            print("접근 제한")
            
        }
        
        PHPhotoLibrary.shared().register(self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let asset: PHAsset = self.fetchResult.object(at: indexPath.row)
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 30, height: 30), contentMode: .aspectFill, options: nil, resultHandler: {image, _ in cell.imageView?.image = image})
        return cell
    }
    
    // 테이블뷰 편집 여부 메소드
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // 편집모드로 들어 왔을 때 편집 스타일에 따른 메소드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset: PHAsset = self.fetchResult[indexPath.row]
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSArray)}, completionHandler: nil)
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.fetchResult) else { return }
        
        self.fetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageZoomViewController = segue.destination as? ImageZoomViewController else { return }
        
        guard let cell : UITableViewCell = sender as? UITableViewCell else { return }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else { return }
        nextViewController.asset = self.fetchResult[index.row]
    }
}

