Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD323B71D3;
	Sat,  1 Aug 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605254; cv=none; b=fnFF0iUfHmdpozpXGjkQeX1Uki/M2Fic139UKJRLvHNiO6sMLKjD6Jj1unFlDQmDYWy6PuRyPQ/IrpGeZy6hm9qBFZ73i08rtRhllodKlFMe25S2TAH7o7OPJoA7HdwII5+57BWeDx6cn6dkEvsBIhPDhA1vydPb6++hn51ZKxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605254; c=relaxed/simple;
	bh=jWmDY+JcgU6hiQ+w5whTXYiG5hB5v7D7ObqFVFNBgtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4wM3m/0rLwFzwX1wE+MDAVeWnrK/2vDE/5E4v5tcMbAsKekiYTXkcAZ8v2xT30zwx+nvxj9Aylmus03yIQVxOnmLt6UB0iVxROsvhOsLsQarHB3u+P/4x6sCHgV83K0WlTqX4r1URI+JeSCcfEpqSbYc2H3QJAxJUo+mC7xao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiQBGMTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiQBGMTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE61F00ACA;
	Sat,  1 Aug 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605252;
	bh=lObO1E/A9QymwsBQlLWma+ph5LTnPnw2QV9lQjO4Hks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiQBGMTcSlKd/LssJxcCVttYOURqIofPovSsLQE5Cx8TxCRiY9XZbCn74CLkpcrst
	 oB7uRT3spFAXGmPODmWiE1capiA9hqrnYMDfGaZs+1Psfw3TMuvV1RxvqyFMluI9Ly
	 uDFLUrfSYHfAC41cQsqX4DwjKszyNO86o4nvnZknLDJdRbc7zkvM9AKdEQdie8BmvG
	 QzrFSjddU+Ne5ahmnhqvMvgwKiVhlJRbvo+regFeKQ/SDQ2hQXK8aORVR5JhSks25R
	 a5NqO95LtZhmMBPWv1ady/rjvfNt56Rs1x9IW2Hat6LXQJsFzoaBCd/dXYFaXh1KnH
	 7kF0YQnvTCtZw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 20/25] md/raid10: wire llbitmap reshape lifecycle
Date: Sun,  2 Aug 2026 01:25:14 +0800
Message-ID: <20260801172519.2982121-21-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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

