From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 4 of 27 - Remove state field from multipath mp_bh structure.
Date: Thu, 18 Jul 2002 23:32:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133231.4773@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove state field from multipath mp_bh structure. 

The MPBH_Uptodate flag is set but never used,
The MPBH_SyncPhase flag was never used.
These a both legacy from the copying of raid1.c

MPBH_PreAlloc is no longer needed as due to use of
mempools, so the state field can go...






 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   19 +------------------
 ./include/linux/raid/multipath.h |    5 -----
 2 files changed, 1 insertion(+), 23 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 11:59:52	1.4
+++ ./drivers/md/multipath.c	2002/07/18 12:00:17	1.5
@@ -130,24 +130,6 @@ void multipath_end_request(struct bio *b
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
 
-	/*
-	 * this branch is our 'one multipath IO has finished' event handler:
-	 */
-	if (!uptodate)
-		md_error (mp_bh->mddev, bio->bi_bdev);
-	else
-		/*
-		 * Set MPBH_Uptodate in our master buffer_head, so that
-		 * we will return a good error code for to the higher
-		 * levels even if IO on some other multipathed buffer fails.
-		 *
-		 * The 'master' represents the complex operation to 
-		 * user-side. So if something waits for IO, then it will
-		 * wait for the 'master' buffer_head.
-		 */
-		set_bit (MPBH_Uptodate, &mp_bh->state);
-
-		
 	if (uptodate) {
 		multipath_end_bh_io(mp_bh, uptodate);
 		return;
@@ -155,6 +137,7 @@ void multipath_end_request(struct bio *b
 	/*
 	 * oops, IO error:
 	 */
+	md_error (mp_bh->mddev, bio->bi_bdev);
 	printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
 		 bdev_partition_name(bio->bi_bdev), bio->bi_sector);
 	multipath_reschedule_retry(mp_bh);
--- ./include/linux/raid/multipath.h	2002/07/18 11:59:52	1.2
+++ ./include/linux/raid/multipath.h	2002/07/18 12:00:17	1.3
@@ -49,14 +49,9 @@ struct multipath_bh {
 					    * used from IRQ handlers
 					    */
 	int			cmd;
-	unsigned long		state;
 	mddev_t			*mddev;
 	struct bio		*master_bio;
 	struct bio		*bio;
 	struct multipath_bh	*next_mp; /* next for retry or in free list */
 };
-/* bits for multipath_bh.state */
-#define	MPBH_Uptodate	1
-#define	MPBH_SyncPhase	2
-#define	MPBH_PreAlloc	3	/* this was pre-allocated, add to free list */
 #endif
