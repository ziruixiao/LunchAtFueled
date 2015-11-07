# LunchAtFueled

Felix Xiao

iOS challenge written in Swift 2.0 for Fueled NYC.


### Documentation

##### Application Files
* AppDelegate.swift
1. Loads core data context and migrates if necessary.
2. Sets up initial Foursquare API connection session.

* Connection.swift
1. ``getVenuesFromLocation(parameters)`` takes in search parameters for a location and queries the Foursquare API, sending all results into a static parser function declared in APIModel and implemented by all model classes.
2. ``getTipsFromVenue(venueId)`` takes in a venue id and queries the Foursquare API, senidng all results into the static parser function.

* LunchAtFueled.xcdatamodeld
1. CoreData model file, containing only one version for simplicity.
2. There are 2 entities, ``Venue`` and ``Tip``.

* Main.storyboard
1. UIKit objects in this project are created on the interface builder with a single storyboard.

##### Model
* APIModel.swift
1. Protocol that contains 2 methods that all model classes requiring communication with the Foursquare API should implement.
2. ``process(records)`` takes in a JSON format parameter that is an array of the objects that need to be parsed.
3. ``store(record)`` takes in a single JSON dictionary and assigns variable values to class properties.

* Tip.swift
1. Model class that implements the methods in ``APIModel``.

* Venue.swift
1. Model class that implements the methods in ``APIModel``.

##### View
* VenueTableViewCell.swift
1. Custom table view cell to display venues. Contains a few ``IBOutlet`` properties.

##### View Controllers
* VenuesViewController.swift
1. Upon load, the VC subscribes to ``VenuesLoaded`` in ``NSNotificationCenter``. When published, the VC calls ``updateVenues()`` which refreshes the table view and reloads the data source from Core Data.
2. ``resetButtonTapped()`` batch updates all ``Venue`` objects so that ``hidden = false``.
3. ``configureCellWithItem(cell, item)`` loads a ``VenueTableViewCell`` with the properties of the input ``Venue``.
4. ``openVenue(venue)`` loads a ``TipsViewController`` and assigns the ``venue`` property before pushing onto the navigation controller.

* TipsViewController.swift
1. Upon load, the VC subscribes to ``TipsLoaded`` in ``NSNotificationCenter``. When published, the VC calls ``updateTips()`` which refreshes the table view and reloads the data source from Core Data.
2. ``showNewTipPage()`` loads a ``AddTipViewController`` and assigns the ``venue`` property before pushing onto the navigation controller.

* AddTipViewController.swift
1. ``addTip()`` validates the text view and either shows an alert if no content is found or creates a new ``Tip`` to store in CoreData. The view controller is popped off the navigation controller and a notification for ``TipsLoaded`` is posted.

##### Extensions
* Double+Extensions.swift
1. Contains a single method to round a double to a number of decimal places.

* NSDate+Extensions.swift
1. Contains a method to convert ``NSDate`` to text representation based on time ago since current date.

* CLLocation+Extensions.swift
1. Contains a single method declared from [das-quadrat].

### Third Party Resources

LunchAtFueled makes use of the following technologies:
* [Foursquare Libraries] - Recommended wrappers on FourSquare's official documentation website.
* [das-quadrat] - FourSquare wrapper using Swift. 
* [AERecord] - Swift wrapper for CoreData.
* [Font Awesome] - Swift implementation for Font Awesome.
* [Cosmos] - 5 star rating UIKit module.

[das-quadrat]: <https://github.com/Constantine-Fry/das-quadrat>
[Foursquare Libraries]: <https://developer.foursquare.com/resources/libraries>
[AERecord]:
<https://github.com/tadija/AERecord>
[Font Awesome]:
<https://github.com/thii/FontAwesome.swift>
[Cosmos]:
<https://github.com/exchangegroup/Cosmos>