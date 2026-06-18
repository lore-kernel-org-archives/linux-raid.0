Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25242D6E6C
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 02:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781751153; cv=none; b=mLqzriquQRqREcGTXamADJSBZjvzp9QZqiwkx4K9ZTHJLw2Bpc/nOhUNwHQZU2gy9YSJPVbJ+9mib60yaDuoh+OnaT+51JIhLWSSL8Bd6JsFTthXgHFq9oZQ4JjoetOagrSuAZWz51CtXLuS5FLjq+zXwU5VeBNAAG/g7+Vpv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781751153; c=relaxed/simple;
	bh=VHqvsp8G1nMcOMWTVIDi4lS3lA9NMyEa4HFN+AAPbwM=;
	h=Mime-Version:Message-Id:Content-Type:To:From:Subject:Date:Cc; b=kjxQHm5Xb9lOEwT4SFtAGooi3dyaqEiQHf7JLUcgbhmajgxOFllG+iMD6/I99IZQl5r/opXz7ZpTFAa/wvL5L6fP0+KdVeo+SgZA4msmcy397jml9pnKetRfVvlCnQUzDkaBTIP5VsJaA7sdFJE9Djd1FD4vcyQUaELoK9Rg3ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mxFiP1qV; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mxFiP1qV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781751140;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JLZRupcfZdv/bCO5Hj3SXoglCL/TZUk1CK/JEE0Srfc=;
 b=mxFiP1qV9lL+n/C9+XeD9dqYt1uFs+ImY0cnF6RJOPwIrBWweUTo73zfbnA+DHWNBpvYnY
 B4wCxK6GqxiFv9Nu2x+hCGz40TPbTYPCJYSkD/SCOU1VtdqKwH85xmyST7iDYAyH8Q08wB
 LEaJ6h9dpMBKYwYbKl3GSwWZ/6H4A7PeAVcG/fjbdGToxewtz3STZDDXhfaTJTKXP6kSc/
 lbeeRfWi7RnwbFIKO+kkg5fRZ9pJNId5Qs789arkIwf8J4+TBzt8x6ld+aJruihQPNrWhi
 4T3cVNC7U5a/h3fVsI6T+Aw0rqtQTPfK8tb8OOHa8OK/GWJIbRlqcMNXr66YQg==
X-Lms-Return-Path: <lba+26a335d62+95bfc5+vger.kernel.org+chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <20260618025206.906035-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/raid10: protect head_position accesses consistency
Date: Thu, 18 Jun 2026 10:52:06 +0800
Received: from localhost.localdomain ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 10:52:17 +0800
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>, 
	<linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 2.54.0

From: Chen Cheng <chencheng@fnnas.com>

the completion paths update conf->mirrors[x].head_position
without a lock, while read_balance() reads the same field
locklessly.

protect conf->mirror[x].head_position consistency for
multi-CPUs by READ_ONCE()/WRITE_ONCE().

the report #1:
=====================
 BUG: KCSAN: data-race in find_bio_disk.isra.0 / read_balance

 write to 0xffff8f0309679fd0 of 8 bytes by interrupt on cpu 9:
  find_bio_disk.isra.0+0x108/0x180
  raid10_end_write_request+0xd2/0x530
  bio_endio+0x3c9/0x3e0
 [...]

 read to 0xffff8f0309679fd0 of 8 bytes by task 338766 on cpu 7:
  read_balance+0x2ec/0x700
  raid10_read_request+0x17b/0x550
  raid10_make_request+0x27e/0x1080
  md_handle_request+0x2c5/0x700
  [...]

 value changed: 0x000000000032f440 -> 0x000000000014f8e0

the report #2:
=======================
 BUG: KCSAN: data-race in raid10_end_read_request / read_balance

 write to 0xffff8f03291091b0 of 8 bytes by interrupt on cpu 9:
  raid10_end_read_request+0xf0/0x400
  bio_endio+0x3c9/0x3e0
  [...]

 read to 0xffff8f03291091b0 of 8 bytes by task 336943 on cpu 8:
  read_balance+0x2ec/0x700
  raid10_read_request+0x17b/0x550
  raid10_make_request+0x27e/0x1080
  md_handle_request+0x2c5/0x700
 [...]

 value changed: 0x000000000041c188 -> 0x000000000041c1b8

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index caf1da15aa87..55aa052a957b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -343,12 +343,12 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
  */
 static inline void update_head_pos(int slot, struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
 
-	conf->mirrors[r10_bio->devs[slot].devnum].head_position =
-		r10_bio->devs[slot].addr + (r10_bio->sectors);
+	WRITE_ONCE(conf->mirrors[r10_bio->devs[slot].devnum].head_position,
+		   r10_bio->devs[slot].addr + (r10_bio->sectors));
 }
 
 /*
  * Find the disk number which triggered given bio
  */
@@ -841,11 +841,11 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 		/* for far > 1 always use the lowest address */
 		else if (geo->far_copies > 1)
 			new_distance = r10_bio->devs[slot].addr;
 		else
 			new_distance = abs(r10_bio->devs[slot].addr -
-					   conf->mirrors[disk].head_position);
+					   READ_ONCE(conf->mirrors[disk].head_position));
 
 		if (new_distance < best_dist) {
 			best_dist = new_distance;
 			best_dist_slot = slot;
 			best_dist_rdev = rdev;
-- 
2.54.0
