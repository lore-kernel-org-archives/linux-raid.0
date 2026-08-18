Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66D175A74
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036834; cv=none; b=nE//XTfA30t7cuMAw0lGQUUa79NXlBce8y9HksM+cvS7rsQtmR0SxQ914RzZTt/YJNZgpXMwspKigunLvIfAoNIB3mJPvfIDEW/rKsFPSL1n7eOc8C0d2Fw/3gomG0/qHN9PmRviBdA8l4sCPSQE6JOUGiRqywXPv/LzWXBs7Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036834; c=relaxed/simple;
	bh=0bg/lByf+5Kj7BlZSA8bQ8x+MhSXaW87xNlm8QSGLR0=;
	h=To:From:Message-Id:References:Cc:Subject:Date:Mime-Version:
	 In-Reply-To:Content-Type; b=a6asR+hd9Ib/EV1goWfyN95hA1JoCnO/NJuycWd5I22gBGuXfsHizX5Daf51tfKkWISw579PylwkfzHj821BNm9dOalndeYy6EiNRSYsRnBI/JRsvy75BSTxmK3VqTd5CZotuXZzAG2NinlYW5j30ZnyiI0BDH4k2a/5gU4EKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=lrNpfNWv; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="lrNpfNWv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036822;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=mEIJhFo42Is1jlZz91hZNN1RltsJcbPXgmbj+a6kffU=;
 b=lrNpfNWvWoMhF58qS6O6syI4un+H+RraW9Bxub5AsAuXHiyXdFFZdKlQuVJEmFhgRk1AqR
 LZBp/I+SEODbxRLKPWH3ilYxm1fmPLdJNdwzUYK9DDkYBUWwSUtJxWotgkGSZjwJu215kU
 tqMt02wzaGzwM0r5AoniRnLL7+F4TYWLHAdTNYgqy0IKT63gBUbxQg6J8FEIOvz9lMkEgS
 IEr858iyUGUG0nYz8BfK2/CgW/302iGdTchnTZKUAi63VAqWw2nSsYV5xIhNwDdBwk7zXT
 jvp5FLkGTApIpYuBDZh/w8qMa+T+oNsSUee41CYgqw7KKFe7Qjg8aMpyEJCA+A==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260818070646.1029149-2-chencheng@fnnas.com>
References: <20260818070646.1029149-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a840494+f17566+vger.kernel.org+chencheng@fnnas.com>
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:06:59 +0800
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.55.0
X-Original-From: chencheng@fnnas.com
Subject: [RFC PATCH 1/5] md/raid1: balance reads across non-rotational disks
Date: Tue, 18 Aug 2026 15:06:42 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260818070646.1029149-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

choose_best_rdev() picks one disk for each read.
min_pending is UINT_MAX; store it as unsigned int, like raid10.

Current:
1. Sequential read: stay on the current disk.
2. Switch only if should_choose_next() is true.
3. should_choose_next() needs bdev_io_opt() > 0.
4. Non-sequential read: pick the disk with the lowest nr_pending.
5. The compare uses strict '>'. Same pending keeps the first disk.

Problem:
1. Many client NVMe set optimal_io_size to 0. Then
   should_choose_next() never runs. One sequential stream stays on
   one disk. Why not use the idle disk?
2. Same for rot-only RAID1. One rot disk takes the whole stream.
   The other rot disk is idle. Why not use it?
3. Low-depth random reads often have the same pending. Why always
   stay on slot 0?

Improve:
1. If a sequential disk already has pending I/O, do not return it
   at once. Let pending pick an idle disk.
2. On nonrot arrays, if pending is the same, rotate a start slot
   (0..raid_disks-1).
3. Only bump read_rr when the array has a nonrot member.

Tested with fio libaio direct=1 (NVMe scheduler none, SATA
scheduler mq-deadline):

- 2x Predator GM9000 (optimal_io_size=0):
  a) 4k randread QD1 jobs=1: 0.084 GB/s, 100/0 -> 0.084 GB/s, 50/50
  b) 1M read QD16 jobs=1: 7.031 -> 13.886 GB/s (+97%), 66/34 -> 50/50
  c) 1M read QD16 jobs=2: 14.22 GB/s, 50/50 both sides

- 4x Intel MEMPEK1J016GA (Optane pmem, optimal_io_size=0):
  1M read QD16 jobs=1: ~0.85 GB/s on one member -> ~3.0+ GB/s,
  ~25% per disk

- RAID1 of two then three TOSHIBA HDWG740:
  2 disks, 1M read QD16 jobs=1: 0.294 GB/s, 100/0 -> 0.514 GB/s, 50/50
  3 disks, 1M read QD16 jobs=1: 0.294 GB/s, 100/0 -> 0.630 GB/s, 33/33/33
  2 and 3 disks, 4k randread QD1 jobs=1: 0.001 GB/s, all on
  one disk (rot-only random does not use read_rr)

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 25 +++++++++++++++++++++----
 drivers/md/raid1.h |  1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..319b24bcab5b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -780,27 +780,38 @@ static bool rdev_readable(struct md_rdev *rdev, struct r1bio *r1_bio)
 }
 
 struct read_balance_ctl {
 	sector_t closest_dist;
 	int closest_dist_disk;
-	int min_pending;
+	unsigned int min_pending;
 	int min_pending_disk;
 	int sequential_disk;
 	int readable_disks;
 };
 
+static int raid1_rr_pos(int disk, int start, int n)
+{
+	return ((disk % n) - start + n) % n;
+}
+
 static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int disk;
+	int rr_start = 0;
+	bool has_nonrot = READ_ONCE(conf->nonrot_disks);
 	struct read_balance_ctl ctl = {
 		.closest_dist_disk      = -1,
 		.closest_dist           = MaxSector,
 		.min_pending_disk       = -1,
 		.min_pending            = UINT_MAX,
 		.sequential_disk	= -1,
 	};
 
+	if (has_nonrot)
+		rr_start = (unsigned int)atomic_inc_return(&conf->read_rr) %
+			   conf->raid_disks;
+
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		struct md_rdev *rdev;
 		sector_t dist;
 		unsigned int pending;
 
@@ -819,11 +830,11 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 		dist = abs(r1_bio->sector -
 			   READ_ONCE(conf->mirrors[disk].head_position));
 
 		/* Don't change to another disk for sequential reads */
 		if (is_sequential(conf, disk, r1_bio)) {
-			if (!should_choose_next(conf, disk))
+			if (!should_choose_next(conf, disk) && !pending)
 				return disk;
 
 			/*
 			 * Add 'pending' to avoid choosing this disk if
 			 * there is other idle disk.
@@ -834,11 +845,16 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			 * will be chosen.
 			 */
 			ctl.sequential_disk = disk;
 		}
 
-		if (ctl.min_pending > pending) {
+		if (ctl.min_pending > pending ||
+		    (has_nonrot && ctl.min_pending == pending &&
+		     ctl.min_pending_disk >= 0 &&
+		     raid1_rr_pos(disk, rr_start, conf->raid_disks) <
+		     raid1_rr_pos(ctl.min_pending_disk, rr_start,
+				  conf->raid_disks))) {
 			ctl.min_pending = pending;
 			ctl.min_pending_disk = disk;
 		}
 
 		if (ctl.closest_dist > dist) {
@@ -859,11 +875,11 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 	 * non-rotational, choose the disk with less pending request even the
 	 * disk is rotational, which might/might not be optimal for raids with
 	 * mixed ratation/non-rotational disks depending on workload.
 	 */
 	if (ctl.min_pending_disk != -1 &&
-	    (READ_ONCE(conf->nonrot_disks) || ctl.min_pending == 0))
+	    (has_nonrot || ctl.min_pending == 0))
 		return ctl.min_pending_disk;
 	else
 		return ctl.closest_dist_disk;
 }
 
@@ -3091,10 +3107,11 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		goto abort;
 
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	conf->raid_disks = mddev->raid_disks;
+	atomic_set(&conf->read_rr, -1);
 	rdev_for_each(rdev, mddev) {
 		int disk_idx = rdev->raid_disk;
 
 		if (disk_idx >= conf->raid_disks || disk_idx < 0)
 			continue;
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c98d43a7ae99..d5de976d171d 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -54,10 +54,11 @@ struct r1conf {
 	struct raid1_info	*mirrors;	/* twice 'raid_disks' to
 						 * allow for replacements.
 						 */
 	int			raid_disks;
 	int			nonrot_disks;
+	atomic_t		read_rr;
 
 	spinlock_t		device_lock;
 
 	/* list of 'struct r1bio' that need to be processed by raid1d,
 	 * whether to retry a read, writeout a resync or recovery
-- 
2.55.0
