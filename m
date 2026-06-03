Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E463264E3
	for <linux-raid@vger.kernel.org>; Wed,  3 Jun 2026 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780477519; cv=none; b=MkPRo+EGIn0YhJ9hV3v2jlwf6VDuYQ6vW59klylF70kcQB55G+SHC9zwSUOQh3QiFut24WJFMz+atvwFaQEvAtzaJA4q/MtD7A0wwENhcCsiw0kM8Sc8N9hmYrKWAYrUcGq9Nm53JwLBA/jVsXOefuqqSQoWH/ecCsecmOg0Y7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780477519; c=relaxed/simple;
	bh=l83AyYuNWQp2v/m+SUakUZW3/hLsg89+ERbimKZFtrk=;
	h=From:Subject:Date:Mime-Version:Cc:Message-Id:Content-Type:To; b=naTH9T+K1CpfeOuQ+pEerJdod18HSz0GfAERiflkjRyhCYfZIzFZi5fc5CVcRTx1nn13v6qaCRc0bF96379bqIG322JpEBXCj2CwdoDfJMKzh3Q+IdMCKE1z7oBLKhNZOn8AD/lhL3282lpqo+5AHKPzjqLiUXhxQaA9eIqnXIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=sMEQSdiI; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="sMEQSdiI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780477511;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QTFvF3smdJoa0pcjRJWzp0ACpHtCEL9BU78ruAvG3O4=;
 b=sMEQSdiIhuZQAgbheqzm9BXEL0vEEZ5TBwGJZDi0vV6EIJvkyZq6WtFasWWhYz5qb2alsj
 aPmhSDBTCTWONY6XnrqFJHcS+7EJaf5YUld/8zr+Nh+NKgWG4RnkMINk7ZmGSu8vwk4QNj
 t1d1IP1NPFkRLSB3T9pjVZFu6/nM0dC0i663rjtZPVbFI2o1ZmAr+jvHKpOTM1/JzkHin3
 VdeaHw6JvMG2SAPi+t7gZR7vgkVN5QPdfyzi1GV9BIviOddewG6Tlk4WjVOLjuhNI8RI16
 hdnq/f8K20RFdgNptGAz/GlypE04Jcsh204h76srh2PVB+kzzs+Lk86iOrKYRg==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid5: fix stripe_request_ctx bitmap sizing for unaligned bios
Date: Wed,  3 Jun 2026 17:04:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a1fee45+bed437+vger.kernel.org+chencheng@fnnas.com>
Message-Id: <20260603090457.638223-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 17:05:08 +0800

From: Chen Cheng <chencheng@fnnas.com>

stripe_request_ctx.sectors_to_do needs one extra bit for unaligned bios,
as documented by the existing comment.

raid5_make_request() rounds the bio start down to a stripe boundary, but
keeps ctx->last_sector at bio_end_sector(bio). As a result, an unaligned
bio with len == max_hw_sectors can span one more stripe than
max_hw_sectors >> RAID5_STRIPE_SHIFT(conf).

For example, if RAID5_STRIPE_SECTORS(conf) == 8 and max_hw_sectors ==
2048, a bio at sector 1 with len 2048 sectors yields stripe_cnt = 257.
bitmap_set(ctx->sectors_to_do, 0, 257) then touches the first bit beyond
a 256-bit allocation, matching the KASAN report:

  __bitmap_set
  bitmap_set
  raid5_make_request

Restore the missing extra bit in both ctx_pool sizing paths.

This bug is harder to reproduce from userspace on v7.1 because
lim.chunk_sectors = lim.io_opt >> 9 causes the block layer to split
large unaligned bios on full-stripe boundaries before they reach
raid5_make_request(). That masks the reproducer, but does not fix the
under-allocation.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 65ae7d8930fc..9ece79e608f7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7756,15 +7756,15 @@ static int raid5_create_ctx_pool(struct r5conf *conf)
 {
 	struct stripe_request_ctx *ctx;
 	int size;
 
 	if (mddev_is_dm(conf->mddev))
-		size = BITS_TO_LONGS(RAID5_MAX_REQ_STRIPES);
+		size = BITS_TO_LONGS(RAID5_MAX_REQ_STRIPES + 1);
 	else
 		size = BITS_TO_LONGS(
-			queue_max_hw_sectors(conf->mddev->gendisk->queue) >>
-			RAID5_STRIPE_SHIFT(conf));
+			(queue_max_hw_sectors(conf->mddev->gendisk->queue) >>
+			 RAID5_STRIPE_SHIFT(conf)) + 1);
 
 	conf->ctx_size = struct_size(ctx, sectors_to_do, size);
 	conf->ctx_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
 						     conf->ctx_size);
 
-- 
2.54.0
