From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Fix up handling for read error in raid1.
Date: Thu, 24 Jun 2004 14:37:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BdLyz-0001Jy-Tq@notabene.cse.unsw.edu.au>
References: <20040624143619.5067.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There is severe bit-rot in this code, which is to say that it doesn't work
at all: an io error during read will do bad things.  It should work
better with this patch.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-06-23 14:37:05.000000000 +1000
+++ ./drivers/md/raid1.c	2004-06-23 14:37:13.000000000 +1000
@@ -206,7 +206,7 @@ static int map(mddev_t *mddev, mdk_rdev_
 			*rdevp = rdev;
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
-			return 0;
+			return i;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -945,18 +945,22 @@ static void raid1d(mddev_t *mddev)
 
 		mddev = r1_bio->mddev;
 		conf = mddev_to_conf(mddev);
-		bio = r1_bio->master_bio;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			sync_request_write(mddev, r1_bio);
 			unplug = 1;
 		} else {
-			if (map(mddev, &rdev) == -1) {
+			int disk;
+			bio = r1_bio->bios[r1_bio->read_disk];
+			if ((disk=map(mddev, &rdev)) == -1) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
+				r1_bio->bios[r1_bio->read_disk] = NULL;
+				r1_bio->read_disk = disk;
+				r1_bio->bios[r1_bio->read_disk] = bio;
 				printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
 				       " another mirror\n",
 				       bdevname(rdev->bdev,b),
