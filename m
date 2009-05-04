From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 4/7] md: tidy up status_resync to handle large arrays.
Date: Mon, 04 May 2009 16:58:50 +1000
Message-ID: <20090504065850.11688.43143.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Two problems in status_resync.
1/ It still used Kilobytes as the basic block unit, while most code
   now uses sectors uniformly.
2/ It doesn't allow for the possibility that max_sectors exceeds
   the range of "unsigned long".

So
 - change "max_blocks" to "max_sectors", and store sector numbers
   in there and in 'resync'
 - Make 'rt' a 'sector_t' so it can temporarily hold the number of
   remaining sectors.
 - use sector_div rather than normal division.
 - change the magic '100' used to preserve precision to '32'.
   + making it a power of 2 makes division easier
   + it doesn't need to be as large as it was chosen when we averaged
     speed over the entire run.  Now we average speed over the last 30
     seconds or so.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   45 ++++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 612343f..5eb01a4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5705,37 +5705,38 @@ static void status_unused(struct seq_file *seq)
 
 static void status_resync(struct seq_file *seq, mddev_t * mddev)
 {
-	sector_t max_blocks, resync, res;
-	unsigned long dt, db, rt;
+	sector_t max_sectors, resync, res;
+	unsigned long dt, db;
+	sector_t rt;
 	int scale;
 	unsigned int per_milli;
 
-	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
+	resync = mddev->curr_resync - atomic_read(&mddev->recovery_active);
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-		max_blocks = mddev->resync_max_sectors >> 1;
+		max_sectors = mddev->resync_max_sectors;
 	else
-		max_blocks = mddev->dev_sectors / 2;
+		max_sectors = mddev->dev_sectors;
 
 	/*
 	 * Should not happen.
 	 */
-	if (!max_blocks) {
+	if (!max_sectors) {
 		MD_BUG();
 		return;
 	}
 	/* Pick 'scale' such that (resync>>scale)*1000 will fit
-	 * in a sector_t, and (max_blocks>>scale) will fit in a
+	 * in a sector_t, and (max_sectors>>scale) will fit in a
 	 * u32, as those are the requirements for sector_div.
 	 * Thus 'scale' must be at least 10
 	 */
 	scale = 10;
 	if (sizeof(sector_t) > sizeof(unsigned long)) {
-		while ( max_blocks/2 > (1ULL<<(scale+32)))
+		while ( max_sectors/2 > (1ULL<<(scale+32)))
 			scale++;
 	}
 	res = (resync>>scale)*1000;
-	sector_div(res, (u32)((max_blocks>>scale)+1));
+	sector_div(res, (u32)((max_sectors>>scale)+1));
 
 	per_milli = res;
 	{
@@ -5756,25 +5757,35 @@ static void status_resync(struct seq_file *seq, mddev_t * mddev)
 		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
 		      "resync" : "recovery"))),
 		   per_milli/10, per_milli % 10,
-		   (unsigned long long) resync,
-		   (unsigned long long) max_blocks);
+		   (unsigned long long) resync/2,
+		   (unsigned long long) max_sectors/2);
 
 	/*
-	 * We do not want to overflow, so the order of operands and
-	 * the * 100 / 100 trick are important. We do a +1 to be
-	 * safe against division by zero. We only estimate anyway.
-	 *
 	 * dt: time from mark until now
 	 * db: blocks written from mark until now
 	 * rt: remaining time
+	 *
+	 * rt is a sector_t, so could be 32bit or 64bit.
+	 * So we divide before multiply in case it is 32bit and close
+	 * to the limit.
+	 * We scale the divisor (db) by 32 to avoid loosing precision
+	 * near the end of resync when the number of remaining sectors
+	 * is close to 'db'.
+	 * We then divide rt by 32 after multiplying by db to compensate.
+	 * The '+1' avoids division by zero if db is very small.
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
 	db = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active))
 		- mddev->resync_mark_cnt;
-	rt = (dt * ((unsigned long)(max_blocks-resync) / (db/2/100+1)))/100;
 
-	seq_printf(seq, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
+	rt = max_sectors - resync;    /* number of remaining sectors */
+	sector_div(rt, db/32+1);
+	rt *= dt;
+	rt >>= 5;
+
+	seq_printf(seq, " finish=%lu.%lumin", (unsigned long)rt / 60,
+		   ((unsigned long)rt % 60)/6);
 
 	seq_printf(seq, " speed=%ldK/sec", db/2/dt);
 }


