Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1390E413604;
	Fri,  5 Jun 2026 09:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650967; cv=none; b=FcacrG/Rw2qS/q/v8uLmC/T4DLCD799B6jLndVF61wkLsTao0aYYRVLEcg8tfDq4nXEf0jB8QYbHWVmCiUuBBWy+aF3Qws/yr4xvc/neRsd50qJdjGHPM3GDXD8wylcFtJ6p4exPq2l5u1P8t+Zet3AnGxD8Angsmsf7Zv4h7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650967; c=relaxed/simple;
	bh=t3GIcCVAzYI//3Y1lClIDtym6SmZ1F5u56q9xqTjg6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1mUG03yjR9Mc744Cf3vxeKImMZqIUwKRHpcrcc6tzqTWA9ZF/RG9DfJdJKnNXqyKvQxdMiqxpxh6HDDCViWCod+RAFtHl1H0FqYZKYuZrgbjmGs61n9NYcdedWdReafKCB3gH2uFQTbTjpVbtBYX3QOqF1Gx/vX5icqYpuPcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JeiK4R20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JeiK4R20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9818E1F00893;
	Fri,  5 Jun 2026 09:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650965;
	bh=n0vMjFz7T73smfzAgB6700dFB9PhLxN7GlAd64koSn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeiK4R20mGwNKECYwtKcYXMXwg0Qj3xDwBG+8uEn99IB0WzOWQ0A5E9owPdDMq2Bm
	 5Xx5Df/ECas9lqbMIGOv+oIGWgJYKzXRFcKcRshRo4c21PpWYQQQdQPnUi1bBVCNfF
	 P2MmEphVlL38M9xqCJzkAzJgsTc/oVzKLbGD5ToX/CWLYnTmm1FwHOeYBlvgJB1d/o
	 kytKtyRKn5b28HZCKiWpt66yRBOatwMxPark/+RehYGUYfPxJq1XqIdMqAeJa79dR0
	 U7Lvs0u2nsGK1RI5eG4r0DKnkbTWulN5aY6Guvqn74AYEG3AopDeYMhYX7oiYd/GuA
	 wQg6La8PQRGkQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid10: wire llbitmap reshape lifecycle
Date: Fri,  5 Jun 2026 17:15:22 +0800
Message-ID: <20260605091527.2463539-16-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
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
index c69ef76c89e1..40000b867136 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4379,10 +4379,16 @@ static int raid10_start_reshape(struct mddev *mddev)
 	int spares = 0;
 	int ret;
 
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
 
 	before_length = ((1 << conf->prev.chunk_shift) *
@@ -4692,10 +4698,17 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 
 	if (need_flush ||
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
 				- conf->reshape_progress;
 		else
@@ -4890,13 +4903,23 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	end_reshape_request(r10_bio);
 }
 
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
 	smp_wmb();
 	conf->reshape_progress = MaxSector;
@@ -5024,14 +5047,19 @@ static void end_reshape_request(struct r10bio *r10_bio)
 }
 
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
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		}
@@ -5054,10 +5082,19 @@ static void raid10_finish_reshape(struct mddev *mddev)
 	mddev->reshape_position = MaxSector;
 	mddev->delta_disks = 0;
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
 		.type	= MD_PERSONALITY,
 		.id	= ID_RAID10,
@@ -5080,10 +5117,12 @@ static struct md_personality raid10_personality =
 	.takeover	= raid10_takeover,
 	.check_reshape	= raid10_check_reshape,
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.update_reshape_pos = raid10_update_reshape_pos,
+	.bitmap_sync_size = raid10_bitmap_sync_size,
+	.bitmap_array_sectors = raid10_bitmap_sync_size,
 };
 
 static int __init raid10_init(void)
 {
 	return register_md_submodule(&raid10_personality.head);
-- 
2.51.0

