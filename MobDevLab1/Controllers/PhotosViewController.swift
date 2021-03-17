//
//  PhotosViewController.swift
//  MobDevLab1
//
//  Created by Dima on 14.03.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var arrayOfPictures:[UIImage] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? MyCollectionViewLayout {
            layout.delegate = self
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //self.collectionView.reloadData()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.configure(image: UIImage(named: "AppIcon")!)
        
        return cell
    }
    
    
}


extension PhotosViewController: MyCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if((indexPath.item + 1) % 6 == 1) {
            return collectionView.frame.width/5*3
        } else if (((indexPath.item + 1) % 6 == 2 ) || (indexPath.item + 1) % 6 == 3) {
            return collectionView.frame.width/5*2
        } else {
            return collectionView.frame.width/5
        }
    }
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func openPhotos() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let newImage = info[.originalImage] as? UIImage else { return }
        arrayOfPictures.append(newImage)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


