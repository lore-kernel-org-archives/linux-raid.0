Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BACE26ED3E
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 07:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975040; cv=none; b=InS+6iba3odOf9TnwzkowV3cQwdrRQpsuRiqB6zHF5BRuUSdD2uvdJtZsStn30Sk+50lQV66fNXHdjhEqiiDs2gLr0qo6iinH5cRBu96/ptmo66dxK7ql76Xth/hQoeilO56Ri4tLAnSckpPVyrrgbcJSc7CZCGlmaV9XcPenJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975040; c=relaxed/simple;
	bh=LfZf7kni2vEh+TIrfZyam0mp4W1w4f50R4BGZtFinBM=;
	h=In-Reply-To:To:Cc:From:Mime-Version:References:Date:Content-Type:
	 Subject:Message-Id; b=n+OGzTxqQF8IFj1wDRxA2R5NbKdeGNd82rLc3QI91D0AApN6DQK1h3awmBZ7GrERJ3/2O/JITJpUIUnM5f2hJofX2aFlsEr4iykCd1oR8m1sLZ3Il/f9sqr7nu3ngXHOCd7j1licYVzAblcq3aMXpUsLfhGuaO541M1zU2tlVtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=xRIvTGBo; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="xRIvTGBo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789975028;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4bt6TbqzC1Xx8StaXg4WKcyOyZbzqABuMTmk4e8R9GY=;
 b=xRIvTGBopMck9yk9dU8drDvDMzS++0jMWWXn6kZlZ+Bmw6bVWDE+w2YRiSiqDcxNsbIHTU
 YNZm5SoSzJilJ9UGXaXZSNMyFxYj8obJf5RJZpusKVtLIbU/fnmimD8qqTXALB43yHmBVR
 FyYSp3oVaL47otWQkSQcKgY5+vgOiNFOJHNCH5MncN+Rs9L54KBBD57H7sVtO1+HJbpzXN
 iB3Y8Ube01sXICtlgKrod0CqXh30PRPh8TMh2CQdg8S00Xhp8XSQC+wrq7A6wn/ALW+0dS
 g0/2hwDS3A1xfoFAh0fbx5ozlo7acXh0mx6rfW5ocg/acCOBDWiH7p+Pf4qvdQ==
Received: from fedora ([183.34.169.232]) by smtp.feishu.cn with ESMTPS; Mon, 21 Sep 2026 15:17:05 +0800
In-Reply-To: <cover.1789974245.git.chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <yukuai@fygo.io>, <nixiao@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1789974245.git.chencheng@fnnas.com>
Date: Mon, 21 Sep 2026 15:16:52 +0800
X-Mailer: git-send-email 2.55.0
X-Lms-Return-Path: <lba+26ab0d9f2+50b126+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v2 1/2] md/raid5: extract min_raid_disks()
Message-Id: <1dc59914e6935a0d6cdafaa1e73f682935f13abf.1789974245.git.chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

Reuse the minimum disk count in setup_conf() and check_reshape().

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d5a8428778e3..f0390918adb3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7630,14 +7630,19 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
 		/* unlikely, but not impossible */
 		return 0;
 	return max_stripes - min_stripes;
 }
 
+static int min_raid_disks(int level)
+{
+	return level == 6 ? 4 : 2;
+}
+
 static struct r5conf *setup_conf(struct mddev *mddev)
 {
 	struct r5conf *conf;
-	int raid_disk, memory, max_disks;
+	int raid_disk, memory, max_disks, min_disks;
 	struct md_rdev *rdev;
 	struct disk_info *disk;
 	char pers_name[6];
 	int i;
 	int group_cnt;
@@ -7657,15 +7662,15 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	     && !algorithm_valid_raid6(mddev->new_layout))) {
 		pr_warn("md/raid:%s: layout %d not supported\n",
 			mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
-	if ((mddev->new_level != 6 && mddev->raid_disks < 2) ||
-	    (mddev->new_level == 6 && mddev->raid_disks < 4)) {
+	min_disks = min_raid_disks(mddev->new_level);
+	if (mddev->raid_disks < min_disks) {
 		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
 			mdname(mddev), mddev->raid_disks,
-			mddev->new_level == 6 ? 4 : 2);
+			min_disks);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
@@ -8608,17 +8613,13 @@ static int check_reshape(struct mddev *mddev)
 	if (!mddev->new_chunk_sectors)
 		return -EINVAL;
 	if (mddev->delta_disks < 0 && mddev->reshape_position == MaxSector) {
 		/* We might be able to shrink, but the devices must
 		 * be made bigger first.
-		 * For raid6, 4 is the minimum size.
-		 * Otherwise 2 is the minimum
 		 */
-		int min = 2;
-		if (mddev->level == 6)
-			min = 4;
-		if (mddev->raid_disks + mddev->delta_disks < min)
+		if (mddev->raid_disks + mddev->delta_disks <
+		    min_raid_disks(mddev->level))
 			return -EINVAL;
 	}
 
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
-- 
2.55.0
