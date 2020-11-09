//1

//1a

MERGE (h: Hosts { hostId: 1900400})
ON CREATE SET
h.hostUrl = "https://www.airbnb.com.au/users/show/7211951",
h.hostName = "Mellisa",
h.hostVerifications = ["government_id", "selfie", "email", "phone"],
h.hostLocation = "Melbourne, Victoria, Australia",
h.hostResponseTime = "within an hour",
h.hostIsSuperhost = true,
h.hostSince = Date("2013-10-02")
RETURN h

MATCH (h: Hosts {hostId: 1900400})
MERGE (l: Listings {listingId: 400500})
ON CREATE SET
l.name = "Luxury Master Room w Stunning River View - MODERN",
l.summary	 = "We are offering a master room (with private bathroom) in a modern 3-bedroom room apartment in Southbank. Jane as host lives here. It is the best place in Melbourne to live behind the beautiful yarra river with the French window in your private space.",
l.listingUrl	= "https://www.airbnb.com.au/rooms/9516067?source_impression_id=p3_1571820797_wdj%2FkaEL%2FpPRr40A",
l.pictureUrl = "https://www.airbnb.com.au/rooms/9516067/slideshow/434651659?adults=1&children=0&infants=0",
l.neighbourhood = "Southbank",
l.street = "Melbourne, Victoria, Australia",
l.zipcode = 3000,
l.latitude = -37.8290,
l.longitude = 144.9570,
l.roomType = "Private room",
l.amenities	 = ["Air conditioning", "Dryer", "Play TV", "Essentials"],
l.extraPeople = 25,
l.price = 59,
l.minimumNights = 1,
l.calculatedHostListingsCount = 3,
l.availability365 = 230
MERGE(h)-[:HAS_LISTINGS]->(l)

MATCH (l:Listings {listingId: 400500})
MERGE (r: Reviews {reviewId: 300500})
ON CREATE SET
r.reviewerId = 1000500,
r.date = Date("2019-10-22"),
r.reviewerName = "Garry",
r.reviewScoresRating = 96,
r.comments = "Great location, view, master bedroom, robe, ensuite and hospitality. Looking forward to staying there again sometime."
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

MATCH (l:Listings {listingId: 400500})
MERGE (r: Reviews {reviewId: 300501})
ON CREATE SET
r.reviewerId = 1000545,
r.date = Date("2019-09-20"),
r.reviewerName = "Laurie",
r.reviewScoresRating = 85,
r.comments = "A truly top-notch Airbnb host and superb facilities, King Size bed, massive ensuite, central to Southbank, Crown Casino and CBD just a 5-minute walk or get the tram just a 100 metres away. What more could you ask for Highly recommended "
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

//1b

MERGE (h: Hosts { hostId: 1900401})
ON CREATE SET
h.hostUrl = "https://www.airbnb.com.au/users/show/80621455",
h.hostName = "Bill Donghang",
h.hostVerifications = ["government_id", "selfie", "email", "phone"],
h.hostLocation = "Melbourne, Victoria, Australia",
h.hostResponseTime = "within a day",
h.hostIsSuperhost = false,
h.hostSince = Date("2016-11-03")
RETURN h

MATCH (h: Hosts {hostId: 1900401})
MERGE (l: Listings {listingId: 400501})
ON CREATE SET
l.name = "Holiday Apartment One Bedroom, Free Gym & Pool",
l.summary	 = "1 bedroom apartment is only 3 minutes’ walk from Southern Cross Station. There are free tram stops nearby as well as supermarket. Guests have access to an indoor heated pool, a fitness centre and unlimited free wifi. The whole apartment internal build-in 45 sqm plus 5sqm balconies. - In total 50sqm for this spacious apartment.",
l.listingUrl	= "https://www.airbnb.com.au/rooms/15537910?source_impression_id=p3_1571825185_xFHMAK%2BiJh%2FssQsn",
l.pictureUrl = "https://www.airbnb.com.au/rooms/15537910/slideshow/222379656?adults=1&children=0&infants=0",
l.neighbourhood = "Southern Cross Station",
l.street = "Melbourne, Victoria, Australia",
l.zipcode = 3000,
l.latitude = -37.8184,
l.longitude = 144.9525,
l.roomType = "Entire home",
l.amenities	 = ["Wi-Fi", "Kitchen", "Gym", "Pool"],
l.extraPeople = 0,
l.price = 81,
l.minimumNights = 2,
l.calculatedHostListingsCount = 32,
l.availability365 = 215
MERGE(h)-[:HAS_LISTINGS]->(l)

MATCH (l:Listings {listingId: 400501})
MERGE (r: Reviews {reviewId: 300503})
ON CREATE SET
r.reviewerId = 1000504,
r.date = Date("2017-10-01"),
r.reviewerName = "Wassaporn",
r.reviewScoresRating = 75,
r.comments = "Bill's place is great. Clean and modern. Good location."
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

MATCH (l:Listings {listingId: 400501})
MERGE (r: Reviews {reviewId: 300504})
ON CREATE SET
r.reviewerId = 1000540,
r.date = Date("2019-06-20"),
r.reviewerName = "David",
r.reviewScoresRating = 55,
r.comments = "Great apartment and it's close to southern Cross and everything else."
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

//1c

MERGE (h: Hosts { hostId: 1900402})
ON CREATE SET
h.hostUrl = "https://www.airbnb.com.au/users/show/80621455",
h.hostName = "Hadi",
h.hostVerifications = ["government_id", "email", "phone"],
h.hostLocation = "Melbourne, Victoria, Australia",
h.hostResponseTime = "within a day",
h.hostIsSuperhost = false,
h.hostSince = Date("2016-01-03")
RETURN h

MATCH (h: Hosts {hostId: 1900402})
MERGE (l: Listings {listingId: 400502})
ON CREATE SET
l.name = "Cityview Master Bedroom in The Green Abode",
l.summary	 = "This is a private room listing where your host will be staying with you. The unit has 2 bedrooms (a guest bedroom and a host bedroom), a joined kitchen space + living room + dining, one bathroom, and a balcony with an awesome view of the city. Due to the unit facing East, it receives plenty of morning sunlight, especially during summer. This space is complete with entertainment features such as Netflix and unlimited NBN Wifi.",
l.listingUrl	= "https://www.airbnb.com.au/rooms/17465305?source_impression_id=p3_1571826079_0UD71yEWW7ftC0cq",
l.pictureUrl = "https://www.airbnb.com.au/rooms/15537910/slideshow/222379656?adults=1&children=0&infants=0",
l.neighbourhood = "CBD",
l.street = "Melbourne, Victoria, Australia",
l.zipcode = 3000,
l.latitude = -37.8136,
l.longitude = 144.9631,
l.roomType = "Private room",
l.amenities	 = ["Wi-Fi", "Kitchen", "Gym", "Lift"],
l.extraPeople = 2,
l.price = 50,
l.minimumNights = 2,
l.calculatedHostListingsCount = 1,
l.availability365 = 60
MERGE(h)-[:HAS_LISTINGS]->(l)

MATCH (l:Listings {listingId: 400502})
MERGE (r: Reviews {reviewId: 300507})
ON CREATE SET
r.reviewerId = 1000509,
r.date = Date("2019-07-01"),
r.reviewerName = "Joel",
r.reviewScoresRating = 90,
r.comments = "Very clean place and supe close to everything. So much great food and bars around."
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

MATCH (l:Listings {listingId: 400502})
MERGE (r: Reviews {reviewId: 300508})
ON CREATE SET
r.reviewerId = 1000550,
r.date = Date("2019-06-01"),
r.reviewerName = "Elliott",
r.reviewScoresRating = 76,
r.comments = "Had a really nice stay at Hadi’s place, great location, sparkling cleaning. Also Hadi is really helpful."
MERGE (r)-[:HAS_REVIEWED]->(l)
return r, l

//2

MATCH(a:Hosts) where a.hostSince.year = 2009
SET a.hostVerifications = a.hostVerifications + ["Facebook"]
return a AS Hosts

//3

MATCH (a:Hosts {hostResponseTime: "within an hour"})
SET a.hostIsSuperhost = true

//4

MATCH (a:Hosts)--(b:Listings)--(c:Reviews)
WITH a, max(c.date) AS lastReviewDate
WHERE NOT lastReviewDate.year > 2016
SET a.active = false
RETURN a.hostName AS Hosts

//5

MATCH (a:Listings) WHERE NOT (a)-[:HAS_REVIEWED]-() AND a.availability365 = 0 
DETACH DELETE a