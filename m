Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16037C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 22:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiJMWpH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJMWpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Oct 2022 18:45:04 -0400
Received: from resqmta-c1p-023462.sys.comcast.net (resqmta-c1p-023462.sys.comcast.net [IPv6:2001:558:fd00:56::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47695FAC4
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 15:44:56 -0700 (PDT)
Received: from resomta-c1p-023267.sys.comcast.net ([96.102.18.232])
        by resqmta-c1p-023462.sys.comcast.net with ESMTP
        id j5H7oma8703bPj6uGoD3ZE; Thu, 13 Oct 2022 22:42:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665700944;
        bh=Vod9bfBwBD3lRXXsfZrFXG7EXQYLJ2cHVyFKENUAAzU=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=Re0n5EplI24dFjye3XoAHdBxXcH4bciDOweO5K5Q3cX0WB9CUwLab/YdnmAYPejkm
         b82XUcbbcGHNBXq/IfGgF7EBUhWvUWTSdEtsm+Wyc+4EQh2NP9lhATVhgzx+66dX+W
         WosyAor3IJNhPPoWdY3DBF5788JgFtd9bx2XjoyFxL1Cu+KVPkB9oQpNY0Y15VDO4y
         5K4uOL8lixvwPyq0sINIx3AuuluBlZvFycU/kZ2r8oEsyAL/WGMT/To8eU2QHMxChJ
         O+HT/NYvOG0zg/RmZmd6rusAb76rNiM07X6mcycny4RqprPUxHxZMOEocUx4TsZx6L
         kNyFFtzwgn/1w==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023267.sys.comcast.net with ESMTPA
        id j6toofOVmA6uYj6tvozg6y; Thu, 13 Oct 2022 22:42:04 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekuddgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedtteeljeffgfffveehhfetveefuedvheevffffhedtjeeuvdevgfeftddtheeftdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepjedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghkse
 hsohhlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehmrghrihhushiirdhtkhgrtgiihihksehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghv
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v2 3/3] md/bitmap: Convert daemon_work to proper timer
Date:   Thu, 13 Oct 2022 16:41:51 -0600
Message-Id: <20221013224151.300-4-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221013224151.300-1-jonathan.derrick@linux.dev>
References: <20221013224151.300-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It was observed that with certain high I/O workloads that the daemon
work may never run, preventing the bitmap from fully flushing. Ensure
the bitmap fully flushes by converting the daemon worker to a proper
timer.

Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 30 +++++++++++++-----------------
 drivers/md/md-bitmap.h |  3 +--
 drivers/md/md.c        |  9 +++++++--
 drivers/md/md.h        |  1 +
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index cd8250368860..34feb906243f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1250,8 +1250,9 @@ static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
  *			out to disk
  */
 
-void md_bitmap_daemon_work(struct mddev *mddev)
+void md_bitmap_daemon_work(struct timer_list *t)
 {
+	struct mddev *mddev = from_timer(mddev, t, daemon_timer);
 	struct bitmap *bitmap;
 	unsigned long j;
 	unsigned long nextpage;
@@ -1267,11 +1268,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 		mutex_unlock(&mddev->bitmap_info.mutex);
 		return;
 	}
-	if (time_before(jiffies, bitmap->daemon_lastrun
-			+ mddev->bitmap_info.daemon_sleep))
-		goto done;
 
-	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 		goto done;
@@ -1372,6 +1369,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 	if (bitmap->allclean == 0)
 		mddev->thread->timeout =
 			mddev->bitmap_info.daemon_sleep;
+	mod_timer(&mddev->daemon_timer, jiffies + mddev->bitmap_info.daemon_sleep);
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
 
@@ -1735,21 +1733,16 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 void md_bitmap_flush(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
-	long sleep;
 
 	if (!bitmap) /* there was no bitmap */
 		return;
 
 	/* run the daemon_work three time to ensure everything is flushed
-	 * that can be
-	 */
-	sleep = mddev->bitmap_info.daemon_sleep * 2;
-	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
-	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
-	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	* that can be
+	*/
+	md_bitmap_daemon_work(&mddev->daemon_timer);
+	md_bitmap_daemon_work(&mddev->daemon_timer);
+	md_bitmap_daemon_work(&mddev->daemon_timer);
 	if (mddev->bitmap_info.external)
 		md_super_wait(mddev);
 	md_bitmap_update_sb(bitmap);
@@ -1826,7 +1819,7 @@ void md_bitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-
+	del_timer_sync(&mddev->daemon_timer);
 	md_bitmap_free(bitmap);
 }
 
@@ -1904,7 +1897,10 @@ struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
 	if (err)
 		goto error;
 
-	bitmap->daemon_lastrun = jiffies;
+	timer_setup(&mddev->daemon_timer, md_bitmap_daemon_work, 0);
+	mddev->daemon_timer.expires = jiffies + mddev->bitmap_info.daemon_sleep;
+	add_timer(&mddev->daemon_timer);
+
 	err = md_bitmap_resize(bitmap, blocks, mddev->bitmap_info.chunksize, 1);
 	if (err)
 		goto error;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 49a93d8ff307..b7e8f2266bf2 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -220,7 +220,6 @@ struct bitmap {
 	 * the bitmap daemon - periodically wakes up and sweeps the bitmap
 	 * file, cleaning up bits and flushing out pages to disk as necessary
 	 */
-	unsigned long daemon_lastrun; /* jiffies of last run */
 	unsigned long last_end_sync; /* when we lasted called end_sync to
 				      * update bitmap with resync progress */
 	unsigned long unplugged_count; /* last dirty count from md_bitmap_unplug */
@@ -265,7 +264,7 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t new_lo, sector_t new_hi);
 
 void md_bitmap_unplug(struct bitmap *bitmap);
-void md_bitmap_daemon_work(struct mddev *mddev);
+void md_bitmap_daemon_work(struct timer_list *t);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		     int chunksize, int init);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index afaf36b2f6ab..9f8a9f62b3db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9265,8 +9265,13 @@ void md_check_recovery(struct mddev *mddev)
 	if (mddev->suspended)
 		return;
 
-	if (mddev->bitmap)
-		md_bitmap_daemon_work(mddev);
+	if (mddev->bitmap) {
+		spin_lock(&pers_lock);
+		if (mddev->bitmap->allclean == 0)
+			mddev->thread->timeout =
+				mddev->bitmap_info.daemon_sleep;
+		spin_unlock(&pers_lock);
+	}
 
 	if (signal_pending(current)) {
 		if (mddev->pers->sync_request && !mddev->external) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1a558cb18bd4..578cc496c325 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -503,6 +503,7 @@ struct mddev {
 		char                    cluster_name[64]; /* Name of the cluster */
 		unsigned int		flush_threshold; /* how many dirty chunks between updates */
 	} bitmap_info;
+	struct timer_list		daemon_timer;
 
 	atomic_t			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
-- 
2.31.1

