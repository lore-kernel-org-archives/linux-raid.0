From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 18/18] md: reduce the number of synchronize_rcu() calls
 when multiple devices fail.
Date: Thu, 02 Jun 2016 16:19:53 +1000
Message-ID: <20160602061953.2939.18003.stgit@noble>
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

Every time a device is removed with ->hot_remove_disk() a synchronize_rcu() call is made
which can delay several milliseconds in some case.
If lots of devices fail at once - as could happen with a large RAID10 where one set
of devices are removed all at once - these delays can add up to be very inconcenient.

As failure is not reversible we can check for that first, setting a
separate flag if it is found, and then all synchronize_rcu() once for
all the flagged devices.  Then ->hot_remove_disk() function can skip the
synchronize_rcu() step if the flag is set.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c        |   27 +++++++++++++++++++++++++--
 drivers/md/md.h        |    5 +++++
 drivers/md/multipath.c |   14 ++++++++------
 drivers/md/raid1.c     |   17 ++++++++++-------
 drivers/md/raid10.c    |   19 +++++++++++--------
 drivers/md/raid5.c     |   15 +++++++++------
 6 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2d26099e1160..1af69d15d0df 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8186,12 +8186,31 @@ static int remove_and_add_spares(struct mddev *mddev,
 	struct md_rdev *rdev;
 	int spares = 0;
 	int removed = 0;
+	bool remove_some = false;
 
-	rdev_for_each(rdev, mddev)
+	rdev_for_each(rdev, mddev) {
 		if ((this == NULL || rdev == this) &&
 		    rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
-		    (test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Faulty, &rdev->flags) &&
+		    atomic_read(&rdev->nr_pending)==0) {
+			/* Faulty non-Blocked devices with nr_pending == 0
+			 * never get nr_pending incremented,
+			 * never get Faulty cleared, and never get Blocked set.
+			 * So we can synchronize_rcu now rather than once per device
+			 */
+			remove_some = true;
+			set_bit(RemoveSynchronized, &rdev->flags);
+		}
+	}
+
+	if (remove_some)
+		synchronize_rcu();
+	rdev_for_each(rdev, mddev) {
+		if ((this == NULL || rdev == this) &&
+		    rdev->raid_disk >= 0 &&
+		    !test_bit(Blocked, &rdev->flags) &&
+		    ((test_bit(RemoveSynchronized, &rdev->flags) ||
 		     (!test_bit(In_sync, &rdev->flags) &&
 		      !test_bit(Journal, &rdev->flags))) &&
 		    atomic_read(&rdev->nr_pending)==0) {
@@ -8202,6 +8221,10 @@ static int remove_and_add_spares(struct mddev *mddev,
 				removed++;
 			}
 		}
+		if (remove_some && test_bit(RemoveSynchronized, &rdev->flags))
+			clear_bit(RemoveSynchronized, &rdev->flags);
+	}
+
 	if (removed && mddev->kobj.sd)
 		sysfs_notify(&mddev->kobj, NULL, "degraded");
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b5c4be73e6e4..cfd883e96a38 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -163,6 +163,11 @@ enum flag_bits {
 				 * than other devices in the array
 				 */
 	ClusterRemove,
+	RemoveSynchronized,	/* synchronize_rcu() was called after
+				 * this device was known to be faulty,
+				 * so it is safe to remove without
+				 * another synchronize_rcu() call.
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7eb9972a37e6..c145a5a114eb 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -298,12 +298,14 @@ static int multipath_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			goto abort;
 		}
 		p->rdev = NULL;
-		synchronize_rcu();
-		if (atomic_read(&rdev->nr_pending)) {
-			/* lost the race, try later */
-			err = -EBUSY;
-			p->rdev = rdev;
-			goto abort;
+		if (!test_bit(RemoveSynchronized, &rdev->flags)) {
+			synchronize_rcu();
+			if (atomic_read(&rdev->nr_pending)) {
+				/* lost the race, try later */
+				err = -EBUSY;
+				p->rdev = rdev;
+				goto abort;
+			}
 		}
 		err = md_integrity_register(mddev);
 	}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0ee901ccc9c5..8b27904c4f37 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1656,13 +1656,16 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			goto abort;
 		}
 		p->rdev = NULL;
-		synchronize_rcu();
-		if (atomic_read(&rdev->nr_pending)) {
-			/* lost the race, try later */
-			err = -EBUSY;
-			p->rdev = rdev;
-			goto abort;
-		} else if (conf->mirrors[conf->raid_disks + number].rdev) {
+		if (!test_bit(RemoveSynchronized, &rdev->flags)) {
+			synchronize_rcu();
+			if (atomic_read(&rdev->nr_pending)) {
+				/* lost the race, try later */
+				err = -EBUSY;
+				p->rdev = rdev;
+				goto abort;
+			}
+		}
+		if (conf->mirrors[conf->raid_disks + number].rdev) {
 			/* We just removed a device that is being replaced.
 			 * Move down the replacement.  We drain all IO before
 			 * doing this to avoid confusion.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 78016667ec00..5e8fa7751920 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1768,7 +1768,7 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		err = -EBUSY;
 		goto abort;
 	}
-	/* Only remove faulty devices if recovery
+	/* Only remove non-faulty devices if recovery
 	 * is not possible.
 	 */
 	if (!test_bit(Faulty, &rdev->flags) &&
@@ -1780,13 +1780,16 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		goto abort;
 	}
 	*rdevp = NULL;
-	synchronize_rcu();
-	if (atomic_read(&rdev->nr_pending)) {
-		/* lost the race, try later */
-		err = -EBUSY;
-		*rdevp = rdev;
-		goto abort;
-	} else if (p->replacement) {
+	if (!test_bit(RemoveSynchronized, &rdev->flags)) {
+		synchronize_rcu();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			*rdevp = rdev;
+			goto abort;
+		}
+	}
+	if (p->replacement) {
 		/* We must have just cleared 'rdev' */
 		p->rdev = p->replacement;
 		clear_bit(Replacement, &p->replacement->flags);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 94c180f16294..4c6270e10b12 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7197,12 +7197,15 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		goto abort;
 	}
 	*rdevp = NULL;
-	synchronize_rcu();
-	if (atomic_read(&rdev->nr_pending)) {
-		/* lost the race, try later */
-		err = -EBUSY;
-		*rdevp = rdev;
-	} else if (p->replacement) {
+	if (!test_bit(RemoveSynchronized, &rdev->flags)) {
+		synchronize_rcu();
+		if (atomic_read(&rdev->nr_pending)) {
+			/* lost the race, try later */
+			err = -EBUSY;
+			*rdevp = rdev;
+		}
+	}
+	if (p->replacement) {
 		/* We must have just cleared 'rdev' */
 		p->rdev = p->replacement;
 		clear_bit(Replacement, &p->replacement->flags);


