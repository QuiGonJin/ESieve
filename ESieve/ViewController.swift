//
//  ViewController.swift
//  ESieve
//
//  Created by Kevin Chen on 2/19/16.
//  Copyright (c) 2016 KevinChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let screensize = UIScreen.mainScreen().bounds
    let reuseIdentifier = "collectionCell"
    var collectionView : UICollectionView?
    var numCells = 150                                          // Initial value of N
    var primes = [Bool](count: 151  , repeatedValue: true)      // Initialize 'is prime' bool for 0..n
    var primeValues = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        //Detect all taps on screen
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleScreenTap:"))
        tapGesture.cancelsTouchesInView = false;
        
        //Layout
        var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: CGRectMake(10, 10, screensize.width-20, screensize.height - screensize.height*0.2 ), collectionViewLayout: flowLayout);
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier);
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView!.backgroundColor = UIColor.clearColor();
        collectionView!.layer.anchorPoint = CGPointMake(0.5, 0.5)
        collectionView!.layer.position = CGPointMake(screensize.width/2, screensize.height/2 + screensize.height/10)
        
        
        //input text box
        var input = UITextField(frame: CGRectMake(0, 0, screensize.width*0.9, 30))
        input.center = CGPointMake(screensize.width/2, screensize.height/15+15)
        input.backgroundColor = UIColor.lightGrayColor()
        input.textAlignment = NSTextAlignment.Center
        input.layer.cornerRadius = 5
        input.placeholder = "select N"
        input.keyboardType = UIKeyboardType.NumberPad
        input.addTarget(self, action: "inputValueDidChange:", forControlEvents: .EditingDidEnd)
        
        //calculate button
        var calculate = UIButton()
        calculate.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        calculate.setTitle("Calculate Primes", forState: UIControlState.Normal)
        calculate.frame = CGRectMake(0, 0, screensize.width*0.9, 30)
        calculate.backgroundColor = UIColor.orangeColor()
        calculate.center = CGPointMake(screensize.width/2, screensize.height/15 + 55)
        calculate.layer.cornerRadius = 5
        calculate.addTarget(self, action: "calculateDown:", forControlEvents: .TouchDown)
        calculate.addTarget(self, action: "calculateUpInside:", forControlEvents: .TouchUpInside)
        calculate.addTarget(self, action: "calculateUpOutside:", forControlEvents: .TouchUpOutside)
        
        //Initialize primesValues array
        populatePrimeValues()
        
        //Add UI elements to view
        self.view.addSubview(collectionView!);
        self.view.addSubview(calculate)
        self.view.addSubview(input)
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func calculateDown(sender: UIButton!){
        sender.backgroundColor = UIColor.lightGrayColor()
    }
    
    func calculateUpInside(sender: UIButton!){
        calculatePrimes()
        sender.backgroundColor = UIColor.orangeColor()
    }
    
    func calculateUpOutside(sender: UIButton!){
        sender.backgroundColor = UIColor.orangeColor()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        var n = 0
        
        //Will be n or the number of primes depending on whether or not the primes have been calculated
        for var i = 1; i <= numCells; i++ {
            if (primes[i]){
                n++
            }
        }
        return n
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell;
        var index = indexPath.section*2 + indexPath.row + 1


        //Create new label if it doesn't already exist, else update old label
        if let nameLabel = cell.viewWithTag(100) as? UILabel{
            nameLabel.text = String(index)
        } else {
            var dim = self.collectionView!.frame.size.width/10
            let nameLabel = UILabel(frame: CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(dim,dim) ) )
            nameLabel.tag = 100;
            nameLabel.text = String(primeValues[indexPath.item])
            nameLabel.numberOfLines = 1
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.lineBreakMode = NSLineBreakMode.ByClipping
            nameLabel.textAlignment = NSTextAlignment.Center
            cell.addSubview(nameLabel)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var myText = collectionView.cellForItemAtIndexPath(indexPath)!.viewWithTag(100) as! UILabel
        println(myText.text)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.orangeColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var dim = self.collectionView!.frame.size.width/10
        return CGSizeMake(dim, dim);
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    //Tap anywhere to put away keypad
    func handleScreenTap(sender: UIView) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Called when user inserts new n
    //If n is a valid integer, recreates scene for new input
    func inputValueDidChange(sender:UITextField!) {
        var num: Int? = sender.text.toInt()
        if num != nil {
            println("Valid Integer")
            self.numCells = num!
            populatePrimes()
            populatePrimeValues()
            reloadCollection()
        }
        else {
            println("Not Valid Integer")
        }
        
    }
    
    //generate new collection cells
    func reloadCollection(){
        for cell in collectionView?.visibleCells() as! [UICollectionViewCell] {
            for view in cell.subviews as! [UIView] {
                view.removeFromSuperview()
            }
            cell.removeFromSuperview()
        }
        self.collectionView?.reloadData()
    }
    
    //fill primes with n 'true' values
    func populatePrimes() {
        self.primes.removeAll(keepCapacity: false)
        for var i = 0; i <= numCells; i++ {
                self.primes.append(true)
        }
    }
    
    //fills primeValues with the values of numbers not yet labeled as not-prime
    func populatePrimeValues(){
        self.primeValues.removeAll(keepCapacity: false)
        for var i = 1; i <= numCells; i++ {
            if (primes[i]){
                primeValues.append(i)
            }
        }
    }
    
    //Applies Eratosthenes
    func calculatePrimes() {
        primes[0] = false
        primes[1] = false
        for var i=2; i*i<=numCells; i++ {
            if (primes[i] == true){
                for var j = i*2; j <= numCells; j += i {
                    primes[j] = false;
                }
            }
        }
        populatePrimeValues()
        reloadCollection()
    }
}

