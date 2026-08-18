Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF016318ED9
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036839; cv=none; b=aQ0tSGB8aebagscpbVjQm2J6gacIDnnXRDRPXxew/FgtT/9Z24LhjkXepd95NodfoVdOceKP+9dzbOqOR6sCN22EQmYOV5oqTAM5T0L+S1wlr8JEc3nwk6VGzE26Fdpn2A2CcDzBhELrYQE1ukdPgNLcmgzTpqSQIGdGE2gmaUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036839; c=relaxed/simple;
	bh=rv1clD//d0xcZ23jWUinlP3+s//4g6cIpMryZigiW6o=;
	h=Mime-Version:From:Subject:To:Message-Id:In-Reply-To:Cc:Date:
	 Content-Type:References; b=uC/BX886JMoYQQYPraZe6nEkiWkikXzwRZrSzO65agHlpvUIEa4K4R+RMoQMdv85lXI7avpOSt/gxUmA7Jxo5Dr/WVDVnFix15zUvOmIHK/hPxkeoJBBxezbtRAr0DzPc+kJ/LnY1wCrIhcefifnogJ2wG47KyRuj8lYEHIQdIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AGi+N2N2; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AGi+N2N2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036827;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ORx37DHw0St0qaQz+AO1Fr6HnBPdlA9eDeBpBmIdWJA=;
 b=AGi+N2N2qFsa+7gJP1uM+jjtiDPWOOz63nbmxiICzZN+IKgfOJzllGKHRieyxMCXh6bco3
 Ob5jrSnsa6IWz0eEIiUbvzn5sUdZCenspVqF//CbGgPp/Mu0hGwB6Tsrhdx5UTmB7UKjMu
 N5oARy2Iy7Iw2vOWn5vKiAwQbds7vU4chtPeuJkchgABkNAGOI57PbM/86Hp/taYirp5Ol
 nEATAuDkfXBbFST27CcrZxLJ3urTsBt31ge6/3vC2Ux8kBLK21aFiRNjNuTncmtaVqP1gT
 1Uonbbw7er5BeR9PjqC8SSLqvpAzsW4bBVC8g4rUdWESAkg+J0GMnjVnoxRgiA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [RFC PATCH 3/5] md/raid1: do not send random reads to a rot disk
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:07:04 +0800
Message-Id: <20260818070646.1029149-4-chencheng@fnnas.com>
In-Reply-To: <20260818070646.1029149-1-chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 18 Aug 2026 15:06:44 +0800
X-Mailer: git-send-email 2.55.0
X-Lms-Return-Path: <lba+26a840499+600b75+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: chencheng@fnnas.com
References: <20260818070646.1029149-1-chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

The previous change keeps sequential nonrot I/O off a rot disk.

Current:
1. Sequential reads stay on nonrot when a nonrot disk is readable.
2. Random reads still pick the disk with the lowest nr_pending.
3. Rot disks also join that compare.

Problem:
1. A nonrot disk is fast. It can have more pending I/O.
2. A rot disk is slow. It can have fewer pending I/O.
3. Then the next random read goes to the rot disk.
4. Why send a random 4k read to the slow disk?

Improve:
1. If a nonrot disk is readable, do not use rot disks for
   min_pending.
2. Random reads stay on nonrot disks.
3. If no nonrot disk is readable, still pick a rot disk by head
   position.

Tested with fio libaio direct=1 (NVMe scheduler none, SATA
scheduler mq-deadline):

- RAID1 of Predator GM9000 + SATA HDD:
  4k randread QD1 jobs=1: 0.097 GB/s, 100/0 NVMe -> 0.084 GB/s,
    100/0 NVMe. Both disks have pending 0, so stock already stayed
    on NVMe.
  4k randread QD8 jobs=1: 0.363 GB/s, 99.6/0.4 NVMe/HDD,
    clat 87 us -> 0.671 GB/s, 100/0 NVMe, clat 46 us (-47%)
  4k randread QD16 jobs=1: 0.668 GB/s, 99.7/0.3 NVMe/HDD,
    clat 95 us -> 1.215 GB/s, 100/0 NVMe, clat 52 us (-45%)

- RAID1 of Fanxiang S103Pro + SATA HDD:
  4k randread QD1 jobs=1: 0.077 GB/s, 100/0 Fanxiang -> 0.073 GB/s,
    100/0 Fanxiang
  4k randread QD8 jobs=1: 0.278 GB/s, 99.5/0.5 Fanxiang/HDD,
    clat 114 us -> 0.389 GB/s, 100/0 Fanxiang, clat 78 us (-31%)
  4k randread QD16 jobs=1: 0.395 GB/s, 99.6/0.4 Fanxiang/HDD,
    clat 162 us -> 0.398 GB/s, 100/0 Fanxiang, clat 159 us
    (already at the Fanxiang limit)

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 36520e48826f..523b55d42779 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -832,10 +832,11 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		struct md_rdev *rdev;
 		sector_t dist;
 		unsigned int pending;
 		bool nonrot;
+		bool can_pick;
 
 		if (r1_bio->bios[disk] == IO_BLOCKED)
 			continue;
 
 		rdev = conf->mirrors[disk].rdev;
@@ -848,15 +849,16 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(r1_bio->sector -
 			   READ_ONCE(conf->mirrors[disk].head_position));
 		nonrot = test_bit(Nonrot, &rdev->flags);
+		can_pick = nonrot || !has_nonrot;
 
 		/* Don't change to another disk for sequential reads */
 		if (is_sequential(conf, disk, r1_bio)) {
 			if (!should_choose_next(conf, disk) && !pending &&
-			    (nonrot || !has_nonrot))
+			    can_pick)
 				return disk;
 
 			/*
 			 * Add 'pending' to avoid choosing this disk if
 			 * there is other idle disk.
@@ -871,11 +873,12 @@ static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 				ctl.sequential_disk = disk;
 				ctl.sequential_nonrot = nonrot;
 			}
 		}
 
-		if (is_better_disk(pending, disk, nonrot, &ctl,
+		if (can_pick &&
+		    is_better_disk(pending, disk, nonrot, &ctl,
 				   rr_start, conf->raid_disks)) {
 			ctl.min_pending = pending;
 			ctl.min_pending_disk = disk;
 			ctl.min_pending_nonrot = nonrot;
 		}
-- 
2.55.0
