From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 14 - Fix simple off-by-one error in md driver.
Date: Tue, 27 May 2003 13:01:13 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUi9-0003Gu-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-05-27 11:58:21.000000000 +1000
+++ ./drivers/md/raid5.c	2003-05-27 11:58:22.000000000 +1000
@@ -1476,7 +1476,7 @@ static int run (mddev_t *mddev)
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		raid_disk = rdev->raid_disk;
-		if (raid_disk > mddev->raid_disks
+		if (raid_disk >= mddev->raid_disks
 		    || raid_disk < 0)
 			continue;
 		disk = conf->disks + raid_disk;
