//
//  ViewController.swift
//  feed
//
//  Created by Андрей on 22.11.16.
//  Copyright © 2016 Андрей. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController {

    var entries: [Entry]? = []
    
    let entryCellId = "entryCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Test Feed Reader"
        
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
        let urlStr = "https://newsapi.org/v1/articles?source=daily-mail&sortBy=latest&apiKey=d8173ac4d7004dd99a9c4187bc163df1"
        let url = URL(string: urlStr)//NSURL(string:urlStr)
        URLSession.shared.dataTask(with:  url!, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    let str = json["articles"] as! [NSDictionary]
                    self.entries = [Entry]()
                    for strs in str {
                        let title = strs["title"] as? String
                        let description = strs["description"] as? String
                        let url = strs["url"] as? String
                        self.entries?.append(Entry(title: title, description: description, url: url))
                    }
                    self.collectionView?.reloadData()
                } catch {
                }
            }
        }).resume()
        
        
    }
    
    func performSearchForText(_ text: String) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
        let entry = entries?[indexPath.item]
        entryCell.titleLabel.text = entry?.title
        entryCell.contentSnippetTextView.text = entry?.description
        return entryCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchHeader
        header.FeedController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}

struct Entry {
    var title: String?
    var description: String?
    var url: String?
}
