From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 17/18] md: be extra careful not to take a reference to a
 Faulty device.
Date: Thu, 02 Jun 2016 16:19:53 +1000
Message-ID: <20160602061952.2939.5666.stgit@noble>
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

It is important that we never increment rdev->nr_pending on a Faulty
device as ->hot_remove_disk() assumes that once the Faulty flag is visible
no code will take a new reference.

Some places take a new reference after only check In_sync.  This should
be safe as the two are changed together.  However to make the code more
obviously safe, add checks for 'Faulty' as well.

Note: the actual rule is:
  Never increment nr_pending if  Faulty is set and Blocked is clear,
  never clear Faulty, and never set Blocked without holding a reference
  through nr_pending.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/multipath.c |    3 ++-
 drivers/md/raid10.c    |    6 ++++++
 drivers/md/raid5.c     |    3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 69244de2036b..7eb9972a37e6 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -43,7 +43,8 @@ static int multipath_map (struct mpconf *conf)
 	rcu_read_lock();
 	for (i = 0; i < disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		if (rdev && test_bit(In_sync, &rdev->flags)) {
+		if (rdev && test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
 			return i;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5d40612d6219..78016667ec00 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2289,6 +2289,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
 			    test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
 			    is_badblock(rdev, r10_bio->devs[sl].addr + sect, s,
 					&first_bad, &bad_sectors) == 0) {
 				atomic_inc(&rdev->nr_pending);
@@ -2341,6 +2342,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (!rdev ||
+			    test_bit(Faulty, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
 				continue;
 
@@ -2380,6 +2382,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (!rdev ||
+			    test_bit(Faulty, &rdev->flags))
 			    !test_bit(In_sync, &rdev->flags))
 				continue;
 
@@ -2948,6 +2951,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			mreplace = rcu_dereference(mirror->replacement);
 
 			if ((mrdev == NULL ||
+			     test_bit(Faulty, &mrdev->flags) ||
 			     test_bit(In_sync, &mrdev->flags))) {
 				rcu_read_unlock();
 				continue;
@@ -2964,6 +2968,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				rcu_read_unlock();
 				continue;
 			}
+			if (mreplace && test_bit(Faulty, &mreplace->flags))
+				mreplace = NULL;
 			/* Unless we are doing a full sync, or a replacement
 			 * we only need to recover the block if it is set in
 			 * the bitmap
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e9beba258f4f..94c180f16294 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3080,7 +3080,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct md_rdev *rdev;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->disks[i].rdev);
-			if (rdev && test_bit(In_sync, &rdev->flags))
+			if (rdev && test_bit(In_sync, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags))
 				atomic_inc(&rdev->nr_pending);
 			else
 				rdev = NULL;


