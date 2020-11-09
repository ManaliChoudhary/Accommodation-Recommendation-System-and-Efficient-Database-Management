//1

MATCH (a: Reviews)--(b:Listings)
WHERE b.name CONTAINS ("Sunny 1950s Apartment, St Kilda East")
RETURN count (a)

//2

MATCH (a:Reviews)--(b:Listings{neighbourhood:"Port Phillip"})
RETURN a

//3

MATCH (a:Listings)--(b:Reviews) WHERE NOT b.reviewerId = 4162110 AND b.reviewerId = 317848 AND b.reviewScoresRating > 90
RETURN a.name AS Accomodation

//4

MATCH (a:Listings) WHERE NOT "Wifi" IN a.amenities
RETURN a.name ,a.street, a.neighbourhood

//5

MATCH (a: Reviews)
RETURN a.reviewerId AS Reviewer, count(a.reviewerId) AS Count

//6

MATCH(a1:Listings),(a2:Listings) WHERE
length(filter(x in a1.amenities where x in a2.amenities))>3 and NOT a1.name=a2.name
RETURN a1.name AS Accomodation_1,a2.name AS Accomodation_2

//7

MATCH (a:Listings) WHERE NOT (a)-[:HAS_REVIEWED]-() RETURN a

//8

MATCH (a:Listings)-[r:HAS_LISTINGS]-(b:Hosts) WITH b,COUNT(r) AS Count,
COLLECT({listName:a.name,listPrice:a.price}) AS Lists 
WHERE Count >1 
RETURN b AS Host,Lists,Count
 

//9

MATCH (a: Listings {neighbourhood: "Melbourne"})
RETURN avg(a.price)

//10

MATCH (a: Listings)--(b: Hosts)
WITH a.price AS price, a.name AS Name, COLLECT(b) AS Host, 
COLLECT ( {location: a.street} ) AS Location
RETURN Location, Host, Name
ORDER BY price DESC
LIMIT 5

//11

MATCH (a:Listings)--(b:Reviews) WHERE b.date.year = 2017 RETURN count(b) AS Accomodations_in_2017

//12

MATCH (a: Listings)--(b: Reviews)
RETURN a.neighbourhood AS Neighbourhood, avg(b.reviewScoresRating) AS AverageReviewScoresRating
ORDER BY AverageReviewScoresRating DESC
LIMIT 10

//13

MATCH (a: Hosts)--(b: Listings)
WHERE NOT a.hostLocation = b.street
RETURN a.hostName AS Host_Name, a.hostLocation AS Host_Location, b.name AS Listing_Name, b.street AS Listing_Location

//14

MATCH (a: Listings)
WITH a.name AS Accomodation, collect ( {location: a.street} ) AS Location, 
a.price AS pricePerNight, a.extraPeople AS extraPeople
RETURN Accomodation, Location, extraPeople AS ExtraPeopleCharge, 5 * (pricePerNight + (2 * extraPeople)) AS TotalPrice, pricePerNight AS PricePerNight
ORDER BY TotalPrice

//15

MATCH (a1:Listings),(a2:Listings) 	
WHERE NOT a1.id = a2.id
WITH a1,a2,point({latitude:a1.latitude,longitude:a1.longitude}) AS p1,
point({latitude:a2.latitude,longitude:a2.longitude}) AS p2, COLLECT(a2.name) AS Lists
RETURN  a1.name AS List,Lists,distance(p1,p2) AS distance
ORDER BY List,distance 

//EXTRA 5 QUERIES

//1.
//Display the Accomodations , all ratings which are not 0, and the count of ratings for all the listings 
//which are in the neighbourhood Monash or Frankston.

WITH ['Monash','Frankston'] AS location
MATCH (a:Listings)--(b:Reviews)
WHERE a.neighbourhood in location AND b.reviewScoresRating >0
RETURN a.name AS Accomodation,collect(b.reviewScoresRating) AS Ratings,count(b.reviewScoresRating) AS Ratings_Count

//2.
//Display the hosts who are superhosts, completed more than 5 years and also have submitted government ids for verification.

MATCH (a:Hosts)
UNWIND a.hostVerifications AS verification
WITH a,date() as currentDate,a.hostSince.year AS hostYear
WHERE a.hostIsSuperhost = true AND verification IN ["government_id"] AND (currentDate.year - hostYear) > 5
RETURN a.hostName AS Name, a.hostSince AS Date

//3.
//Display the unique accomodations according to the review ratings greater than 90 and having "Good" in its comments

MATCH (a:Reviews)--(b:Listings)
WITH a,b
WHERE a.reviewScoresRating > 90 AND a.comments CONTAINS ("Good")
RETURN b.neighbourhood AS Neighbourhood,collect(DISTINCT(b.name)) AS Accomodations

//4
//Display the host and his number of listings having the maximum number of listings .

MATCH (a: Hosts)-[r:HAS_LISTINGS]-(b: Listings)
WITH a,collect(b.name) AS Lists,count(r) AS Count_Of_Listings
RETURN a.hostName AS Host_Name,Count_Of_Listings
ORDER BY Count_Of_Listings DESC
LIMIT 1

//5. 
//Display the Price with their listings according to the room types who have the price below 100 and minimum stay for 1 night.

MATCH (a:Listings)
WITH a, a.price AS m
WHERE m< 100 AND a.minimumNights >1 
RETURN a.roomType AS Room_Type ,collect({Name:a.name,Price:m}) AS Accomodations
ORDER BY Room_Type

//Indices

CREATE INDEX ON: Reviews(reviewScoresRating)

CREATE INDEX ON: Hosts(hostIsSuperhost)

CREATE INDEX ON: Listings(street,price)

//Reasoning:
//Indices are created on properties which are used frequently to make their operations efficient. 
//Hence, reviewScoresRating in Reviews, hostIsSuperhost in Hosts and street,
//price in Listings are already used frequently and also are the key properties by which the data can be retrieved in future
//by MonashBnB being a travel accomodations booking company as ratings,hosts and search by street(location) and price for an accomodation are basic criterias
//for query processing .