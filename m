From: NeilBrown <neilb@suse.de>
Subject: [PATCH 18/18] md/raid5: allow layout/chunksize to be changed on an
	active2-drive raid5.
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.40440.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2-drive raid5's aren't very interesting.  But if you are converting
a raid1 into a raid5, you will at least temporarily have one.  And
that it a good time to set the layout/chunksize for the new RAID5
if you aren't happy with the defaults.

layout and chunksize don't actually affect the placement of data
on a 2-drive raid5, so we just do some internal book-keeping.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |   31 +++++++++++++++++++++----------
 drivers/md/raid5.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bd003d7..6fc07fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2727,12 +2727,19 @@ layout_store(mddev_t *mddev, const char *buf, size_t len)
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
-	if (mddev->pers)
-		return -EBUSY;
-	if (mddev->reshape_position != MaxSector)
-		mddev->new_layout = n;
-	else
-		mddev->layout = n;
+	if (mddev->pers) {
+		int err;
+		if (mddev->pers->reconfig == NULL)
+			return -EBUSY;
+		err = mddev->pers->reconfig(mddev, n, -1);
+		if (err)
+			return err;
+	} else {
+		if (mddev->reshape_position != MaxSector)
+			mddev->new_layout = n;
+		else
+			mddev->layout = n;
+	}
 	return len;
 }
 static struct md_sysfs_entry md_layout =
@@ -2789,16 +2796,20 @@ chunk_size_show(mddev_t *mddev, char *page)
 static ssize_t
 chunk_size_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set chunk_size if array is not yet active */
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
 
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
-	if (mddev->pers)
-		return -EBUSY;
-	else if (mddev->reshape_position != MaxSector)
+	if (mddev->pers) {
+		int err;
+		if (mddev->pers->reconfig == NULL)
+			return -EBUSY;
+		err = mddev->pers->reconfig(mddev, -1, n);
+		if (err)
+			return err;
+	} else if (mddev->reshape_position != MaxSector)
 		mddev->new_chunk = n;
 	else
 		mddev->chunk_size = n;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8847c14..1546e9b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4912,6 +4912,45 @@ static void *raid5_takeover_raid1(mddev_t *mddev)
 
 }
 
+static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
+{
+	/* Currently the layout and chunk size can only be changed
+	 * for a 2-drive raid array, as in that case no data shuffling
+	 * is required.
+	 * Later we might validate these and set new_* so a reshape
+	 * can complete the change.
+	 */
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+
+	if (new_layout >= 0 && !algorithm_valid_raid5(new_layout))
+		return -EINVAL;
+	if (new_chunk > 0) {
+		if (new_chunk & (new_chunk-1))
+			/* not a power of 2 */
+			return -EINVAL;
+		if (new_chunk < PAGE_SIZE)
+			return -EINVAL;
+		if (mddev->array_sectors & ((new_chunk>>9)-1))
+			/* not factor of array size */
+			return -EINVAL;
+	}
+
+	/* They look valid */
+
+	if (mddev->raid_disks != 2)
+		return -EINVAL;
+
+	if (new_layout >= 0) {
+		conf->algorithm = new_layout;
+		mddev->layout = mddev->new_layout = new_layout;
+	}
+	if (new_chunk > 0) {
+		conf->chunk_size = new_chunk;
+		mddev->chunk_size = mddev->new_chunk = new_chunk;
+	}
+	return 0;
+}
+
 static void *raid5_takeover(mddev_t *mddev)
 {
 	/* raid5 can take over:
@@ -5032,6 +5071,7 @@ static struct mdk_personality raid5_personality =
 #endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
+	.reconfig	= raid5_reconfig,
 };
 
 static struct mdk_personality raid4_personality =


