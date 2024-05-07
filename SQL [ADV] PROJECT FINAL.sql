#                                                            ___   PROJECT ON SQL ADVANCED (IG_CLONE_DATABASE)  ___

/*
Q1.Create an ER diagram or draw a schema for the given database.
*/
# [Done]

/*
Q2.We want to reward the user who has been around the longest, Find the 5 oldest users.
*/
select * from users; #id, username, created_at
select * from photos; #id, image_url, user_id, created_at

select created_at, username from users
group by created_at, username
order by 1
limit 5;

/*
Q3.To target inactive users in an email ad campaign, find the users who have never posted a photo.
*/
select * from photos; #id, image_url, user_id, created_at
select * from users; #id, username, created_at

select * from users 
where id not in
(select distinct user_id from photos);

/*
Q4.Suppose you are running a contest to find out who got the most likes on a photo. 
Find out who won?
*/
select * from likes; #user_id, photo_id, created_at
select * from users; #id, username, created_at
select * from photos; #id, image_url, user_id, created_at

select l.photo_id, count(*) max_num_of_likes, u.username as Winner from likes as l
inner join photos as p on l.photo_id = p.id
inner join users as u on p.user_id = u.id
group by l.photo_id
order by 2 desc
limit 1;

/*
Q5.The investors want to know how many times does the average user post.
*/
select round((select count(*) from photos)/(select count(*) from users),2) as average_users_post;

/*
Q6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
*/
select * from photo_tags; #photo_id, tag_id
select * from photos; #id, image_url, user_id, created_at
select * from tags; #id, tag_name, created_at

select pt.tag_id, t.tag_name, count(*) number_of_times_used from photo_tags as pt
inner join tags as t on pt.tag_id = t.id
Group by 1
order by 1 desc
limit 5;

/*
Q7.To find out if there are bots, find users who have liked every single photo on the site.
*/

select * from likes; #user_id, photo_id, created_at
select * from photos; #id, image_url, user_id, created_at
select * from users; #id, username, created_at (the id for users is the user id)

select u.id, u.username as BOTS, like_list.tot_num_of_likes from users as u
inner join
(select u.id, count(*) as tot_num_of_likes from likes as l
inner join users as u on l.user_id = u.id
group by 1) as like_list on u.id = like_list.id
inner join photos as p on like_list.id = p.id
where like_list.tot_num_of_likes = (select max(id) from photos);

/*
 Q8.Find the users who have created instagramid in may and select top 5 newest joinees from it?
*/
select * from users; #id, username, created_at

select username, created_at from users
where month(created_at) = '05'
group by id, created_at
order by 2 desc
limit 5; 

/*
Q9.Can you help me find the users whose name starts with c and ends with any number 
   and have posted the photos as well as liked the photos?
*/
select * from likes; #user_id, photo_id, created_at
select * from photos; #id, image_url, user_id, created_at
select * from users; #id, username, created_at (the id for users is the user id)

select u.id, u.username, u.created_at, like_check.likes_count, post_check.post_count from users as u
inner join
(select p.user_id as users1, count(p.id) as likes_count from likes as l 
inner join photos as p on l.photo_id = p.id
group by 1
having p.user_id is not null) as like_check on u.id = like_check.users1

inner join
(select ph.user_id as users2, count(ph.user_id) as post_count from photos as ph 
group by 1
having ph.user_id is not null) as post_check on like_check.users1 = post_check.users2

where u.username regexp '^c.*[0-9]$'; 


/*
Q10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.
*/
select * from photos; #id, image_url, user_id, created_at
select * from users; #id, username, created_at (the id for users is the user id)

select usr.id, usr.username, max_posts.post_count from users as usr
inner join 
(select u.id, count(ph.user_id) as post_count from photos as ph 
inner join users as u on ph.user_id = u.id
group by 1
having u.id is not null
order by 2 desc) as max_posts on usr.id = max_posts.id
where max_posts.post_count BETWEEN 3 AND 5
limit 30;

#___________________________________________________DONE______________________________________________________








