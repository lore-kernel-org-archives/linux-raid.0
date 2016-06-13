From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] raid1/raid10: slow down resync if there is non-resync activity pending
Date: Mon, 13 Jun 2016 15:51:19 +0200
Message-ID: <1465825879-2059-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A performance drop of mkfs has been observed on RAID10 during resync
since commit 09314799e4f0 ("md: remove 'go_faster' option from
->sync_request()"). Resync sends so many IOs it slows down non-resync
IOs significantly (few times). Add a short delay to a resync. The
previous long sleep (1s) has proven unnecessary, even very short delay
brings performance right.

The change also applied to raid1. The problem has not been observed on
raid1, however it shares barriers code with raid10 so it might be an
issue for some setup too.

Suggested-by: NeilBrown <neilb@suse.com>
Link: http://lkml.kernel.org/r/20160609134555.GA9104@proton.igk.intel.com
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid1.c  | 7 +++++++
 drivers/md/raid10.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 39fb21e..03c5349 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2535,6 +2535,13 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		return sync_blocks;
 	}
 
+	/*   
+	* If there is non-resync activity waiting for a turn,
+	* then let it though before starting on this new sync request.
+	*/
+	if (conf->nr_waiting)
+		schedule_timeout_uninterruptible(1);
+
 	/* we are incrementing sector_nr below. To be safe, we check against
 	 * sector_nr + two times RESYNC_SECTORS
 	 */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..8a4791e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2912,6 +2912,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	    max_sector > (sector_nr | chunk_mask))
 		max_sector = (sector_nr | chunk_mask) + 1;
 
+	/*
+	* If there is non-resync activity waiting for a turn,
+	* then let it though before starting on this new sync request.
+	*/
+	if (conf->nr_waiting)
+		schedule_timeout_uninterruptible(1);
+
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,
-- 
1.8.3.1

