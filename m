From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 017 of 18] Handle errors when read-only
Date: Mon, 28 Nov 2005 10:41:04 +1100
Message-ID: <1051127234104.14937@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c         |   18 +++++++++++-------
 ./include/linux/raid/raid1.h |    7 +++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:13:27.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:13:32.000000000 +1100
@@ -154,7 +154,7 @@ static void put_all_bios(conf_t *conf, r
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct bio **bio = r1_bio->bios + i;
-		if (*bio)
+		if (*bio && *bio != IO_BLOCKED)
 			bio_put(*bio);
 		*bio = NULL;
 	}
@@ -418,11 +418,13 @@ static int read_balance(conf_t *conf, r1
 		new_disk = 0;
 
 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
+		     r1_bio->bios[new_disk] == IO_BLOCKED ||
 		     !rdev || !test_bit(In_sync, &rdev->flags)
 			     || test_bit(WriteMostly, &rdev->flags);
 		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
 
-			if (rdev && test_bit(In_sync, &rdev->flags))
+			if (rdev && test_bit(In_sync, &rdev->flags) &&
+				r1_bio->bios[new_disk] != IO_BLOCKED)
 				wonly_disk = new_disk;
 
 			if (new_disk == conf->raid_disks - 1) {
@@ -436,11 +438,13 @@ static int read_balance(conf_t *conf, r1
 
 	/* make sure the disk is operational */
 	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
+	     r1_bio->bios[new_disk] == IO_BLOCKED ||
 	     !rdev || !test_bit(In_sync, &rdev->flags) ||
 		     test_bit(WriteMostly, &rdev->flags);
 	     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
 
-		if (rdev && test_bit(In_sync, &rdev->flags))
+		if (rdev && test_bit(In_sync, &rdev->flags) &&
+		    r1_bio->bios[new_disk] != IO_BLOCKED)
 			wonly_disk = new_disk;
 
 		if (new_disk <= 0)
@@ -477,7 +481,7 @@ static int read_balance(conf_t *conf, r1
 
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 
-		if (!rdev ||
+		if (!rdev || r1_bio->bios[disk] == IO_BLOCKED ||
 		    !test_bit(In_sync, &rdev->flags) ||
 		    test_bit(WriteMostly, &rdev->flags))
 			continue;
@@ -1334,7 +1338,7 @@ static void raid1d(mddev_t *mddev)
 			sector_t sect = r1_bio->sector;
 			int sectors = r1_bio->sectors;
 			freeze_array(conf);
-			while(sectors) {
+			if (mddev->ro == 0) while(sectors) {
 				int s = sectors;
 				int d = r1_bio->read_disk;
 				int success = 0;
@@ -1387,7 +1391,6 @@ static void raid1d(mddev_t *mddev)
 				sect += s;
 			}
 
-
 			unfreeze_array(conf);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
@@ -1398,7 +1401,8 @@ static void raid1d(mddev_t *mddev)
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
-				r1_bio->bios[r1_bio->read_disk] = NULL;
+				r1_bio->bios[r1_bio->read_disk] =
+					mddev->ro ? IO_BLOCKED : NULL;
 				r1_bio->read_disk = disk;
 				bio_put(bio);
 				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-11-28 10:13:11.000000000 +1100
+++ ./include/linux/raid/raid1.h	2005-11-28 10:13:32.000000000 +1100
@@ -109,6 +109,13 @@ struct r1bio_s {
 	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloced*/
 };
 
+/* when we get a read error on a read-only array, we redirect to another
+ * device without failing the first device, or trying to over-write to
+ * correct the read error.  To keep track of bad blocks on a per-bio
+ * level, we store IO_BLOCKED in the appropriate 'bios' pointer
+ */
+#define IO_BLOCKED ((struct bio*)1)
+
 /* bits for r1bio.state */
 #define	R1BIO_Uptodate	0
 #define	R1BIO_IsSync	1
