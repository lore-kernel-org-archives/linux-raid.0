Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FB4176DF;
	Fri,  5 Jun 2026 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650976; cv=none; b=hyOmMUGjbNEc48p736TRQgPWC1l4/U6zU1zmoDq77lTVXwIANHrpownStTkR8zAAoLthZauXKSukfu65PlXR30kX62I69EZ2t9LEpvkbp6JGSW6vTEy9B9mV7YT0ykCTMuG0lCNTkkpQ+5xoypl/mmp0IGeOWF+FaS5VDzFTDJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650976; c=relaxed/simple;
	bh=DAhBhNjrQ2OCJ4bHCsKLiSYpGhDs/jQTsWbyds4PtMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyeGBt0K4NsHhPUIFBdt3ApG1CNAMVKgabOcaL3xv51rBh04OoMl0tFXV9pCYW1inc+naIbuGKXqrawylbgfgArWNE59G/CjXSZ0OSL7hknc+IZ80pDjGUB1iGiXUeyRB9iFNsUEQfFoOEhbJgQepstWx52F7vrqXQHPKBEvYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dq7GyoUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dq7GyoUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBA1F00893;
	Fri,  5 Jun 2026 09:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650974;
	bh=ezJko17Fc2gxSh8epK1UmqzylJEQQUTxEn+1Q1RpPws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dq7GyoUH7p7+B0Myc6w+CPgj+JA0l8CaybXZTo0T/pjEc3hhxYcGmrfbXlEvDq4gx
	 abPjxWkxV0LtQ74SnQCIbMk1XknUQWHkKLUolvlBIEj7AMBWVIDhMvpgc3wmPhKsYn
	 Blu7ZnjCZVXK1wBfCqIAlcMBuSum7pdDszqttf2KJfhaVhJy86sCRzpR19vw6OYptD
	 RPVYYZZNreeULAVGh9/RerjGxP5TOgNZNB13523OBoK/2l1IWymZ34daR4zSUZbb/K
	 jM0z9b+7U74S9yJgjuOJ1Vhv9UIWG3DkCETXiu2nOicqqeoedC5fNg+SS1GPYzQ96M
	 ZoX+l8+GObcOg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid5: wire llbitmap reshape lifecycle
Date: Fri,  5 Jun 2026 17:15:26 +0800
Message-ID: <20260605091527.2463539-20-yukuai@kernel.org>
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

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 55af1d1eec63..6786f30dc59b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6421,10 +6421,17 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		wait_event(conf->wait_for_reshape,
 			   atomic_read(&conf->reshape_stripes)==0
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
 			/* Can update recovery_offset */
 			rdev_for_each(rdev, mddev)
@@ -6530,10 +6537,17 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		wait_event(conf->wait_for_reshape,
 			   atomic_read(&conf->reshape_stripes) == 0
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
 			/* Can update recovery_offset */
 			rdev_for_each(rdev, mddev)
@@ -8562,10 +8576,16 @@ static int raid5_start_reshape(struct mddev *mddev)
 	    < mddev->array_sectors) {
 		pr_warn("md/raid:%s: array size must be reduced before number of disks\n",
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
 	write_seqcount_begin(&conf->gen_lock);
 	conf->previous_raid_disks = conf->raid_disks;
@@ -8646,14 +8666,23 @@ static int raid5_start_reshape(struct mddev *mddev)
 /* This is called from the reshape thread and should make any
  * changes needed in 'conf'
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
 		smp_wmb();
 		conf->reshape_progress = MaxSector;
@@ -8676,12 +8705,20 @@ static void end_reshape(struct r5conf *conf)
  */
 static void raid5_finish_reshape(struct mddev *mddev)
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
 			spin_lock_irq(&conf->device_lock);
 			mddev->degraded = raid5_calc_degraded(conf);
-- 
2.51.0

