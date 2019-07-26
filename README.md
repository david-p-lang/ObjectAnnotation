# ObjectAnnotation

This project is Xcode 10.0-compatible, deployment target 12.2

Image annotation tool for a createML app object detection project.

<b>Installation</b>

* clone the github project
* open the project directory in terminal
* enter the command - pod update - in terminal 
* close the .xcodeproj if open
* open the workspace file in the project directory
* enter your flickr apikey in the Constants.swift file

<b>Description</b>

The CreateML App is one of the Xcode Developer Tools available for use with the Xcode <b>beta</b> along with the <b>Macos Catalina beta</b>. This app allows users to create training sets for createML object detection. 

This project utilizes Kingfisher for image handling. Thanks to the Kingfisher team and contributors. 
https://github.com/onevcat/Kingfisher

A note for developers, the user interface is programmatic. The storyboard has been removed and the app delegate has been updated to launch the initial view controller.

The initial view controller allows for creation and/or selection of a training set. Training sets that have already been created appear within the controller's tableview. The '+' button on the navigation bar creates a training set, which the user names via an alertviewcontroller. The training set and associated images are saved to a core data model for persistance. The settings icon on the navigation bar opens the settings view. 
<p>
  <kbd>
<img align="left" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/TrainingSetList.png">
  </kbd>
  <kbd>
<img align="center" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/AddSet.png">
  </kbd>
<p>

The training set view displays the annotated images of a single training set. From the training set view, the navigation bar contains a share button and a '+' button. This share button allows users to save the folder which contains the images and annotations.json file. The share button also opens the standard share alert controller to airdrop, mail ... the training set folder and files. The '+' opens an alert. Use this to enter a search tag. The flickr is searched for relevant tagged images. Clicking on the image navigates to a view with the selected image.

<kbd>
<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/Share.png">
  </kbd>

The object of interest can be selected and labelled by long pressing on opposing corners of the object. This prompts the user with an alert. Enter the label of the object into the alert textfield. The view then moves back to the collectionview with the images from the flickr search. Apple recommended having at least thirty images of the object that you want to detect for training. Training for object detection takes significantly longer than for image classification.
<p>
  <kbd>
<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/ImageSelection.png">
  </kbd>
    <kbd>
<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/ObjectFrame.png">
  </kbd>
  <kbd>
<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/AddLabel.png">
  </kbd>

<p>




