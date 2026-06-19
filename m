Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330E8F49
	for <linux-raid@vger.kernel.org>; Fri, 19 Jun 2026 06:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852177; cv=none; b=sgEujhUwthxMS2sbeHbYwbvi9a8iZWD6Y2xN1m/PgODl7cNe2K+g78LDEuBZeecVBja+hetDaw9N1JiGtMVEfgNQDCtE+hRgtQDdWKi/IUPvisICqdP9BugHBJjQmzA3nX6mnQQcxynw1SPR/3afFHcT241NSvcnuuKf2ON0ULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852177; c=relaxed/simple;
	bh=aeyEQFhTJX0Af8HLBqaVU59isbGRqMZyAOIk1MAhNC0=;
	h=Subject:Content-Type:To:Message-Id:From:Mime-Version:Cc:Date; b=RIV/bULnaBJvQUsIvuOIASLogC/BDU9EkUDi7hF5sG0jvWNBCooZV+n3m7igflT0ekYAYVq/vaHsZfLcwIBgnc/WJSSW26WUWjSlY6ejBB8+h4/MnDiiUkwZxt8AJYJrMarODWWvJQdCL2BXEqTtlG8FZYMferdngQq8wTAxq3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=wBpn9pDV; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="wBpn9pDV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781852166;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WtqCo1xIxTblDVR/7DccpKvotTRDS8uX3Gl+/w20Z0o=;
 b=wBpn9pDVxsrpGDRoi6IE+tXUX7xj6cAS2Oru8rXypdofm++KR+fhMfvOaqV2ZaZxYS10Ue
 1YgJzrV2TPOfpZZbLHxm3A5YWN0H3XQ7eqAQdT2u/zlRbsOjhfFQOKlr6DFsqf82aYnfYv
 WnFb90i4dyHeaTdGSkRyLPXvXJZJeEbAgyzgMqfvrlb/cg1L4526fvvRI5/y/bwC2sZoO6
 6xD7c/tlq+dTRgsUz+s6p7dDixJ5wmwhlKyIrgYfeRs7M+oqqzFzVlwVvPqgsYJmbkS/WO
 TqD2LKsyKkwIs7uDjDTW5L9++QAtnbvHRtpS5W+NGdXXci3wzHCgpbAC8XMjOg==
Subject: [PATCH] md/raid5: read batch_head under stripe_lock in make_stripe_request
X-Lms-Return-Path: <lba+26a34e804+3d80ae+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Message-Id: <20260619065551.1214690-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
From: "Chen Cheng" <chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.170.142]) by smtp.feishu.cn with ESMTPS; Fri, 19 Jun 2026 14:56:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Fri, 19 Jun 2026 14:55:51 +0800

From: Chen Cheng <chencheng@fnnas.com>

KCSAN reports race in raid5_make_request() vs. stripe_add_to_batch_list()

write: sh->batch_head = head->batch_head / head
       in stripe_add_to_batch_list() via make_stripe_request()
read:  (!sh->batch_head || sh == sh->batch_head)
       in make_stripe_request()
variable: struct stripe_head::batch_head

sh->batch_head is documented as protected by stripe_lock.

KCSAN report:
  BUG: KCSAN: data-race in raid5_make_request / raid5_make_request

  write to 0xffff8f03062432d8 of 8 bytes by task 210246 on cpu 6:
    raid5_make_request+0x175e/0x2ab0
    md_handle_request+0x2c5/0x700
    md_submit_bio+0x126/0x320
    [.........]
    btrfs_sync_file+0x181/0x970
    vfs_fsync_range+0x71/0x110
    do_fsync+0x46/0xa0
    __x64_sys_fsync+0x20/0x30

  read to 0xffff8f03062432d8 of 8 bytes by task 210251 on cpu 0:
    raid5_make_request+0x7c7/0x2ab0
    md_handle_request+0x2c5/0x700
    md_submit_bio+0x126/0x320
    [.........]
    btrfs_remap_file_range+0x266/0x980
    vfs_clone_file_range+0x16d/0x610
    ioctl_file_clone+0x64/0xd0
    do_vfs_ioctl+0x87f/0xbc0
    __x64_sys_ioctl+0xb8/0x130

  value changed: 0x0000000000000000 -> 0xffff8f0307798728

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5521051a9425..efc63740f867 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6108,14 +6108,16 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 		ctx->do_flush = false;
 	}
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
+	spin_lock_irq(&sh->stripe_lock);
 	if ((!sh->batch_head || sh == sh->batch_head) &&
 	    (bi->bi_opf & REQ_SYNC) &&
 	    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 		atomic_inc(&conf->preread_active_stripes);
+	spin_unlock_irq(&sh->stripe_lock);
 
 	release_stripe_plug(mddev, sh);
 	return STRIPE_SUCCESS;
 
 out_release:
-- 
2.54.0
