Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9755841D13E;
	Tue, 28 Jul 2026 08:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228644; cv=none; b=mQcld1UTR6Y/a0l5qrrISdF9TO7eKSZhtv2yVuIsiQ9VC0u5ZxP5AGE+rKsowNypAtKykj7ed7jIY4+pPehEqMijCYzIjZfB66mvkrK2XfdwChTevePmg/1wVAZePYj69jTn9c1ux78apX5JWv+c0WFU7WA0hdx27Yz80YpkI60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228644; c=relaxed/simple;
	bh=jWmDY+JcgU6hiQ+w5whTXYiG5hB5v7D7ObqFVFNBgtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0lM284cltpZbI7DNAphi1elE8TxdrcJR2nl2SxK0HhxB9Q3tzH+m+b8WJjRI/H/2bnWeGNgOAN2n73RhESISbCELsjV0zQyKjMOc+iPkKM5br4TPSgJSgXz2XiNr+adXbHM+4epl/kFFvfvzXJMerpsz7Mg81RcXwEuA33uzco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTNHszZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTNHszZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0441F000E9;
	Tue, 28 Jul 2026 08:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228643;
	bh=lObO1E/A9QymwsBQlLWma+ph5LTnPnw2QV9lQjO4Hks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTNHszZNcXurKV7KRNXNopIwgZYx7AZkm3C07BbKZtjjgMmPrBOZDoGvEOGf0kiFf
	 MsLsuP79tDN2VptiQtsaaYYSUsMqfTvu1/1lALsBE7CL7V8sPZDKXlnEZekBkBdeRx
	 m1sIl9VRfmx7uZkx8X5yVzR+qKSoLjmKkfk+tOFrpt5wz8bOO6x7i5KLjT/RADjvAS
	 BDRx9j1Uy8OGgxwZNHncgiIShmvDr9zybMJN2bF6+8vJJ4cSkrSz30gsaBlOs0k/Ad
	 xPaWxxi5OhCuEg39+mILc5W/RVS69xLzTfRk+kTHFP2qgL283mbRl/bo9le8lBvw6z
	 mjB5YUeXRfOMw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 16/21] md/raid10: wire llbitmap reshape lifecycle
Date: Tue, 28 Jul 2026 16:49:16 +0800
Message-ID: <a5d81ab33dd45f4f98cbb8cec9ad530258d1a144.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Prepare llbitmap before RAID10 starts growing, checkpoint the bitmap
before advancing reshape_position, finish the llbitmap geometry update
when reshape completes, and export the old and new tracked sizes.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1242b8d3bb6b..e50e4adee389 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4394,6 +4394,12 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
+	if (md_bitmap_enabled(mddev, false) &&
+	    mddev->bitmap_ops->reshape_can_start) {
+		ret = mddev->bitmap_ops->reshape_can_start(mddev);
+		if (ret)
+			return ret;
+	}
 
 	if (setup_geo(&new, mddev, geo_start) != conf->copies)
 		return -EINVAL;
@@ -4707,6 +4713,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
 		wait_barrier(conf, false);
+		if (md_bitmap_enabled(mddev, false) &&
+		    mddev->bitmap_ops->reshape_mark &&
+		    conf->reshape_safe != conf->reshape_progress) {
+			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
+						       conf->reshape_progress);
+			mddev->bitmap_ops->unplug(mddev, true);
+		}
 		mddev->reshape_position = conf->reshape_progress;
 		if (mddev->reshape_backwards)
 			mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
@@ -4905,9 +4918,19 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 static void end_reshape(struct r10conf *conf)
 {
+	struct mddev *mddev = conf->mddev;
+
 	if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery))
 		return;
 
+	if (md_bitmap_enabled(mddev, false) &&
+	    mddev->bitmap_ops->reshape_mark &&
+	    conf->reshape_safe != conf->reshape_progress) {
+		mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
+					       conf->reshape_progress);
+		mddev->bitmap_ops->unplug(mddev, true);
+	}
+
 	spin_lock_irq(&conf->device_lock);
 	conf->prev = conf->geo;
 	md_finish_reshape(conf->mddev);
@@ -5039,10 +5062,15 @@ static void end_reshape_request(struct r10bio *r10_bio)
 static void raid10_finish_reshape(struct mddev *mddev)
 {
 	struct r10conf *conf = mddev->private;
+	bool llbitmap = mddev->bitmap_id == ID_LLBITMAP &&
+		md_bitmap_enabled(mddev, false);
 
 	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 		return;
 
+	if (llbitmap && mddev->bitmap_ops->reshape_finish)
+		mddev->bitmap_ops->reshape_finish(mddev);
+
 	if (mddev->delta_disks > 0) {
 		if (mddev->resync_offset > mddev->resync_max_sectors) {
 			mddev->resync_offset = mddev->resync_max_sectors;
@@ -5069,6 +5097,15 @@ static void raid10_finish_reshape(struct mddev *mddev)
 	mddev->reshape_backwards = 0;
 }
 
+static sector_t raid10_bitmap_sync_size(struct mddev *mddev, bool previous)
+{
+	struct r10conf *conf = mddev->private;
+
+	if (previous)
+		return raid10_size(mddev, 0, 0);
+	return raid10_size(mddev, 0, conf->geo.raid_disks);
+}
+
 static struct md_personality raid10_personality =
 {
 	.head = {
@@ -5095,6 +5132,8 @@ static struct md_personality raid10_personality =
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.update_reshape_pos = raid10_update_reshape_pos,
+	.bitmap_sync_size = raid10_bitmap_sync_size,
+	.bitmap_array_sectors = raid10_bitmap_sync_size,
 };
 
 static int __init raid10_init(void)
-- 
2.51.0

