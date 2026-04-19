Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCCE299927;
	Sun, 19 Apr 2026 03:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568230; cv=none; b=r9Q5ZrWACE5GbBQoNIfUlxZXqZ+sykHwMqyeF+VUQdHDwPRMBabSWFBSvVKxp8ns3NrX5JP62mAB9Kh21gpjB+05JzRV6ohhOjFSMslnUbhjFf5QfDvNkDCTSONCr/pH2tDdGPaO+n5uA6UU91Yo8lOwEN7ZC+pRxMA2xuLmu5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568230; c=relaxed/simple;
	bh=cs+O0uaNx66AbjfwIfGPvrxLa7aOSmvIppGUCIaKeUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j73aro577r25mEBSESALghc1isshrPf/Cm6NnxDfDufVQnvSdgxQq8+Iumip4h+0Jqy/rca59LV+lpm2KOFn2uz/DIvX2y2z/t37KseM7D6wNK8hAkzw+oTACLVXxD7yOgwVyhKTAauEbfloYXL8XHHDnu1zX5fpypHs11cvcv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764B3C2BCB4;
	Sun, 19 Apr 2026 03:10:28 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: wire llbitmap reshape lifecycle
Date: Sun, 19 Apr 2026 11:09:41 +0800
Message-ID: <20260419030942.824195-19-yukuai@fnnas.com>
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

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid5.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 178283aa91a4..476f6fc5a97c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6378,6 +6378,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
 			return 0;
+		if (md_bitmap_enabled(mddev, false) &&
+		    mddev->bitmap_ops->reshape_mark &&
+		    conf->reshape_safe != conf->reshape_progress) {
+			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
+						       conf->reshape_progress);
+			mddev->bitmap_ops->unplug(mddev, true);
+		}
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
 		if (!mddev->reshape_backwards)
@@ -6487,6 +6494,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
 			goto ret;
+		if (md_bitmap_enabled(mddev, false) &&
+		    mddev->bitmap_ops->reshape_mark &&
+		    conf->reshape_safe != conf->reshape_progress) {
+			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
+						       conf->reshape_progress);
+			mddev->bitmap_ops->unplug(mddev, true);
+		}
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
 		if (!mddev->reshape_backwards)
@@ -8524,6 +8538,12 @@ static int raid5_start_reshape(struct mddev *mddev)
 			mdname(mddev));
 		return -EINVAL;
 	}
+	if (md_bitmap_enabled(mddev, false) &&
+	    mddev->bitmap_id == ID_LLBITMAP) {
+		i = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors, 0);
+		if (i)
+			return i;
+	}
 
 	atomic_set(&conf->reshape_stripes, 0);
 	spin_lock_irq(&conf->device_lock);
@@ -8608,10 +8628,19 @@ static int raid5_start_reshape(struct mddev *mddev)
  */
 static void end_reshape(struct r5conf *conf)
 {
+	struct mddev *mddev = conf->mddev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		struct md_rdev *rdev;
 
+		if (md_bitmap_enabled(mddev, false) &&
+		    mddev->bitmap_ops->reshape_mark &&
+		    conf->reshape_safe != conf->reshape_progress) {
+			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
+						       conf->reshape_progress);
+			mddev->bitmap_ops->unplug(mddev, true);
+		}
+
 		spin_lock_irq(&conf->device_lock);
 		conf->previous_raid_disks = conf->raid_disks;
 		md_finish_reshape(conf->mddev);
@@ -8638,8 +8667,16 @@ static void raid5_finish_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 	struct md_rdev *rdev;
+	bool llbitmap = mddev->bitmap_id == ID_LLBITMAP &&
+		md_bitmap_enabled(mddev, false);
 
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+		if (llbitmap && mddev->bitmap_ops->reshape_finish)
+			mddev->bitmap_ops->reshape_finish(mddev);
+		if (llbitmap) {
+			mddev->resync_offset = 0;
+			mddev->resync_max_sectors = mddev->dev_sectors;
+		}
 
 		if (mddev->delta_disks <= 0) {
 			int d;
-- 
2.51.0

