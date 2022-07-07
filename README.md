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
[Description of your app]

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Books and Reference
- **Mobile:** This app is primarily developed as a mobile application but would be viable as a desktop application or an android application. Functionality and features are not just limited to mobile devices.

- **Story:** Stores a users e-books through a pdf, and provides optionality to upload new pdfs. User can then open an e-book and allow user to scroll through book and exit reading through use of eyes.

- **Market:** Any individual could choose to use and read through this app. Usable for users of all age demographics.
- **Habit:** This app could be used as often or often as user wants depending on a users physical ability or limitations.

- **Scope:** First we would start with selecting a book then we would then calibrate our eye tracking application to prepare for reading. A new windows then would be opened with the e-book to read which can now be controlled with the user’s eyes to scroll and also exit the book.


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [fill in your required user stories here]
* ...
- User logs in to access already uploaded books or registers an account.
- User has option to pick a book to read or upload a new book to their list of stored books.
- When reading a book user can use eyes to look down and up and scroll to bottom or up respectively.
- When preparing to exit, reader will focus on button and after few miliseconds is exited out of e-book.

**Optional Nice-to-have Stories**

* [fill in your required user stories here]
* ...
- User can focus on certain area of reading and then highlight looked on section.
- User can focus on buttons on botton left and botton right to go back and forward on pages.
- Have screen atmosphere toggle during certain points of day morning/night.

### 2. Screen Archetypes

* [Login]
   * [list associated required story here]
   * ...
   - Login an already registered user
* [Register]
   * [list associated required story here]
   * ...
   - User sings up or logs into their account
       - Upon registering the user is prompted to log in to gain acess to the homepage
* [Homepage]
    - Allows user to see the list of books and then upload a new book if desired.
        * Upon clicking an already uploaded book it directs to calibration page.
    

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* [fill out your first tab]
* [fill out your second tab]
* [fill out your third tab]

**Flow Navigation** (Screen to Screen)

* [list first screen here]
   * [list screen navigation here]
   * ...
* [list second screen here]
   * [list screen navigation here]
   * ...

## Wireframes
[Add picture of your hand sketched wireframes in this section]

### [BONUS] Digital Wireframes & Mockups

![](https://i.imgur.com/Tb4Tsvo.png)

### [BONUS] Interactive Prototype
Login
<img src="http://g.recordit.co/749EUT7igL.gif"><br>

Select/Upload
<img src="https://i.imgur.com/kKabBCH.gif" width=4000><br>


Select and Track
<img src="https://i.imgur.com/T9aIp95.gif" width=4000><br>

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

### ACADEMIC (Installing Instructions)
1. Download Xcode on laptop/pc
2. Unpack project zip and open with Xcode
3. Under Settings -> Signing Capabilities, change team to personal team and budle identifier to match Apple ID
4. Connect device (currently limited to iPad) to laptop and allow configurations on mobile device to download apps
5. On XCode, select connected device to run project

If API key is exprired, head to https://manage.seeso.io/#/sign and request new API key.

Replace API key in "PDFViewController.swift" file

