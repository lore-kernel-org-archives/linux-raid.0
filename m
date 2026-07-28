Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955D41A565;
	Tue, 28 Jul 2026 08:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228665; cv=none; b=e1hNLDr/ejgf8cawMI1DsSEuKqZn+G15TRX9XB2IdDs7rvJ1/Iq51soIM94fxIQLeHOpXgZ+33P6ldrA7yNoAwcH6WoKhVXPMJ2HX54/Zf3g1nyKP/Bt2tB9H9T2AfWtIyWqlqSB0vNMS9XQA0uQqLS2mcHk6c0Vg9B3LBhhNJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228665; c=relaxed/simple;
	bh=gR7hdiQ5I8vS7OVsO9+QW47Mk0BpOYfuvvPPjivZfd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjRF2mhUzEx438TxMaeEaQw5rbUCo2FtU/E6U9dsS3CWenovjinjz1a7YT8p1C5QAE3xWdXhy3BbcKFwpScdMX8Idps+YUw2P6zlolI93djMBgDw4ct6eY/0bC9A/ny5EHj+mVUokvpOcE3w1vbFB72T5edBxofXXcrCJE7CIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggrJtQsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggrJtQsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CF11F00A3D;
	Tue, 28 Jul 2026 08:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228664;
	bh=vEahpu76I1yr6iClHd65uvusv9hpOudV68FCl8vBiS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggrJtQsTXob2QcFBrWqiYTC0XlytJOixcQTuZj23RfwGfTrYNWdXDEp74p3Cq9sb1
	 sOoDPP+RkBOhNBOgySr8mCT451vkeMeOs1sZv02BcLB7qG0lIVKxSHlwnxzU1VEpRV
	 d2q8z/2ZXoDJZZXk5OAoGPmE9vKo27I/7Tv9mIt5BGq5QffRZ3nSxOMHdpvaR8u8Tk
	 ILFRnN9udgtBfOFaSX+q3HDq5Mj2ZE8BKLKQEy32ZMPcNkSP3FSDdaZRi2rvMAV91Y
	 k7sAbk5Sbub+h1iHYgu1z3w67aJKOL83AcPKQTYSgrlVRaw3Vq3LIuFeFB3I2Rqubg
	 uqeS1KLah00ng==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 20/21] md/raid5: wire llbitmap reshape lifecycle
Date: Tue, 28 Jul 2026 16:49:20 +0800
Message-ID: <c7c18559845a627beae107842354e6684cb26924.1785206690.git.yukuai@fygo.io>
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

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f0817599dd27..f70b2f611980 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6433,6 +6433,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -6542,6 +6549,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -8574,6 +8588,12 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8658,10 +8678,19 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8688,8 +8717,16 @@ static void raid5_finish_reshape(struct mddev *mddev)
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

