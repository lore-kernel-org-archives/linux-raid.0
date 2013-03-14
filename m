From: mwilck@arcor.de
Subject: [PATCH] RAID10: Allow skipping recovery when clean arrays are assembled
Date: Thu, 14 Mar 2013 21:11:31 +0100
Message-ID: <1363291891-10408-1-git-send-email-mwilck@arcor.de>
References: <51422D10.3040000@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51422D10.3040000@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

When an array is assembled incrementally with mdadm -I -R
and the array switches to "active" mode, md starts a recovery.

If the array was clean, the "fullsync" flag will be 0. Skip
the full recovery in this case, as RAID1 does (the code was
actually copied from the sync_request() method of RAID1).
---
 drivers/md/raid10.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 64d4824..e373d88 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2863,6 +2863,22 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (init_resync(conf))
 			return 0;
 
+	/*
+	 * Allow skipping a full rebuild for incremental assembly
+	 * of a clean array, like RAID1 does.
+	 */
+	if (mddev->bitmap == NULL &&
+	    mddev->recovery_cp == MaxSector &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
+	    conf->fullsync == 0) {
+		*skipped = 1;
+		max_sector = mddev->dev_sectors;
+		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
+		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+			max_sector = mddev->resync_max_sectors;
+		return max_sector - sector_nr;
+	}
+
  skipped:
 	max_sector = mddev->dev_sectors;
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
-- 
1.7.1
