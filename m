Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C1D386561
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036859; cv=none; b=Q6UUF+T0ZA8rmBLtLLbSdCnTG+g+trIvZFY0gZZwZnX3x+zZ8OSxtxd67NcTQw3g7mUmhOrUmXoQZm3aNXPb9zHNh4pSGh0d8Ku+f3regnu/mUy+tZuuY7YyTLHXEMwVcGy9ymESwdut6pu32uiwtFibSW3KBkulNhsVVtJoFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036859; c=relaxed/simple;
	bh=H9TJEGBnS2ZQozieVZAAkazrp0X0uS816ZTO/8oVRAU=;
	h=Date:Mime-Version:From:In-Reply-To:To:Subject:Message-Id:
	 References:Content-Type:Cc; b=pz7CeAUimiUXPLjcg2f+KDWxlcV4YJ6ZEzQ/n3F0dV3iLtl3OZTv8tgQUkS2SMkjRb9xoJmEHVfpKYLKPNYU7kS7X8bL5Mz7Uax5G6woue+kvlxWC19XjE+lg9LOMh104Z9WkCDQHeLctBbWVJltzb72pR1+kTE3Fm/JN6vlncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=weHVofHY; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="weHVofHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036831;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2iU1ricYfNDrpH6ArL1TkZe8uhXQBTjWWpyRZXWnbi8=;
 b=weHVofHYrOm3+gOKll17Z8r4KolXGm3YeF+Km3a5V6c0xceNTdnsy8g/mOOhN5nEebYHFh
 sirnJF6bODtABGtD39y4S5FwxpdxAvWKE5ACyc8WYOnqun98jHIryjUjSa3oTatl+ClDDV
 n9ypTIEDAL8pCy5ZdFwjEMp7DtX9b5ddPE6Wnva2UFnPzOv0KzeqGbvIiIB/6U5WRLn7EL
 Oc/l+fNpq898fQFn2woKxkgCFEu02kQyDvFqG0veCQ/T5iyklrv6zC0ccEOPXlQ6XZanbr
 wnD8cQXuRBptLxONlC0fPpp5grNliq9gNjtUPev4vtfn9zcxE3YGZJ9jFUNhiw==
Date: Tue, 18 Aug 2026 15:06:46 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0
X-Original-From: chencheng@fnnas.com
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:07:09 +0800
From: "Chen Cheng" <chencheng@fnnas.com>
In-Reply-To: <20260818070646.1029149-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a84049e+5cbb75+vger.kernel.org+chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
Subject: [RFC PATCH 5/5] md/raid1: clarify choose_best_rdev comments
Message-Id: <20260818070646.1029149-6-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
References: <20260818070646.1029149-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>

From: Chen Cheng <chencheng@fnnas.com>

Write the rot/nonrot read policy in short comments next to the code.

No functional change.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 48 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f476d4dea4be..897eef3a022d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -788,15 +788,17 @@ struct read_balance_ctl {
 	int readable_disks;
 	bool min_pending_nonrot;
 	bool sequential_nonrot;
 };
 
+/* Offset from rr start. Replacement uses the same slot as primary. */
 static int raid1_rr_pos(int disk, int start, int n)
 {
 	return ((disk % n) - start + n) % n;
 }
 
+/* True if some readable member is nonrot. */
 static bool raid1_has_readable_nonrot(struct r1conf *conf,
 				      struct r1bio *r1_bio)
 {
 	int disk;
 
@@ -811,10 +813,11 @@ static bool raid1_has_readable_nonrot(struct r1conf *conf,
 			return true;
 	}
 	return false;
 }
 
+/* Lower pending wins. Same pending: prefer nonrot, then rr order. */
 static bool is_better_disk(unsigned int pending, int disk, bool nonrot,
 			   const struct read_balance_ctl *ctl,
 			   int rr_start, int n)
 {
 	if (ctl->min_pending_disk < 0)
@@ -828,10 +831,24 @@ static bool is_better_disk(unsigned int pending, int disk, bool nonrot,
 	return nonrot && ctl->min_pending_nonrot &&
 	       raid1_rr_pos(disk, rr_start, n) <
 	       raid1_rr_pos(ctl->min_pending_disk, rr_start, n);
 }
 
+/*
+ * Choose a readable disk for this read.
+ *
+ * Prefer nonrot. Use rot only if no nonrot disk is readable.
+ *
+ * Sequential idle: keep this disk. Mixed array: do not keep a
+ * rot disk (after a write every disk looks sequential).
+ * Sequential busy: try an idle disk of the same class. If none
+ * is idle, keep the sequential disk.
+ *
+ * Else fewest pending I/Os among disks we may pick. Same
+ * pending: nonrot, then round-robin. Rot-only with no idle
+ * disk: closest head.
+ */
 static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int disk;
 	int rr_start = 0;
 	bool has_nonrot = raid1_has_readable_nonrot(conf, r1_bio);
@@ -867,26 +884,32 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(r1_bio->sector -
 			   READ_ONCE(conf->mirrors[disk].head_position));
 		nonrot = test_bit(Nonrot, &rdev->flags);
+		/*
+		 * If a nonrot disk is readable, pick only nonrot.
+		 * Else we must use rot.
+		 */
 		can_pick = nonrot || !has_nonrot;
 
-		/* Don't change to another disk for sequential reads */
+		/*
+		 * Idle sequential disk: return it now, unless
+		 * should_choose_next() wants another disk.
+		 * Mixed array: do not return a rot disk.
+		 */
 		if (is_sequential(conf, disk, r1_bio)) {
 			if (!should_choose_next(conf, disk) && !pending &&
 			    can_pick)
 				return disk;
 
-			/*
-			 * Add 'pending' to avoid choosing this disk if
-			 * there is other idle disk.
-			 */
+			/* Make an idle disk win over this busy one. */
 			pending++;
 			/*
-			 * If there is no other idle disk, this disk
-			 * will be chosen.
+			 * Remember the first sequential disk.
+			 * A nonrot disk may replace a rot disk.
+			 * A later nonrot disk may not replace an earlier one.
 			 */
 			if (ctl.sequential_disk < 0 ||
 			    (nonrot && !ctl.sequential_nonrot)) {
 				ctl.sequential_disk = disk;
 				ctl.sequential_nonrot = nonrot;
@@ -906,22 +929,21 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			ctl.closest_dist_disk = disk;
 		}
 	}
 
 	/*
-	 * sequential IO size exceeds optimal iosize, however, there is no other
-	 * idle disk, so choose the sequential disk.
+	 * Keep the sequential disk if no idle peer should take it.
+	 * If a nonrot disk is readable: keep only a nonrot sequential disk.
+	 * If not: an idle rot disk may take it.
 	 */
 	if (ctl.sequential_disk != -1 && ctl.min_pending != 0 &&
 	    (ctl.sequential_nonrot || !has_nonrot))
 		return ctl.sequential_disk;
 
 	/*
-	 * If all disks are rotational, choose the closest disk. If any disk is
-	 * non-rotational, choose the disk with less pending request even the
-	 * disk is rotational, which might/might not be optimal for raids with
-	 * mixed ratation/non-rotational disks depending on workload.
+	 * No readable nonrot disk: closest disk, unless some disk is idle.
+	 * Some readable nonrot disk: that nonrot disk with fewest pending I/Os.
 	 */
 	if (ctl.min_pending_disk != -1 &&
 	    (has_nonrot || ctl.min_pending == 0))
 		return ctl.min_pending_disk;
 	else
-- 
2.55.0
