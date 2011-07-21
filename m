From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 27/34] md/raid10: Improve decision on whether to fail a
 device with a read error.
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.78076.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Normally we would fail a device with a READ error.  However if doing
so causes the array to fail, it is better to leave the device
in place and just return the read error to the caller.

The current test for decide if the array will fail is overly
simplistic.
We have a function 'enough' which can tell if the array is failed or
not, so use it to guide the decision.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   57 +++++++++++++++++++++++++--------------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5583201..6721cb0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -970,6 +970,30 @@ static void status(struct seq_file *seq, mddev_t *mddev)
 	seq_printf(seq, "]");
 }
 
+/* check if there are enough drives for
+ * every block to appear on atleast one.
+ * Don't consider the device numbered 'ignore'
+ * as we might be about to remove it.
+ */
+static int enough(conf_t *conf, int ignore)
+{
+	int first = 0;
+
+	do {
+		int n = conf->copies;
+		int cnt = 0;
+		while (n--) {
+			if (conf->mirrors[first].rdev &&
+			    first != ignore)
+				cnt++;
+			first = (first+1) % conf->raid_disks;
+		}
+		if (cnt == 0)
+			return 0;
+	} while (first != 0);
+	return 1;
+}
+
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -982,13 +1006,9 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 	 * else mark the drive as failed
 	 */
 	if (test_bit(In_sync, &rdev->flags)
-	    && conf->raid_disks-mddev->degraded == 1)
+	    && !enough(conf, rdev->raid_disk))
 		/*
 		 * Don't fail the drive, just return an IO error.
-		 * The test should really be more sophisticated than
-		 * "working_disks == 1", but it isn't critical, and
-		 * can wait until we do more sophisticated "is the drive
-		 * really dead" tests...
 		 */
 		return;
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
@@ -1043,27 +1063,6 @@ static void close_sync(conf_t *conf)
 	conf->r10buf_pool = NULL;
 }
 
-/* check if there are enough drives for
- * every block to appear on atleast one
- */
-static int enough(conf_t *conf)
-{
-	int first = 0;
-
-	do {
-		int n = conf->copies;
-		int cnt = 0;
-		while (n--) {
-			if (conf->mirrors[first].rdev)
-				cnt++;
-			first = (first+1) % conf->raid_disks;
-		}
-		if (cnt == 0)
-			return 0;
-	} while (first != 0);
-	return 1;
-}
-
 static int raid10_spare_active(mddev_t *mddev)
 {
 	int i;
@@ -1107,7 +1106,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 		 * very different from resync
 		 */
 		return -EBUSY;
-	if (!enough(conf))
+	if (!enough(conf, -1))
 		return -EINVAL;
 
 	if (rdev->raid_disk >= 0)
@@ -1173,7 +1172,7 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
 		    mddev->recovery_disabled != p->recovery_disabled &&
-		    enough(conf)) {
+		    enough(conf, -1)) {
 			err = -EBUSY;
 			goto abort;
 		}
@@ -2286,7 +2285,7 @@ static int run(mddev_t *mddev)
 		disk->head_position = 0;
 	}
 	/* need to check that every block has at least one working mirror */
-	if (!enough(conf)) {
+	if (!enough(conf, -1)) {
 		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",
 		       mdname(mddev));
 		goto out_free_conf;


