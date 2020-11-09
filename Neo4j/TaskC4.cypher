//STEP1

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

LOAD CSV WITH HEADERS FROM "file:///review_v2.csv" AS review
WITH review
WHERE review.id IS NOT NULL
MATCH (l: Listings { id: toInt(review.listing_id) })
MERGE (r: Reviews {	reviewerId: toInt(review.reviewer_id),
					reviewerName: review.reviewer_name
					})
MERGE (r)-[:HAS_REVIEWED {	id: toInt(review.id),
							date: Date(review.date),
							reviewScoresRating: toFloat(review.review_scores_rating),
							comments: review.comments
							}]->(l)

//STEP2

MATCH (r1:Reviews {reviewerId: 13836558})-[a:HAS_REVIEWED]->(l:Listings)<-[b:HAS_REVIEWED]-(r2:Reviews {reviewerId:71026585 })
RETURN l.name AS listing, a.reviewScoresRating AS R1, b.reviewScoresRating AS R2


//STEP3

MATCH (r1:Reviews)-[x:HAS_REVIEWED]->(l:Listings)<-[y:HAS_REVIEWED]-(r2:Reviews)
WITH  SUM(x.reviewScoresRating * y.reviewScoresRating) AS xyDotProduct,
      SQRT(REDUCE(xDot = 0.0, a IN COLLECT(x.reviewScoresRating) | xDot + a^2)) AS xLength,
      SQRT(REDUCE(yDot = 0.0, b IN COLLECT(y.reviewScoresRating) | yDot + b^2)) AS yLength,
      r1, r2
MERGE (r1)-[s:SIMILARITY]-(r2)
SET   s.similarity = xyDotProduct / (xLength * yLength)


//STEP4

MATCH  (r1:Reviews {reviewerId:13836558})-[s:SIMILARITY]-(r2:Reviews {reviewerId:71026585})
RETURN s.similarity AS `Cosine Similarity`


//STEP5

MATCH (r1:Reviews)-[:HAS_REVIEWED]->(l:Listings)<-[:HAS_REVIEWED]-(r2:Reviews),
      (r1)-[s:SIMILARITY]-(r2)
RETURN r1, r2, l
LIMIT 3

//STEP6

MATCH    (r1:Reviews {reviewerId: 336664})-[s:SIMILARITY]-(r2:Reviews)
WHERE    s.similarity <= 1
WITH     r2, s.similarity AS s
RETURN   r2.reviewerName AS Neighbour, s AS Similarity
ORDER BY Similarity 

//STEP7

MATCH    (r1:Reviews)-[x:HAS_REVIEWED]->(l:Listings), (r1)-[s:SIMILARITY]-(r2:Reviews {reviewerId: 317848})
WHERE    NOT((r2)-[:HAS_REVIEWED]->(l))
WITH     l, s.similarity AS similarity, x.reviewScoresRating AS rating
ORDER BY l.name, similarity
WITH     l.name AS listing, COLLECT(rating)[0..3] AS ratings
WITH     listing, REDUCE(s = 0, i IN ratings | s + i) * 1.0 / SIZE(ratings) AS reco
ORDER BY reco DESC
RETURN   listing AS Listing, reco AS Recommendation

