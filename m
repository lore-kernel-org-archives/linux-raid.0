From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/16] md: allow resync_start to be set while an array is
 active.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.8785.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The sysfs attribute 'resync_start' (known internally as recovery_cp),
records where a resync is up to.  A value of 0 means the array is
not known to be in-sync at all.  A value of MaxSector means the array
is believed to be fully in-sync.

When the size of member devices of an array (RAID1,RAID4/5/6) is
increased, the array can be increased to match.  This process sets
resync_start to the old end-of-device offset so that the new part of
the array gets resynced.

However with RAID1 (and RAID6) a resync is not technically necessary
and may be undesirable.  So it would be good if the implied resync
after the array is resized could be avoided.

So: change 'resync_start' so the value can be changed while the array
is active, and as a precaution only allow it to be changed while
resync/recovery is 'frozen'.  Changing it once resync has started is
not going to be useful anyway.

This allows the array to be resized without a resync by:
  write 'frozen' to 'sync_action'
  write new size to 'component_size' (this will set resync_start)
  write 'none' to 'resync_start'
  write 'idle' to 'sync_action'.

Also slightly improve some tests on recovery_cp when resizing
raid1/raid5.  Now that an arbitrary value could be set we should be
more careful in our tests.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |    2 +-
 drivers/md/raid1.c |    2 +-
 drivers/md/raid5.c |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5469ae3..aa640a8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3324,7 +3324,7 @@ resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
 
-	if (mddev->pers)
+	if (mddev->pers && !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
 		return -EBUSY;
 	if (cmd_match(buf, "none"))
 		n = MaxSector;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 779abbd..5d09609 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2061,7 +2061,7 @@ static int raid1_resize(mddev_t *mddev, sector_t sectors)
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
 	if (sectors > mddev->dev_sectors &&
-	    mddev->recovery_cp == MaxSector) {
+	    mddev->recovery_cp > mddev->dev_sectors) {
 		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 51af7f3..34dd545 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5389,7 +5389,8 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 		return -EINVAL;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
-	if (sectors > mddev->dev_sectors && mddev->recovery_cp == MaxSector) {
+	if (sectors > mddev->dev_sectors &&
+	    mddev->recovery_cp > mddev->dev_sectors) {
 		mddev->recovery_cp = mddev->dev_sectors;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}


