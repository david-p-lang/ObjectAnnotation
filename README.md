# ObjectAnnotation
Image annotation tool for a createML app object detection project.

The CreateML App is one of the Xcode Developer Tools when using the Xcode beta along with the Macos Catalina beta. This app allows users to create training sets for createML object detection. 


This project utilizes Kingfisher for image handling. Thanks to the Kingfisher team and contributors. 
https://github.com/onevcat/Kingfisher

The user interface is programmatic. The storyboard has been removed and the app delegate has been updated to launch the view controller.

The initial view controller allows for creation and/or selection of a training set. Already created sets appear within the controller's tableview. The '+' button on the navigation bar creates a training set. The settings icon on the navigation bar opens a settings view controller. 
<p>
<img align="center" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/TrainingSetList.png">

<img width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/AddSet.png">
<img align="center" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/ImageSelection.png">
<img align="left" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/AddLabel.png">

<img align="right" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/LabeledImages.png">
<img align="left" width="250" src="https://github.com/david-p-lang/ObjectAnnotation/blob/master/images/ObjectFrame.png">


