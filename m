From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Make MD device-is-idle test check whole device, not partition.
Date: Mon, 06 Jan 2003 11:54:49 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18VLXV-0003W1-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

when resyncing an array, md will back off if it detects other
activity on the device.  This used to be based on the whole
device, not the partition, but recent changes made it only
check IO on the partition.

This patch causes all sync_io accounting to be done on the
whole device (bdev->bd_contains).


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-01-06 11:11:06.000000000 +1100
+++ ./drivers/md/md.c	2003-01-06 11:11:39.000000000 +1100
@@ -2742,7 +2742,7 @@ int unregister_md_personality(int pnum)
 
 void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors)
 {
-	rdev->bdev->bd_disk->sync_io += nr_sectors;
+	rdev->bdev->bd_contains->bd_disk->sync_io += nr_sectors;
 }
 
 static int is_mddev_idle(mddev_t *mddev)
@@ -2754,7 +2754,7 @@ static int is_mddev_idle(mddev_t *mddev)
 
 	idle = 1;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		struct gendisk *disk = rdev->bdev->bd_disk;
+		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk->read_sectors + disk->write_sectors - disk->sync_io;
 		if ((curr_events - rdev->last_events) > 32) {
 			rdev->last_events = curr_events;
