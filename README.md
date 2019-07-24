# ObjectAnnotation
Image annotation tool for a createML app object detection project.

<b>Installation</b>

*clone the github project
*open the project directory in terminal
*pod update 
*close the .xcodeproj if open
*open the workspace file in the project directory
*enter you flickr apikey in the Constants.swift file

<b>Description</b>

The CreateML App is one of the Xcode Developer Tools when using the Xcode beta along with the Macos Catalina beta. This app allows users to create training sets for createML object detection. 

This project utilizes Kingfisher for image handling. Thanks to the Kingfisher team and contributors. 
https://github.com/onevcat/Kingfisher

The user interface is programmatic. The storyboard has been removed and the app delegate has been updated to launch the view controller.

The initial view controller allows for creation and/or selection of a training set. Already created sets appear within the controller's tableview. The '+' button on the navigation bar creates a training set. The training set and associated images are saved to a core data model for persistance. The settings icon on the navigation bar opens a settings view controller. 
<p>
  <kbd>
<img align="left" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/TrainingSetList.png">
  </kbd>
  <kbd>
<img align="center" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/AddSet.png">
  </kbd>
<p>

The trainingset viewcontroller displays the annotated images. From the navigation bar users can click on the share icon. This action allows users to save the folder which contains the images and annotations.json file which declares the rectagles x, y, width, height and declared label of the object identified within the image.

<kbd>
<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/Share.png">
  </kbd>

The '+' opens an alert. Enter a search tag. The flickr is searched for relevant images. Clicking on the image navigates to a viewcontroller with an imageview. Identify the object and label by long pressing on opposing corners of the object. This prompts the user with an alert. Enter the label of the object. The view then moves back to the collectionview with the images from the flickr search. Apple recommended having at least thirty images of the object that you want to detect for training. Training for object detection takes significantly longer than for image classification.
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




