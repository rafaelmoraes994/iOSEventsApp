//
//  LoginViewController.swift
//  Projeto Final
//
//  Created by Rafael on 4/14/17.
//  Copyright © 2017 Rafael. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func didFinishLogin ()
}

class LoginViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var loginDelegate: LoginDelegate?
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        loginDelegate?.didFinishLogin()
    }
    
    @IBOutlet weak var loginCollectionView: UICollectionView!
    
    @IBOutlet weak var facebookButton: UIButton!

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! TutorialCell
        
        cell.cellImage.image = UIImage(named: "tutorialImage\(indexPath.row)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: loginCollectionView.frame.width, height: loginCollectionView.frame.height)
    }

}


