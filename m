Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84038AC75;
	Wed, 24 Jun 2026 06:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283383; cv=none; b=c1a8q6Z1w89Lm4wMbTpTeOOAjt3kSkobx/E6IRmchSlzE99T9nzU3Yk0dPgGtCPEIey6GGDgHv8/vEP0e8gaNucG28mKZKlZIcCyZoAYDiaXGLlnAx/gsRjhvpfSHB/kPhQRixJWVTOnBmfHN1FdN+eJ3grN3R/oy6X4Flh/Zlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283383; c=relaxed/simple;
	bh=jWmDY+JcgU6hiQ+w5whTXYiG5hB5v7D7ObqFVFNBgtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smoA3RGrcu9/klJwVxVVTIVFhZwoTPP6E/bN/CKZillD/bSPzSzOHzHXRJLw2tSbW+gvry7cl9jOzkzBaUErjymT1NRk9iIZ9W8Kt2N8KYqc710EFO6D3jSML9/06Yi5ZqHEX7yI454UYJe7VYCr1o5nWBWaDSyOH96jhErlUk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUaEsPOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUaEsPOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FE11F00A3A;
	Wed, 24 Jun 2026 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283381;
	bh=lObO1E/A9QymwsBQlLWma+ph5LTnPnw2QV9lQjO4Hks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUaEsPORMDJL3H6B6eOEpZcOQYbERTCo7sf8admkTzmbQ9iRgoqCwR1UEexcLE1zi
	 8ZkcFhMFzzUi5p23+JkC1RzQfL1Fr7eozNLyr/4p0lizglFMIaGVw0y2zV7jCsc0CE
	 iCGdom7wzeBenz3UwI6AE5JYAnvt9d5hndFHS6ZrgI7EBNdBp4McZp/rrdOnAtUOZR
	 Gdj8S3vhmx13fPC3Xs1bBJcCJ7PqI06akO9XfWMgqJlffnYQtM4E8vZKpZs8EWs/Yo
	 5NpMkdvlNbHj/0+540ySwfE8AyUTZ4dpqxPreGb6v+iskLjCDIHHPkQTyKYecW+OKi
	 USv3NZHqaXP7Q==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/20] md/raid10: wire llbitmap reshape lifecycle
Date: Wed, 24 Jun 2026 14:42:12 +0800
Message-ID: <54625332edcdb5f009fb0920220ea12aa696f408.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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

