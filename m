From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/24] md: allow array to be resized while bitmap is
 present.
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.27811.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that bitmaps can be resized, we can allow an array to be resized
while the bitmap is present.

This only covers resizing that involves changing the effective size
of member devices, not resizing that changes the number of devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c     |    6 +-----
 drivers/md/raid1.c  |   11 +++++++++--
 drivers/md/raid10.c |   10 ++++++++--
 drivers/md/raid5.c  |   14 ++++++++++----
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9524192..b8f9c8e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6153,11 +6153,7 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
-	if (mddev->bitmap)
-		/* Sorry, cannot grow a bitmap yet, just remove it,
-		 * grow, and re-add.
-		 */
-		return -EBUSY;
+
 	rdev_for_each(rdev, mddev) {
 		sector_t avail = rdev->sectors;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 22cfc66..8e717bd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2752,9 +2752,16 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
-	md_set_array_sectors(mddev, raid1_size(mddev, sectors, 0));
-	if (mddev->array_sectors > raid1_size(mddev, sectors, 0))
+	sector_t newsize = raid1_size(mddev, sectors, 0);
+	if (mddev->external_size &&
+	    mddev->array_sectors > newsize)
 		return -EINVAL;
+	if (mddev->bitmap) {
+		int ret = bitmap_resize(mddev->bitmap, newsize, 0, 0);
+		if (ret)
+			return ret;
+	}
+	md_set_array_sectors(mddev, newsize);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 728fcab..cd64c89 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3666,9 +3666,15 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 
 	oldsize = raid10_size(mddev, 0, 0);
 	size = raid10_size(mddev, sectors, 0);
-	md_set_array_sectors(mddev, size);
-	if (mddev->array_sectors > size)
+	if (mddev->external_size &&
+	    mddev->array_sectors > size)
 		return -EINVAL;
+	if (mddev->bitmap) {
+		int ret = bitmap_resize(mddev->bitmap, size, 0, 0);
+		if (ret)
+			return ret;
+	}
+	md_set_array_sectors(mddev, size);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7bfd59b..eab6168 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5503,12 +5503,18 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	 * any io in the removed space completes, but it hardly seems
 	 * worth it.
 	 */
+	sector_t newsize;
 	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
-	md_set_array_sectors(mddev, raid5_size(mddev, sectors,
-					       mddev->raid_disks));
-	if (mddev->array_sectors >
-	    raid5_size(mddev, sectors, mddev->raid_disks))
+	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
+	if (mddev->external_size &&
+	    mddev->array_sectors > newsize)
 		return -EINVAL;
+	if (mddev->bitmap) {
+		int ret = bitmap_resize(mddev->bitmap, sectors, 0, 0);
+		if (ret)
+			return ret;
+	}
+	md_set_array_sectors(mddev, newsize);
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&


