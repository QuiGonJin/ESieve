# ESieve
Author: Kevin Chen
Ver: 1.0
Target: iPhone 6
iOS SDK 8.4

ESieve is a simple iOS calculator to display all prime numbers between 0 and n utilizing Eratosthenes sieve.



Details:

  Implementation:
  
    Built ontop of XCode Ver.6.4's Swift Single View Application. 
  
    All implementation specific to this app is inside ViewController.swift

  Usage On load:
    
    App loads with default n of 150 and displays a collection of numbers from 1 to n
    
    Clicking 'Calculate Primes' will eliminate the composite numbers from the collection
  
  Usage for Custom value:
    
    Tap on the text field labeled 'select N' and enter an integer value for n. (Recommended max value is under 100,000)
    
    If the value is a valid input, the collection will reload and display the set of numbers between 1 and n
    
    If the value is invalid, the collection will remain unchanged
    
    Tapping on 'Calculate Primes' will eliminate the composite numbers from the collection
    
