Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053AE1D63F0
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 08:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201607; cv=none; b=rHkud2eg7xLIHMFjjBld/cdUQBW1PjmInLOezYJsYQn60Nha+Pe52waf4ru1tAAbnUjpPrWS+gVjAenj97WGiqEb4Sf865WSPeO36ULw3tT+sdhHISh8NuhaS67VgXxpzh57urD7I5UsviRZPytXS+/F0hhpzZvT7V/3uBgY9S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201607; c=relaxed/simple;
	bh=5RIuw2MEHxSHGVcI5kUi/FL8Cbc9th4E1WezN8FfOes=;
	h=Subject:Cc:Date:Message-Id:Mime-Version:Content-Type:To:From; b=BZwdbXvI8RcfLKUB+4m4ibToJ1rKpRgXeN83h22Vp1EKLbKeBE7a3bBFmbQFhHhN2bHsiuADSC4yuUWPEGWwVReSjIBKPAtuBUJ+jjGp/InBSKFb89YSgh4RmZcjnwZ+gSpZtSpMG59uqJptZXuMCp8/Cpl6A7KOfonSIipmBhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=iJyJctB/; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="iJyJctB/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782201593;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TY24S4uu8LrOjylO1lyti0tMLPua4FxRHUW/K6E/Wbk=;
 b=iJyJctB/pmCGU/4yiWhk2ccmtFxFBcY8DAz7BUnGBmvcadjB4fW3ZJwa+PkazhXSk3qNJ5
 4Qqh6HZTE8YyKkW8lN/kHmeNBg6EWav1kZUntXGMxDp0XX92nzNOdsFkUVsi0vOvhVykZG
 5HmwlBfjQhspVkQyKx7U0/Y4cUFaU9Pu4ZJR/BvdcUVOfgXR2zb6M8jW1pG5F1Zo8QIJu3
 e+qOpPxVLUqwbeZsGW+jjCHOtHjFckBh4KPQTVddoJNx6uxNZnLzcjPd+GN+HVceKEehu1
 VVywCyRePysh/64kLrfLBzSWepqqroRaz3XiEvMnRjed+/AJl+x78KJhWwe/Zw==
Subject: [PATCH] md/raid1: protect sequential read hints for read balance
X-Original-From: chencheng@fnnas.com
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 23 Jun 2026 15:59:40 +0800
Message-Id: <20260623075940.2476255-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a3a3cf7+e0861c+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([183.34.170.156]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 15:59:50 +0800

From: Chen Cheng <chencheng@fnnas.com>

The patch just suppress KCSAN noise. No functional change.

KCSAN reports a race, point to update_read_sectors() update next_seq_sect vs.
read next_seq_sect.

Protect next_seq_sect and seq_start with READ_ONCE/WRITE_ONCE, otherwise,
read balance see stale sequential-read hints.

KCSAN report:
==============
 BUG: KCSAN: data-race in raid1_read_request / raid1_read_request

 write to 0xffff8e3a2d6736d0 of 8 bytes by task 593784 on cpu 10:
  raid1_read_request+0xe5a/0x19f0
  raid1_make_request+0xdf/0x1990
  md_handle_request+0x4a2/0xa40
  [...]

 read to 0xffff8e3a2d6736d0 of 8 bytes by task 593776 on cpu 11:
  raid1_read_request+0xe3f/0x19f0
  raid1_make_request+0xdf/0x1990
  md_handle_request+0x4a2/0xa40
  [...]

 value changed: 0x0000000000356368 -> 0x0000000000356370

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4cdf4484cab6..29b58583e381 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -602,13 +602,13 @@ static void update_read_sectors(struct r1conf *conf, int disk,
 				sector_t this_sector, int len)
 {
 	struct raid1_info *info = &conf->mirrors[disk];
 
 	atomic_inc(&info->rdev->nr_pending);
-	if (info->next_seq_sect != this_sector)
-		info->seq_start = this_sector;
-	info->next_seq_sect = this_sector + len;
+	if (READ_ONCE(info->next_seq_sect) != this_sector)
+		WRITE_ONCE(info->seq_start, this_sector);
+	WRITE_ONCE(info->next_seq_sect, this_sector + len);
 }
 
 static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 			     int *max_sectors)
 {
@@ -733,31 +733,33 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 	return bb_disk;
 }
 
 static bool is_sequential(struct r1conf *conf, int disk, struct r1bio *r1_bio)
 {
-	/* TODO: address issues with this check and concurrency. */
-	return conf->mirrors[disk].next_seq_sect == r1_bio->sector ||
+	return READ_ONCE(conf->mirrors[disk].next_seq_sect) == r1_bio->sector ||
 	       READ_ONCE(conf->mirrors[disk].head_position) == r1_bio->sector;
 }
 
 /*
  * If buffered sequential IO size exceeds optimal iosize, check if there is idle
  * disk. If yes, choose the idle disk.
  */
 static bool should_choose_next(struct r1conf *conf, int disk)
 {
 	struct raid1_info *mirror = &conf->mirrors[disk];
+	sector_t seq_start, next_seq_sect;
 	int opt_iosize;
 
 	if (!test_bit(Nonrot, &mirror->rdev->flags))
 		return false;
 
 	opt_iosize = bdev_io_opt(mirror->rdev->bdev) >> 9;
-	return opt_iosize > 0 && mirror->seq_start != MaxSector &&
-	       mirror->next_seq_sect > opt_iosize &&
-	       mirror->next_seq_sect - opt_iosize >= mirror->seq_start;
+	seq_start = READ_ONCE(mirror->seq_start);
+	next_seq_sect = READ_ONCE(mirror->next_seq_sect);
+	return opt_iosize > 0 && seq_start != MaxSector &&
+	       next_seq_sect > opt_iosize &&
+	       next_seq_sect - opt_iosize >= seq_start;
 }
 
 static bool rdev_readable(struct md_rdev *rdev, struct r1bio *r1_bio)
 {
 	if (!rdev || test_bit(Faulty, &rdev->flags))
-- 
2.54.0
