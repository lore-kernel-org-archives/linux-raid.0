From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 5] Make read retry use a new bio in raid1 and raid10
Date: Wed, 20 Oct 2004 13:26:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1CK77F-0008IK-1I@notabene.cse.unsw.edu.au>
References: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When retrying a read request, we need to "Reset" the bio.
It is easiest to get this right if we discard the bio we have
and re-clone it.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c  |    6 +++++-
 ./drivers/md/raid10.c |   13 ++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-10-20 13:21:25.000000000 +1000
+++ ./drivers/md/raid1.c	2004-10-20 13:21:25.000000000 +1000
@@ -943,6 +943,8 @@ static void raid1d(mddev_t *mddev)
 			} else {
 				r1_bio->bios[r1_bio->read_disk] = NULL;
 				r1_bio->read_disk = disk;
+				bio_put(bio);
+				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 				r1_bio->bios[r1_bio->read_disk] = bio;
 				rdev = conf->mirrors[disk].rdev;
 				if (printk_ratelimit())
@@ -950,9 +952,11 @@ static void raid1d(mddev_t *mddev)
 					       " another mirror\n",
 					       bdevname(rdev->bdev,b),
 					       (unsigned long long)r1_bio->sector);
-				bio->bi_bdev = rdev->bdev;
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
+				bio->bi_bdev = rdev->bdev;
+				bio->bi_end_io = raid1_end_read_request;
 				bio->bi_rw = READ;
+				bio->bi_private = r1_bio;
 				unplug = 1;
 				generic_make_request(bio);
 			}

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-10-20 13:21:25.000000000 +1000
+++ ./drivers/md/raid10.c	2004-10-20 13:21:25.000000000 +1000
@@ -1237,8 +1237,8 @@ static void raid10d(mddev_t *mddev)
 			int mirror;
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio = NULL;
+			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
-			r10_bio->devs[r10_bio->read_slot].bio = bio;
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
@@ -1252,15 +1252,14 @@ static void raid10d(mddev_t *mddev)
 					       " another mirror\n",
 					       bdevname(rdev->bdev,b),
 					       (unsigned long long)r10_bio->sector);
-				bio->bi_bdev = rdev->bdev;
+				bio = bio_clone(r10_bio->master_bio, GFP_NOIO);
+				r10_bio->devs[r10_bio->read_slot].bio = bio;
 				bio->bi_sector = r10_bio->devs[r10_bio->read_slot].addr
 					+ rdev->data_offset;
-				bio->bi_next = NULL;
-				bio->bi_flags &= (1<<BIO_CLONED);
-				bio->bi_flags |= 1 << BIO_UPTODATE;
-				bio->bi_idx = 0;
-				bio->bi_size = r10_bio->sectors << 9;
+				bio->bi_bdev = rdev->bdev;
 				bio->bi_rw = READ;
+				bio->bi_private = r10_bio;
+				bio->bi_end_io = raid10_end_read_request;
 				unplug = 1;
 				generic_make_request(bio);
 			}
