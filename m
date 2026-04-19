Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A024EAB1;
	Sun, 19 Apr 2026 03:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568222; cv=none; b=oDOsZS3wbnfMmvz91tv808VT65VRNfkSpbHsURlBgm0VO9ZkOx6jhQlsPWOO+HMCMgNiu4khMvqMz9n7910PIs4QtapV6Nq2+BwdXU4MLUaXlpcUccV5GlvdI/Fw+3wKbiTAHFZyotmuLMgflaB3Pxi4RPwm/k/3xIqJgYEoQxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568222; c=relaxed/simple;
	bh=mfzabSTn+cujwcBQ26CvProaU9iEkSxKOLHPG0f221Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY03n8mhl3le8rPT1oweYATYhvUc9Cs8e4ux11wq4HoVy+0+BIW6nrtW9H22Kw12As5GXQ6+oWoFK5mc0mHTbz8cqU4et47VGtJLRgl/KyrGulfY6fG6qtwf797Azy+NgW4dFD0tEt+0kckrjQKAszr1SRlQ0U7VvpSeLqj83tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD050C2BCB4;
	Sun, 19 Apr 2026 03:10:20 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid10: wire llbitmap reshape lifecycle
Date: Sun, 19 Apr 2026 11:09:37 +0800
Message-ID: <20260419030942.824195-15-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260419030942.824195-1-yukuai@fnnas.com>
References: <20260419030942.824195-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prepare llbitmap before RAID10 starts growing, checkpoint the bitmap
before advancing reshape_position, finish the llbitmap geometry update
when reshape completes, and export the old and new tracked sizes.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ad19257c79fb..13e31d01ed0f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4370,6 +4370,12 @@ static int raid10_start_reshape(struct mddev *mddev)
 
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
@@ -4683,6 +4689,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
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
@@ -4881,9 +4894,19 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
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
@@ -5015,10 +5038,15 @@ static void end_reshape_request(struct r10bio *r10_bio)
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
@@ -5045,6 +5073,15 @@ static void raid10_finish_reshape(struct mddev *mddev)
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
@@ -5071,6 +5108,8 @@ static struct md_personality raid10_personality =
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.update_reshape_pos = raid10_update_reshape_pos,
+	.bitmap_sync_size = raid10_bitmap_sync_size,
+	.bitmap_array_sectors = raid10_bitmap_sync_size,
 };
 
 static int __init raid10_init(void)
-- 
2.51.0

