FaceImageView
--------

A `UIImageView` clone with a catch:

FaceImageView automatically scales its image to fill the bounds **and keep any faces detected in view**. This can be useful if you want to display people-based dynamic content with `UIViewContentModeScaleToFill` but are having issues with it displaying the wrong part of the image, like the background, or someone's feet.

The class uses the CoreImage face detection APIs available in iOS 5.0 or later. This API works in many clear cases, but is not all that reliable. If no faces are detected in an image, FaceImageView defaults to centering the image, like `UIImageView`'s behavior with `UIViewContentModeScaleToFill`.

A small demo app is included to try out different images and view sizes.

Usage
--------

As simple as instantiating one, giving it an image, and adding it to your view:
```objc
FaceImageView *imageView = [[FaceImageView alloc] initWithFrame:<frame>];
imageView.image = [UIImage imageNamed:@"image"];
[self.view addSubview:imageView];
```

Demo App
---------

Watch faces automatically stay centered in the view as it changes size:

![demo](http://danhassin.com/img/face-demo3.png)

--------------

Posted for the [Objective-C hackathon](https://objectivechackathon.appspot.com/) effort :)