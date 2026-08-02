Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EDF33F368;
	Sun,  2 Aug 2026 19:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700335; cv=none; b=XEzEZclD5JTnmY8caj0QOLJTontA3h2CpC8gcuvTLTkPynZm88/ki2ew0/RegpPUrHUqeR9MbUj7zMI+woLaMOiKuaslUAh6YZ8ncrzwQB0yUamjviFuQ+O1lxvezIggY3NIpV9J3cvPCusfZOudbTJo7qFIdfvhJUqZBItRJkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700335; c=relaxed/simple;
	bh=EuyIktEHVmA5SmDcvWqhEPRJ9r0PZUtvrnevxd2wDNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRPpiCNQcARyQnNis+kWP5r4p1prIT2dKkpFujV52GODLIVFpGIfMOcXMzRkbcxUXRJGpwbyQde1ErQZj4fH6EJqfDhUEnfdtmh2FCDzxjR0BOIugR3ul0jkVNLmHuk9aJ2hl7IYquKWIgpQPzvneMeTMY7mqNaeR9QQCqKZ6Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Skc7f0jE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Skc7f0jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A061F00A3A;
	Sun,  2 Aug 2026 19:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700333;
	bh=MfCLfvgIrt08NkdV2kT4xWFejRZpsGF464/3VXQmSn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Skc7f0jEaxTWlz0zSbTySgQhGe1SDj/n9CVuiLIHjX3vYKYpEkGO1lIgjMqVSJAwl
	 ehEPkVS8KirMQAoqVA5yErpX7WQnHWkvcBrUepueykexv6fG5RpafyRzZiYbjs9EpN
	 89lce34qyrHiw0oiq/fDLxLEec1nxAFA6QV43lUNhbAmATxGf8Jhajvbwm0+c/7+aw
	 GEk9Ex99SJBvptS87EznRefFQOR5lzcjwcNXixrMwytgmkTaCtlE4LjSp6OzmYCXik
	 8ZlACHVkNvj0IRrXGBwY0EaPy1BEEVqKZtLZO6EoTJvLow/3xajVavydHMbWhOdDQB
	 krFYsBVnC1htg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 24/29] md/raid10: wire llbitmap reshape lifecycle
Date: Mon,  3 Aug 2026 03:50:33 +0800
Message-ID: <20260802195038.164272-25-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
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

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1c3393467667..bac9edd28c97 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4356,6 +4356,12 @@ static int raid10_start_reshape(struct mddev *mddev)
 
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
@@ -4679,6 +4685,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
 		wait_barrier(conf);
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
@@ -4877,9 +4890,19 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
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
@@ -5011,10 +5034,15 @@ static void end_reshape_request(struct r10bio *r10_bio)
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
@@ -5041,6 +5069,15 @@ static void raid10_finish_reshape(struct mddev *mddev)
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
@@ -5067,6 +5104,8 @@ static struct md_personality raid10_personality =
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.update_reshape_pos = raid10_update_reshape_pos,
+	.bitmap_sync_size = raid10_bitmap_sync_size,
+	.bitmap_array_sectors = raid10_bitmap_sync_size,
 };
 
 static int __init raid10_init(void)
-- 
2.51.0

