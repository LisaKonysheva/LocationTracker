# LocationTracker

iOS app that enables user to track their walk with images.

Implementation details: MVVM, CoreLocation, CoreData, Flickr API, XCTest 

## What I've learned

1. I've learned how to use Flickr API :) it took a while to find out what params to send or how to specify image size
2.  I refreshed my knowledge of CoreLocation, revisited some WWDC videos, learned more about different permissions 
and tracking modes.
3. It was a lot of fun actually testing the app and see how quickly an app can grow to a working prototype.


## Ideas for improvements

1. Currently user location tracked every 100 m, then request sent to Flickr to get the first photo for this location within 
40m radius to avoid duplication of photos. This radius can be increased (which increases a pobablity to find photos for
specific location) and every time random photo would be taken from the list.
2. If user is a keen walker (say Elliud Kipchoge can do 42 km in 2 hours) we may end up with list of 400 locations and a 
nice implementation of paging would help in this case.
3. More sophisticated image cache
4. Delta encoding compression can be used for storing latitude and longitude in order to optimize storage or to send large 
amount of data to the server.


