Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6B64B048C
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036832; cv=none; b=GtyrfT38PhngZBA43DGX2dn2sOx4+86a3org1zWlPncByFNT7tZcoOa3s2m1rkFMpTktduJzyoyuRjLQjkhZbBJoR5BdF51s0PPqs0w81g+QEuGAf3C/wmFTl7k9n905LB0EG/YM+O3sE/vd9kjwucJUqY4Kkrxr9Ub98Nv1jKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036832; c=relaxed/simple;
	bh=u4kQwNTlDL8++Cn5rG+WarjmGr/E4g2luoFJylHo45w=;
	h=Content-Type:Date:References:Cc:Subject:Mime-Version:To:From:
	 Message-Id:In-Reply-To; b=AI94/TmqMCc9vbimxigei1AIYoctlbt9ckTL9hABZxQkpITJhBv/aZXmzcKtc+1MxoHF7WNyIf3/XTsW5GzeoTE7MYxDa59CXn5IuClxT/vETkoZyolFKXrl+TrsBCyrK0TkcCYNB7RfvdBloeFgGigmLwLE/jkkaH+bXZ5G/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=RtBOietZ; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="RtBOietZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036825;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=fUofpriDKKunrRStc3hcyDroS4uuxdeVc337dIz70K8=;
 b=RtBOietZrhPRO9bwCkaJqgrGwrjpPx4CgkDqaHYJb8l7duYdBoWKfIlxssNbuSB2QMqmfa
 S5oF+zbubbA1dZZ8ZkZ5ShDPVpcG6mb9atwIwylNhTCWacGL9aaQpZm1gl17x7/t2GF8nh
 S0ozdlViGaPFMk2HXBl7tSdSY0r9wXOw8wTiMKj9NuuIiUeA0BZofN5yogvJ5wTEszsHcp
 aiU32K9+GY8LVBXUVv5HvV1kSyidXfaknGwPvLU0aRpzO1C33PihWQfZwpyBY7mScKEolh
 XM5aRrueiTSeDTH2GZzbl4owQvfGsTntuQuRRHmC5uY7+NzE7FMlv6MZuDfpLA==
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 15:06:43 +0800
X-Mailer: git-send-email 2.55.0
X-Original-From: chencheng@fnnas.com
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:07:02 +0800
References: <20260818070646.1029149-1-chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/5] md/raid1: do not move nonrot reads onto a rot disk
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a840497+d2cb48+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <20260818070646.1029149-3-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260818070646.1029149-1-chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

The previous change: if a sequential disk already has pending I/O,
the next read can go to an idle disk.

Current:
1. A sequential disk can give the next read to an idle peer.
2. On a mixed array that peer can be a rot disk.
3. After a write, every disk has the same head_position.
4. Then every disk looks sequential.

Problem:
1. The first sequential disk in slot order may be a rot disk. Then
   we return it and never see the nonrot disk. We want the nonrot
   disk.
2. When pending is the same, rot and nonrot share one round-robin.
   A rot disk can win. We want the nonrot disk.

Improve:
1. If a nonrot disk is readable, do not stop on a sequential rot
   disk.
2. Remember sequential_disk once. A nonrot disk may replace a rot
   one.
3. If a nonrot disk is readable, do not keep a rot disk as the
   sequential fallback.
4. When pending is the same, prefer nonrot. Rotate only among
   nonrot disks.
5. Rot-only sequential reads still stay on the current disk when
   no peer is idle.

Tested with fio libaio direct=1 (NVMe scheduler none, SATA
scheduler mq-deadline), after a short write so both
head_positions match:

- RAID1 of Predator GM9000 + SATA HDD:
  1M read QD16 jobs=1, nonrot first:
    2.468 GB/s, 92/8 NVMe/HDD -> 7.112 GB/s, 100/0 NVMe
  1M read QD16 jobs=1, rot first:
    0.280 GB/s, 100/0 HDD -> 7.112 GB/s, 100/0 NVMe

- RAID1 of Fanxiang S103Pro + SATA HDD:
  1M read QD16 jobs=1, nonrot first:
    0.562 GB/s, 100/0 Fanxiang both sides
  1M read QD16 jobs=1, rot first:
    0.278 GB/s, 100/0 HDD -> 0.562 GB/s, 100/0 Fanxiang

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 319b24bcab5b..36520e48826f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -784,17 +784,36 @@ struct read_balance_ctl {
 	int closest_dist_disk;
 	unsigned int min_pending;
 	int min_pending_disk;
 	int sequential_disk;
 	int readable_disks;
+	bool min_pending_nonrot;
+	bool sequential_nonrot;
 };
 
 static int raid1_rr_pos(int disk, int start, int n)
 {
 	return ((disk % n) - start + n) % n;
 }
 
+static bool is_better_disk(unsigned int pending, int disk, bool nonrot,
+			   const struct read_balance_ctl *ctl,
+			   int rr_start, int n)
+{
+	if (ctl->min_pending_disk < 0)
+		return true;
+	if (ctl->min_pending < pending)
+		return false;
+	if (ctl->min_pending > pending)
+		return true;
+	if (nonrot && !ctl->min_pending_nonrot)
+		return true;
+	return nonrot && ctl->min_pending_nonrot &&
+	       raid1_rr_pos(disk, rr_start, n) <
+	       raid1_rr_pos(ctl->min_pending_disk, rr_start, n);
+}
+
 static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int disk;
 	int rr_start = 0;
 	bool has_nonrot = READ_ONCE(conf->nonrot_disks);
@@ -812,10 +831,11 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		struct md_rdev *rdev;
 		sector_t dist;
 		unsigned int pending;
+		bool nonrot;
 
 		if (r1_bio->bios[disk] == IO_BLOCKED)
 			continue;
 
 		rdev = conf->mirrors[disk].rdev;
@@ -827,14 +847,16 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			set_bit(R1BIO_FailFast, &r1_bio->state);
 
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(r1_bio->sector -
 			   READ_ONCE(conf->mirrors[disk].head_position));
+		nonrot = test_bit(Nonrot, &rdev->flags);
 
 		/* Don't change to another disk for sequential reads */
 		if (is_sequential(conf, disk, r1_bio)) {
-			if (!should_choose_next(conf, disk) && !pending)
+			if (!should_choose_next(conf, disk) && !pending &&
+			    (nonrot || !has_nonrot))
 				return disk;
 
 			/*
 			 * Add 'pending' to avoid choosing this disk if
 			 * there is other idle disk.
@@ -842,21 +864,22 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 			pending++;
 			/*
 			 * If there is no other idle disk, this disk
 			 * will be chosen.
 			 */
-			ctl.sequential_disk = disk;
+			if (ctl.sequential_disk < 0 ||
+			    (nonrot && !ctl.sequential_nonrot)) {
+				ctl.sequential_disk = disk;
+				ctl.sequential_nonrot = nonrot;
+			}
 		}
 
-		if (ctl.min_pending > pending ||
-		    (has_nonrot && ctl.min_pending == pending &&
-		     ctl.min_pending_disk >= 0 &&
-		     raid1_rr_pos(disk, rr_start, conf->raid_disks) <
-		     raid1_rr_pos(ctl.min_pending_disk, rr_start,
-				  conf->raid_disks))) {
+		if (is_better_disk(pending, disk, nonrot, &ctl,
+				   rr_start, conf->raid_disks)) {
 			ctl.min_pending = pending;
 			ctl.min_pending_disk = disk;
+			ctl.min_pending_nonrot = nonrot;
 		}
 
 		if (ctl.closest_dist > dist) {
 			ctl.closest_dist = dist;
 			ctl.closest_dist_disk = disk;
@@ -865,11 +888,12 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 
 	/*
 	 * sequential IO size exceeds optimal iosize, however, there is no other
 	 * idle disk, so choose the sequential disk.
 	 */
-	if (ctl.sequential_disk != -1 && ctl.min_pending != 0)
+	if (ctl.sequential_disk != -1 && ctl.min_pending != 0 &&
+	    (ctl.sequential_nonrot || !has_nonrot))
 		return ctl.sequential_disk;
 
 	/*
 	 * If all disks are rotational, choose the closest disk. If any disk is
 	 * non-rotational, choose the disk with less pending request even the
-- 
2.55.0
