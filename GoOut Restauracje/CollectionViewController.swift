//
//  CollectionViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import Kingfisher

protocol CollectionViewControllerDelegate
{
    func collectionController(_ collectionController:CollectionViewController, scrolledToCellAtIndexPath indexPath:IndexPath);
}


class CollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource
{
    var parentCollectionView:UICollectionView?
    var collectionDelegate:CollectionViewControllerDelegate! = nil
    var parentViewController:UIViewController?
    var dataArray = NSArray()
    //MARK:TableView delegate dataSource
    
    func setupCollectionView()
    {
        parentCollectionView?.delegate = self;
        parentCollectionView?.dataSource = self;
    }
    
    func reloadCollectionView()
    {
        self.parentCollectionView?.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellIdentifier = "CollectionViewCell"
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let imageView = UIImageView()
        imageView.frame.size.width = (parentCollectionView?.frame.size.width)!
        imageView.frame.size.height = (parentCollectionView?.frame.size.height)!
        collectionCell.addSubview(imageView)
        let url = URL(string: RestConstants.imagesBaseLink + (dataArray[(indexPath as NSIndexPath).row] as! String))
        imageView.kf.setImage(with: url!)
        imageView.contentMode = .scaleAspectFill

        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (parentCollectionView?.frame)!.width, height: (parentCollectionView?.frame)!.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let collectionOrigin = parentCollectionView!.bounds.origin
        let collectionWidth = parentCollectionView!.bounds.width
        var centerPoint: CGPoint!
        var newX: CGFloat!
        if collectionOrigin.x > 0 {
            newX = collectionOrigin.x + collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        } else {
            newX = collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        }
        let indexPath:IndexPath = parentCollectionView!.indexPathForItem(at: centerPoint)!

        collectionDelegate.collectionController(self, scrolledToCellAtIndexPath: indexPath)
    }

}
