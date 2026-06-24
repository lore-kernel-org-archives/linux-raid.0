Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D2A38A72B;
	Wed, 24 Jun 2026 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283393; cv=none; b=N9jZL5MMZbahnzyiJ1aovLMqyy/v2ehhIi4AAQ2sianYaxKjMjq0n5pbDuCzVKVPo/ADZ3z7i+45syQeW90lCRoULscQZNoyVBEaqyMNrr3S5VnU6+VxmFGepzuP+Uqf0gIwY5zAhDsO4aKjSRiBXlt8yH9pIk1OOaV+NDIux0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283393; c=relaxed/simple;
	bh=uEobAYLg7ZX62unZfdt7ZnzYTGppuM0Y37O5H4CaPfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKuUmtCGZO5CEZnhwnArMHK+/yLnxCTyfbDUDj40IIfmewwKhO5Ojq0NXURJX94jru7pVvfyLelNIk89QqoddHqd4Ef1FjyDErcdDaF1igllCEzg6PCbF0FrrrsT1l4FYkeAGulsJ4/zrcyqF6BWP0h1VmboDDheeMb25+YOnnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TijJZAHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TijJZAHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC331F00A3A;
	Wed, 24 Jun 2026 06:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283391;
	bh=dNMPAimzlmkb9T1S08EQBF2KTrKFVrt29+R73/AXwBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TijJZAHgPTMvLWLg0ntZZCU3pfJrRUlsxoU4qGJ4UfKZZzCsTOGKclBETKm2m3p36
	 v1VxSNJpQV8FVADi6PPxO/e/3BX0ap5WNll+C1DKpbkidHcJ3wqdrmsyKQRaCzsiy1
	 xtgMa1HxjvgKPJYon1IVH84IZhSt+GJhlexbYZuC79xN7Eh1o4i5wehnrvfoHNTjtX
	 Ypug7qx9nXIfDcXbYdZYxVKMYAU6ZV4FSrdLAR2uvbcU5fsoKTbf34s/AbrLpRYBv9
	 0LhO20YWdWd3fghlRUOun13JzGAJkFMXluNYmMAhLwMxFWHCbaL83GYDFK677jEvqG
	 zvXQ4zCv0uQCg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/20] md/raid5: wire llbitmap reshape lifecycle
Date: Wed, 24 Jun 2026 14:42:16 +0800
Message-ID: <55686793056df8053d1797d22c18fce8df7eebe8.1782282042.git.yukuai@kernel.org>
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

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9de648f75dd0..ac7ea483502f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6430,6 +6430,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -6539,6 +6546,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -8571,6 +8585,12 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8655,10 +8675,19 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8685,8 +8714,16 @@ static void raid5_finish_reshape(struct mddev *mddev)
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

