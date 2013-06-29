FaceImageView
--------

A `UIImageView` clone with a catch:

FaceImageView automatically draws its image to fill its bounds **and include any faces detected**. This can be useful if you want to display dynamic content with `UIViewContentModeScaleToFill` but are having issues with it displaying the wrong part of the image.

A little demo app is included to try out different images and view sizes.

Usage
-----------------
```objc
FaceImageView *imageView = [[FaceImageView alloc] initWithFrame:<frame>];
imageView.image = [UIImage imageNamed:@"image"];
[self.view addSubview:imageView];
```

![demo](http://danhassin.com/img/face-demo3.png)