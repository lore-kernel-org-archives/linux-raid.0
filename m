From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 8 - Make sure md_check_recovery will remove a faulty device when ->nr_pending hits 0
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002Tf-Av@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md_check_recovery only locks a device and does stuff when it thinks there
is a real likelyhood that something needs doing.
So the test at the top must cover all possibilities.

But it didn't cover the possibility that the last outstanding request on
a failed device had finished and so the device needed to be removed.

As a result, a failed drive might not get removed from the personalities
perspective on the array, and so it could never be removed from the array as
a whole.

With this patch, whenever ->nr_pending hits zero on a faulty device,
MD_RECOVERY_NEEDED is set so that md_check_recovery will do stuff.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/multipath.c    |    2 +-
 ./drivers/md/raid1.c        |    8 ++++----
 ./drivers/md/raid5.c        |    4 ++--
 ./drivers/md/raid6main.c    |    4 ++--
 ./include/linux/raid/md_k.h |    8 ++++++++
 5 files changed, 17 insertions(+), 9 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-05-28 15:47:47.000000000 +1000
+++ ./drivers/md/multipath.c	2004-05-28 15:48:33.000000000 +1000
@@ -131,7 +131,7 @@ int multipath_end_request(struct bio *bi
 		       (unsigned long long)bio->bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	}
-	atomic_dec(&rdev->nr_pending);
+	rdev_dec_pending(rdev, conf->mddev);
 	return 0;
 }
 

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./drivers/md/raid1.c	2004-05-28 15:48:33.000000000 +1000
@@ -296,7 +296,7 @@ static int raid1_end_read_request(struct
 		reschedule_retry(r1_bio);
 	}
 
-	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
+	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev); 
 	return 0;
 }
 
@@ -343,7 +343,7 @@ static int raid1_end_write_request(struc
 		raid_end_bio_io(r1_bio);
 	}
 
-	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
+	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 	return 0;
 }
 
@@ -831,7 +831,7 @@ static int end_sync_read(struct bio *bio
 			 conf->mirrors[r1_bio->read_disk].rdev);
 	else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-	atomic_dec(&conf->mirrors[r1_bio->read_disk].rdev->nr_pending);
+	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
 	reschedule_retry(r1_bio);
 	return 0;
 }
@@ -861,7 +861,7 @@ static int end_sync_write(struct bio *bi
 		md_done_sync(mddev, r1_bio->sectors, uptodate);
 		put_buf(r1_bio);
 	}
-	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
+	rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
 	return 0;
 }
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./drivers/md/raid5.c	2004-05-28 15:48:33.000000000 +1000
@@ -395,7 +395,7 @@ static int raid5_end_read_request (struc
 		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
-	atomic_dec(&conf->disks[i].rdev->nr_pending);
+	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
 	/* must restore b_page before unlocking buffer... */
 	if (sh->bh_page[i] != bh->b_page) {
@@ -438,7 +438,7 @@ static int raid5_end_write_request (stru
 	if (!uptodate)
 		md_error(conf->mddev, conf->disks[i].rdev);
 
-	atomic_dec(&conf->disks[i].rdev->nr_pending);
+	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-05-28 15:48:33.000000000 +1000
@@ -414,7 +414,7 @@ static int raid6_end_read_request (struc
 		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
-	atomic_dec(&conf->disks[i].rdev->nr_pending);
+	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 #if 0
 	/* must restore b_page before unlocking buffer... */
 	if (sh->bh_page[i] != bh->b_page) {
@@ -457,7 +457,7 @@ static int raid6_end_write_request (stru
 	if (!uptodate)
 		md_error(conf->mddev, conf->disks[i].rdev);
 
-	atomic_dec(&conf->disks[i].rdev->nr_pending);
+	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./include/linux/raid/md_k.h	2004-05-28 15:48:33.000000000 +1000
@@ -255,6 +255,14 @@ struct mddev_s
 	struct list_head		all_mddevs;
 };
 
+
+static inline void rdev_dec_pending(mdk_rdev_t *rdev, mddev_t *mddev)
+{
+	int faulty = rdev->faulty;
+	if (atomic_dec_and_test(&rdev->nr_pending) && faulty)
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+}
+
 struct mdk_personality_s
 {
 	char *name;
