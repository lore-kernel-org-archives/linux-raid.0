From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/10] md: use resync_max_sectors for reshape as well as
 resync.
Date: Tue, 03 Apr 2012 15:53:02 +1000
Message-ID: <20120403055301.19495.56949.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some resync type operations need to act on the address space of the
device, others on the address space of the array.

This only affects RAID10, so it sets resync_max_sectors to the array
size (it defaults to the device size), and that is currently used for
resync only.  However reshape of a RAID10 must be done against the
array size, not device size, so change code to use resync_max_sectors
for both the resync and the reshape cases.
This does not affect RAID5 or RAID1, just RAID10.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8da63d1..a672f0d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4426,7 +4426,8 @@ sync_completed_show(struct mddev *mddev, char *page)
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return sprintf(page, "none\n");
 
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sectors = mddev->resync_max_sectors;
 	else
 		max_sectors = mddev->dev_sectors;
@@ -6804,7 +6805,8 @@ static void status_resync(struct seq_file *seq, struct mddev * mddev)
 
 	resync = mddev->curr_resync - atomic_read(&mddev->recovery_active);
 
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sectors = mddev->resync_max_sectors;
 	else
 		max_sectors = mddev->dev_sectors;
@@ -7367,7 +7369,7 @@ void md_do_sync(struct mddev *mddev)
 			j = mddev->recovery_cp;
 
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
-		max_sectors = mddev->dev_sectors;
+		max_sectors = mddev->resync_max_sectors;
 	else {
 		/* recovery follows the physical size of devices */
 		max_sectors = mddev->dev_sectors;


