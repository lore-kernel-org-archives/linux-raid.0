From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 12 of 13 - Get rid of un-necessary warning in md
Date: Thu, 22 Aug 2002 10:34:29 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvh-00050j-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet



 ----------- Diffstat output ------------
 ./drivers/md/md.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

--- ./drivers/md/md.c	2002/08/21 23:18:17	1.11
+++ ./drivers/md/md.c	2002/08/21 23:20:20	1.12
@@ -1394,10 +1394,7 @@ static int do_md_run(mddev_t * mddev)
 			printk(TOO_SMALL_CHUNKSIZE, chunk_size, PAGE_SIZE);
 			return -EINVAL;
 		}
-	} else
-		if (chunk_size)
-			printk(KERN_INFO "md: RAID level %d does not need chunksize! Continuing anyway.\n",
-			       mddev->level);
+	}
 
 	if (pnum >= MAX_PERSONALITY) {
 		MD_BUG();
