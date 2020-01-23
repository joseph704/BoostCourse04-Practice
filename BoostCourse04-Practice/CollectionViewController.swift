//
//  CollectionViewController.swift
//  BoostCourse04-Practice
//
//  Created by 차요셉 on 22/01/2020.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView:UICollectionView!
    var numberOfCell: Int = 10
    let cellIdentifier: String = "cell"
    var friends: [Friend] = []
    
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let halfWidth: CGFloat = UIScreen.main
            .bounds.width / 2.0
        flowLayout.estimatedItemSize = CGSize(width: halfWidth - 30, height: 90)
        self.collectionView.collectionViewLayout
         = flowLayout
        
        let jsonDecoder:JSONDecoder = JSONDecoder()
        guard let dataAseet:NSDataAsset = NSDataAsset(name: "friends") else { return }
        
        do {
            self.friends = try jsonDecoder.decode([Friend].self, from: dataAseet.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FriendCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? FriendCollectionViewCell) else {return FriendCollectionViewCell()}
        let friend:Friend = friends[indexPath.item]
        cell.addressLabel.text = friend.fullAddress
        cell.nameAgeLabel.text = friend.nameAndAge
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.numberOfCell += 1
        collectionView.reloadData()
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
