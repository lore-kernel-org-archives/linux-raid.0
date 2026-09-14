Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A88443E38
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 12:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388296; cv=none; b=OAY+1eHM3eqtirn2E6o4Bi9PVG8E0mWzMdkbhxe0iumiTNqaeKp4RR241O6M2OF8GNKmBYVMsmHYmTXp23BMKjE0Cw2U7kiwqCy4M7FLvhhrfHCVVUOdxhqCmfGdYh89SxW4zXldDi14faYXXJvnGuMjKyEVaJDZSv8V/vzuou8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388296; c=relaxed/simple;
	bh=iPWmuuWWN46rm/34V008espnd6sdzL0kZqgwfppqYN0=;
	h=Cc:Content-Type:To:Subject:From:Date:Message-Id:In-Reply-To:
	 Mime-Version:References; b=IAjS8B9TeitajQhG0Nq2FasWL4hjBYpWtpnJ4PdSoUE+HycxvZe44Z2v03V/FHXuNnpbJAgKTubbYFCHGlUvtwtpMyeIDARKHHJKYZFRR90zZLY6VFm6T5kHufnYE+2/ub0gmKowIRHaoeEFu1bWeX5Wh9BreWKWH/4x6PPcMHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DRcTN459; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DRcTN459"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789388282;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uZslS5NlIIWsH2nl/2FSkNsZ6lOa0rNE9WaU0b70Q4E=;
 b=DRcTN459kxMEB9289Bm9G2myS3nC+HkxSJH90WP2vo8fhNNQ/qL7QaSqifOK9vcu1q2oEJ
 wO7ncnP1p+oP1a9YxDCslROCeoZXRwLA/zQXa8HI4tr0tfOXKMY6mDL4n4q1w37ndTe4og
 GkDIIgDASckrRnKfa9Y1UvFvgi9E/scPxCZpWsUdGr1pfAlb+KfiSiLPa/D74J9WkZkiLR
 iV6GbXuWsPu2z6jc1oSTusUN3bOBdoG965eZU3OgrNlP7eWSqtJA1uCrqHhGhLKBZSZKN3
 Esm2eQ0lc+3TR8yS1r/UPyXZeVO4kKo4CI/OlBp2n6Dq6Nk7OUezTLWAmQJkxA==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <nixiao@fygo.io>
Subject: [PATCH v1 1/2] md/raid5: extract min_raid_disks()
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26aa7e5f8+971af5+vger.kernel.org+chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Mon, 14 Sep 2026 20:17:46 +0800
Message-Id: <f79037a8c7cceafab6a6d372bc2bc7810de8653f.1789387793.git.chencheng@fnnas.com>
In-Reply-To: <cover.1789387793.git.chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0
References: <cover.1789387793.git.chencheng@fnnas.com>
Received: from fedora ([183.34.164.60]) by smtp.feishu.cn with ESMTPS; Mon, 14 Sep 2026 20:17:59 +0800

From: Chen Cheng <chencheng@fnnas.com>

Reuse the minimum disk count in setup_conf() and check_reshape().

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e1f20035703b..4ab31af34b9f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7628,14 +7628,19 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
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
@@ -7655,15 +7660,15 @@ static struct r5conf *setup_conf(struct mddev *mddev)
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
@@ -8600,17 +8605,13 @@ static int check_reshape(struct mddev *mddev)
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
