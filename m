From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 6 - Improve test for which raid1 device doesn't need to be written to.
Date: Thu, 08 May 2003 11:39:43 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19DaNr-0004ue-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Instead of testing last_used (which could change in unusual circumstances) we 
test against the bdev that we read from, and don't write back to there.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-05-02 13:26:51.000000000 +1000
+++ ./drivers/md/raid1.c	2003-05-02 16:40:54.000000000 +1000
@@ -825,7 +825,7 @@ static void sync_request_write(mddev_t *
 		if (!conf->mirrors[i].rdev || 
 		    conf->mirrors[i].rdev->faulty)
 			continue;
-		if (i == conf->last_used)
+		if (conf->mirrors[i].rdev->bdev == bio->bi_bdev)
 			/*
 			 * we read from here, no need to write
 			 */
