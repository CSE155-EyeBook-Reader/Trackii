Trackii - README 
===

# Trackii

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Trackii is a mobile application that provides accessibility for a pdf-reader by tracking the users' eyes.

Technological progress can only be defined as progress in all directions for all of society, which requires inclusivity. Trackii, aims to inspire and provide solutions to enable more humans to interact with pdfs in a user-friendly manner.

### App Evaluation

- **Category:** Books and Reference
- **Mobile:** This app is primarily developed as a mobile application but would be viable as a desktop application or an android application. Functionality and features are not just limited to mobile devices.

- **Story:** Stores a users e-books through a pdf, and provides optionality to upload new pdfs. User can then open an e-book and allow user to scroll through book and exit reading through use of eyes.

- **Market:** Any individual could choose to use and read through this app. Usable for users of all age demographics.
- **Habit:** This app could be used as often or often as user wants depending on a users physical ability or limitations.

- **Scope:** First we would start with selecting a book then we would then calibrate our eye tracking application to prepare for reading. A new windows then would be opened with the e-book to read which can now be controlled with the user’s eyes to scroll and also exit the book.


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- User logs in to access already uploaded books or registers an account.
- User has option to pick a book to read or upload a new book to their list of stored books.
- When reading a book user can use eyes to look down and up and scroll to bottom or up respectively.
- When preparing to exit, reader will focus on button and after few miliseconds is exited out of e-book.

**Optional Nice-to-have Stories**

- User can focus on certain area of reading and then highlight looked on section.
- User can focus on buttons on botton left and botton right to go back and forward on pages.
- Have screen atmosphere toggle during certain points of day morning/night.

### 2. Screen Archetypes

* [Login]
   - Login an already registered user
* [Register]
   - User sings up or logs into their account
       - Upon registering the user is prompted to log in to gain acess to the homepage
* [Homepage]
    - Allows user to see the list of books and then upload a new book if desired.
        * Upon clicking an already uploaded book it directs to calibration page.
* [DetailedPDFView]
    - Allows user to view the selected pdf in full, while being scrolling up/down/right/left, through eye tracking movement
    

### 3. Navigation

**Flow Navigation** (Screen to Screen)

* [Login <-> HomePage]
* [SignUp <-> HomePage]
* [HomePage <-> DetailedPDFView]
* [DetailedPDFView <-> HomePage]

## Wireframes
[Add picture of your hand sketched wireframes in this section]

### Digital Wireframes & Mockups

![](https://i.imgur.com/Tb4Tsvo.png)

### Interactive Prototype
Login

<img src="https://i.imgur.com/Sn91q6g.gif"><br>

SignUp

<img src="https://i.imgur.com/E62d8qy.gif"><br>

Select/Upload

<img src="https://i.imgur.com/PjXTSMg.gif"><br>


Select and Track

<img src="https://i.imgur.com/yDkzZH8.gif"><br>


## Schema 
### Models
<details>
  
  <summary>Person</summary>
  
| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| objectId | String   | unique id for user     |
| userName | String   | name of user |
| password | String  | password of user |
  
  
</details>

<details>

  <summary>PDF</summary>

| Column 1 | Column 2 | Column 3 |
| -------- | -------- | -------- |
| objectId | String   | unique id for pdf    |
| userName | Array   | array of images |

</details>

### Networking

<details>
  <summary>Login Screen(READ): Fetch user account</summary>
  
```
      let username = usernameField.text!
      let password = passwordField.text!

      PFUser.logInWithUsername(inBackground: username, password: password){
          (user, error) in
              if user != nil {
                  self.performSegue(withIdentifier: "loginSegue", sender: nil)
              }else{
                  print("Error: \(error?.localizedDescription)");
              }
      }
```
  
</details>

<details>
  <summary>Sign-Up Screen (POST/UPDATE): Create new user</summary>

```
         if passwordTextField.text == passwordConfirmationTextField.text {
            let user = PFUser()
            user["name"] = nameTextField.text
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
                
            }
        }else{
            print("Error: passwords not match")
        }  


```
  
</details>

<details>
  <summary>Home Page (Read/Get): Query all pdf objects into collection view</summary>
  
```
        var query = PFQuery(className: "PDF")
        query.includeKeys(["ACL", "pdfArr"])
        //query limit is important to see what max amount of pdfs we want to load in
        query.limit = 40
        query.findObjectsInBackground { (pdfArr, error) in
        if pdfArr != nil{
            //change back to 14
            let a = pdfArr![3]
            let b = a["pdfArr"] as! [PFFileObject]
            self.pdfList = pdfArr!
            
            print("pdfList size:\(self.pdfList.count)")
            self.pdfListView.reloadData()
        } else {
            print("Error: \(error)")
        }
        }
  
  
```
  
  
  
```
        let cell = sender as! PDFCollectionViewCell
        
        let indexPath = pdfListView.indexPath(for: cell)
        
        
        let l = pdfList[indexPath!.item]
        let g = l["pdfArr"] as! [PFFileObject]
        
        
        let secondDetailsViewController = segue.destination as! PDFViewerController
        secondDetailsViewController.pdfPages = g
  
  
```
  
  
</details>

<details>
  <summary>Home Page (Create/Update): Create new pdf object and push to database</summary>
  
```
            let pdfURL = storage.url(forKey: "PDFURL")!
                
            let doc = PDFDocument(url: pdfURL)
                
            for i in 1...doc!.pageCount{
                segmentedPDFToJPGList.append(thumbnailFromPdf(withUrl: pdfURL, pageNumber: i)!)
            }
                   
              
            var stringVersion = [PFFileObject]()
            for i in 0...segmentedPDFToJPGList.count-1 {
                let imageData = segmentedPDFToJPGList[i].pngData()
                let file = PFFileObject(name: "image.png", data: imageData!)!
                stringVersion.append(file)
            }
                
            let parseObject = PFObject(className: "PDF")
            parseObject["pdfArr"] = stringVersion
                
                   
            parseObject.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    print("Success")
                    self.viewDidLoad()
                } else {
                    print("Fail")
                    print("Error: \(error)")
                }

            }
  
  
```
  
</details>



### ACADEMIC (Installing Instructions)
1. Download Xcode on laptop/pc
2. Unpack project zip and open with Xcode
3. Under Settings -> Signing Capabilities, change team to personal team and budle identifier to match Apple ID
4. Connect device (currently limited to iPad) to laptop and allow configurations on mobile device to download apps
5. On XCode, select connected device to run project

If API key is exprired, head to https://manage.seeso.io/#/sign and request new API key.

Replace API key in "PDFViewController.swift" file

