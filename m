From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 008 of 20] Fix rdev->pending counts in raid1
Date: Mon, 12 Dec 2005 14:14:46 +1100
Message-ID: <1051212031446.5042@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When we do a user-requested check/repair, we lose count
of the outstanding requests...

Also make sure that when anything is written to md/sync_action,
the RECOVERY_NEEDED flag is set and the thread is woken up
so any changes take effect.



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |   11 ++++-------
 ./drivers/md/raid1.c |   10 ++++++----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 10:45:36.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 10:45:40.000000000 +1100
@@ -1826,13 +1826,10 @@ action_store(mddev_t *mddev, const char 
 			mddev->sync_thread = NULL;
 			mddev->recovery = 0;
 		}
-		return len;
-	}
-
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
+	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
-	if (cmd_match(page, "resync") || cmd_match(page, "recover"))
+	else if (cmd_match(page, "resync") || cmd_match(page, "recover"))
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	else {
 		if (cmd_match(page, "check"))
@@ -1841,8 +1838,8 @@ action_store(mddev_t *mddev, const char 
 			return -EINVAL;
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	return len;
 }

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-12 10:45:26.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-12 10:45:40.000000000 +1100
@@ -527,7 +527,7 @@ static int read_balance(conf_t *conf, r1
 			/* cannot risk returning a device that failed
 			 * before we inc'ed nr_pending
 			 */
-			atomic_dec(&rdev->nr_pending);
+			rdev_dec_pending(rdev, conf->mddev);
 			goto retry;
 		}
 		conf->next_seq_sect = this_sector + sectors;
@@ -830,7 +830,7 @@ static int make_request(request_queue_t 
 		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			if (test_bit(Faulty, &rdev->flags)) {
-				atomic_dec(&rdev->nr_pending);
+				rdev_dec_pending(rdev, mddev);
 				r1_bio->bios[i] = NULL;
 			} else
 				r1_bio->bios[i] = bio;
@@ -1176,6 +1176,7 @@ static void sync_request_write(mddev_t *
 			if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
 			    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
 				r1_bio->bios[primary]->bi_end_io = NULL;
+				rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 				break;
 			}
 		r1_bio->read_disk = primary;
@@ -1193,9 +1194,10 @@ static void sync_request_write(mddev_t *
 						break;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
 					sbio->bi_end_io = NULL;
-				else {
+					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
+				} else {
 					/* fixup the bio for reuse */
 					sbio->bi_vcnt = vcnt;
 					sbio->bi_size = r1_bio->sectors << 9;
