Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CE133C518;
	Sun,  2 Aug 2026 19:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700351; cv=none; b=UHkXWVEdK4Vhbkl1dh7OHlPehw/8H8L8aiOvy3T4iFgrr3Xo5XKMx3CiU9NWacMKJN4ZQUynPo/vN20X2+7X7saqMdYDwi+lQikWGffOSEgxLFn3LgOvZzOuydlwxetVdLHdYnKMryc+27Tv+/RDRwyQCoohCKWKdgujxPdpLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700351; c=relaxed/simple;
	bh=ewheLMNF6mpFLUG/mnveS/nXV6Nb/QOHQrhC0TwSGhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/rWrzqZPNa+BHLcBEg48I5UqMZi2RGd3s4w1LpDr4P0WTpibQb/xb0aRclJgFMVeEyJStTbBpc72qglEWG2dKnQ6VB/LllgpTm7/Ur8f4O+wI/9N/qeOlIE62N0Vcwijwno9+WSJFZyJORuRlnLrmxgVp7SxkFt6nZ2jrNd1rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPp+ntOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPp+ntOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD251F00A3A;
	Sun,  2 Aug 2026 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700350;
	bh=A1vLhIXj5KEQVFVbQzvp3M2SPBeKYnjOlBcnZmJBjw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPp+ntOmYWyx/41SsbiIgzWFSnlL/0YQD5ISCSfkwq+H8YjqojWQBZxG5tnRXWutV
	 eXcSZPru8De9blyliwztyFsUnhzwW2h9xXEhF8Dh9WNA43S3m1NdPl4B3US5/JDUKq
	 cUv9vzTTvTd194p3otDC4Ev05mrbFbPtPPCnc8LfkschMvWZDhmaSij4mO5hW/1v6a
	 xlz6buBOhXW5NsSFTjmMEGOvNmht8e9JvVArDaolLubgUoKML91+ib4SuZo8uePfYQ
	 92Bp7DATpIUI4lmHLszbdMa3fRlVmAWLZJjkCp+T37+pHmMU+mRpcQRFoZ/vnFnpVC
	 3dCuALh7+n4RQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 28/29] md/raid5: wire llbitmap reshape lifecycle
Date: Mon,  3 Aug 2026 03:50:37 +0800
Message-ID: <20260802195038.164272-29-yukuai@kernel.org>
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

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 67d56c92c8a4..5176de5b5956 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6497,6 +6497,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -6606,6 +6613,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
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
@@ -8648,6 +8662,12 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8732,10 +8752,19 @@ static int raid5_start_reshape(struct mddev *mddev)
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
@@ -8762,8 +8791,16 @@ static void raid5_finish_reshape(struct mddev *mddev)
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

