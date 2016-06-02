From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 06/18] md/raid10: add rcu protection to rdev access
 during reshape.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.22226.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mirrors[].rdev can become NULL at any point unless:
   - a counted reference is held
   - ->reconfig_mutex is held, or
   - rcu_read_lock() is held

Reshape isn't always suitably careful as in the past rdev couldn't be
removed during reshape.  It can now, so add protection.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f6f21a253926..588cf6544f07 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4352,15 +4352,16 @@ read_more:
 	blist = read_bio;
 	read_bio->bi_next = NULL;
 
+	rcu_read_lock();
 	for (s = 0; s < conf->copies*2; s++) {
 		struct bio *b;
 		int d = r10_bio->devs[s/2].devnum;
 		struct md_rdev *rdev2;
 		if (s&1) {
-			rdev2 = conf->mirrors[d].replacement;
+			rdev2 = rcu_dereference(conf->mirrors[d].replacement);
 			b = r10_bio->devs[s/2].repl_bio;
 		} else {
-			rdev2 = conf->mirrors[d].rdev;
+			rdev2 = rcu_dereference(conf->mirrors[d].rdev);
 			b = r10_bio->devs[s/2].bio;
 		}
 		if (!rdev2 || test_bit(Faulty, &rdev2->flags))
@@ -4405,6 +4406,7 @@ read_more:
 		nr_sectors += len >> 9;
 	}
 bio_full:
+	rcu_read_unlock();
 	r10_bio->sectors = nr_sectors;
 
 	/* Now submit the read */
@@ -4456,16 +4458,20 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		struct bio *b;
 		int d = r10_bio->devs[s/2].devnum;
 		struct md_rdev *rdev;
+		rcu_read_lock();
 		if (s&1) {
-			rdev = conf->mirrors[d].replacement;
+			rdev = rcu_dereference(conf->mirrors[d].replacement);
 			b = r10_bio->devs[s/2].repl_bio;
 		} else {
-			rdev = conf->mirrors[d].rdev;
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			b = r10_bio->devs[s/2].bio;
 		}
-		if (!rdev || test_bit(Faulty, &rdev->flags))
+		if (!rdev || test_bit(Faulty, &rdev->flags)) {
+			rcu_read_unlock();
 			continue;
+		}
 		atomic_inc(&rdev->nr_pending);
+		rcu_read_unlock();
 		md_sync_acct(b->bi_bdev, r10_bio->sectors);
 		atomic_inc(&r10_bio->remaining);
 		b->bi_next = NULL;
@@ -4526,9 +4532,10 @@ static int handle_reshape_read_error(struct mddev *mddev,
 		if (s > (PAGE_SIZE >> 9))
 			s = PAGE_SIZE >> 9;
 
+		rcu_read_lock();
 		while (!success) {
 			int d = r10b->devs[slot].devnum;
-			struct md_rdev *rdev = conf->mirrors[d].rdev;
+			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 			sector_t addr;
 			if (rdev == NULL ||
 			    test_bit(Faulty, &rdev->flags) ||
@@ -4536,11 +4543,15 @@ static int handle_reshape_read_error(struct mddev *mddev,
 				goto failed;
 
 			addr = r10b->devs[slot].addr + idx * PAGE_SIZE;
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
 			success = sync_page_io(rdev,
 					       addr,
 					       s << 9,
 					       bvec[idx].bv_page,
 					       READ, false);
+			rdev_dec_pending(rdev, mddev);
+			rcu_read_lock();
 			if (success)
 				break;
 		failed:
@@ -4550,6 +4561,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			if (slot == first_slot)
 				break;
 		}
+		rcu_read_unlock();
 		if (!success) {
 			/* couldn't read this block, must give up */
 			set_bit(MD_RECOVERY_INTR,
@@ -4619,16 +4631,18 @@ static void raid10_finish_reshape(struct mddev *mddev)
 		}
 	} else {
 		int d;
+		rcu_read_lock();
 		for (d = conf->geo.raid_disks ;
 		     d < conf->geo.raid_disks - mddev->delta_disks;
 		     d++) {
-			struct md_rdev *rdev = conf->mirrors[d].rdev;
+			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev)
 				clear_bit(In_sync, &rdev->flags);
-			rdev = conf->mirrors[d].replacement;
+			rdev = rcu_dereference(conf->mirrors[d].replacement);
 			if (rdev)
 				clear_bit(In_sync, &rdev->flags);
 		}
+		rcu_read_unlock();
 	}
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = 1 << conf->geo.chunk_shift;


