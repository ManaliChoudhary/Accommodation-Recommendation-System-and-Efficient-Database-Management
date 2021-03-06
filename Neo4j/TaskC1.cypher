//import
//HOST

LOAD CSV WITH HEADERS FROM "file:///host_v2.csv"
AS host
WITH host WHERE host.host_id IS NOT NULL
MERGE (h:Hosts {hostId: host.host_id})
ON CREATE SET h.hostUrl = host.host_url,
 h.hostName = host.host_name,
 h.hostVerifications = host.host_verifications,
 h.hostSince = host.host_since,
 h.hostLocation = host.host_location,
 h.hostResponseTime = host.host_response_time,
 h.hostIsSuperhost = host.host_is_superhost
RETURN h

MATCH (h:Hosts)
SET h.hostVerifications = replace(h.hostVerifications, "[", ""),
	h.hostVerifications = replace(h.hostVerifications, "]", ""),
	h.hostVerifications = replace(h.hostVerifications, " ", ""),
	h.hostVerifications = replace(h.hostVerifications, "'", ""),
	h.hostVerifications = split(h.hostVerifications, ","),
	h.hostIsSuperhost = (case h.hostIsSuperhost when 'f' then false else true end),
	h.hostSince = Date(h.hostSince),
	h.hostId = toInt(h.hostId)
RETURN h

//LISTING

LOAD CSV WITH HEADERS FROM "file:///listing_v2.csv"
AS listing
WITH listing WHERE listing.id IS NOT NULL
MERGE (l:Listings {id: listing.id})
ON CREATE SET l.name = listing.name,
 l.summary	 = listing.summary,
 l.listingUrl	=listing.listing_url,
 l.pictureUrl=listing.picture_url,
 l.hostId = listing.host_id,
 l.neighbourhood = listing.neighbourhood,
 l.street = listing.street,
 l.zipcode = listing.zipcode,
 l.latitude = listing.latitude,
 l.longitude = listing.longitude, 
 l.roomType = listing.room_type,
 l.amenities = listing.amenities,
 l.price = listing.price,
 l.extraPeople = listing.extra_people,
 l.minimumNights = listing.minimum_nights,
 l.calculatedHostListingsCount = listing.calculated_host_listings_count,
 l.availability365 = listing.availability_365
 RETURN l
 
MATCH (h:Hosts),(l:Listings)
where h.hostId=toInt(l.hostId)
CREATE (h)-[:HAS_LISTINGS]->(l)
SET l.id = toInt(l.id),
	l.hostId = toInt(l.hostId),
	l.extraPeople = replace(l.extraPeople,"$",""),
	l.extraPeople = replace(l.extraPeople," ",""),
	l.extraPeople = toInt(l.extraPeople),
	l.amenities = replace(l.amenities, "{", ""),
	l.amenities = replace(l.amenities, "}", ""),
	l.amenities = replace(l.amenities, '"', ""),
	l.amenities = split(l.amenities, ","),
	l.zipcode = toInt(l.zipcode),
	l.price = toFloat(l.price),
	l.availability365 = toInt(l.availability365),
	l.minimumNights = toInt(l.minimumNights),
	l.latitude = toFloat(l.latitude),
	l.longitude = toFloat(l.longitude),
	l.calculatedHostListingsCount = toInt(l.calculatedHostListingsCount)
RETURN l,h

//REVIEW

LOAD CSV WITH HEADERS FROM "file:///review_v2.csv"
AS review
WITH review WHERE review.id IS NOT NULL
MERGE (r: Reviews {id: review.id})
ON CREATE SET r.listingId = review.listing_id,
r.reviewerId = review.reviewer_id,
r.date = review.date,
r.reviewerName = review.reviewer_name,
r.reviewScoresRating = review.review_scores_rating,
r.comments = review.comments
RETURN r

MATCH (l:Listings),(r:Reviews)
where l.id=toInt(r.listingId)
CREATE (r)-[:HAS_REVIEWED]->(l)
SET r.id = toInt(r.id),
	r.listingId = toInt(r.listingId),
	r.reviewerId = toInt(r.reviewerId),
	r.reviewScoresRating = toInt(r.reviewScoresRating),
	r.date = Date(r.date)
RETURN r,l

//Explanation on Graph Design:
//As required by MonashBnB and the given data, 3 nodes are mapped named- Hosts, Listings, Reviews. 
//The nodes are connected by directed edges. Hosts and Listings share edge named - HAS_LISTINGS and Listings and Reviews with the edge - HAS_REVIEWED. The properties - hostId of Hosts, id of Listings and id of Reviews nodes are constrained with NOT NULL and are unique. 
//The nodes are related to each other by ids of Host-Listing-Review. This mapping of nodes and edges together forms the Graph database of MonashBNB.