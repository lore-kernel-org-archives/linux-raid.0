Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198263546F9
	for <linux-raid@vger.kernel.org>; Fri, 19 Jun 2026 08:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781856696; cv=none; b=ACRxE0vHrZZnaVYeLvwrxDbqRBdtNl81CpslzCULIO84hhL81fQduqtldD+rg4lELiDF5xM0tq8D0j4NG+WnPcTRx0KY4fYSC01BA542OGVq/rFKkaMVPqAM5+2AhfuedB3K8k5y3B0jCcY1sRVposicJVinAinhIYczAonPTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781856696; c=relaxed/simple;
	bh=BLvtpb1YTZMoA3xtjK/bwqQvNz8XUTTQKAMl9vVSei0=;
	h=Date:To:Cc:Subject:Message-Id:Mime-Version:From:Content-Type; b=lIsvo1n02f+yAXQLx6EdouQlxhMYsn2Y9fh05MBJvMYY81oDpApXU2AgiSkH3TLMOuxK2pxvezTVWZH6+PNyUyaCIyJnfpYywT3s8pHrNdZE/MzOkvm8yONkIB67hmtFTQp0k45QxZQX7Be2HbCC9b8UjC1ru1hBOkhs3cU8RSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Mm99XUHN; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Mm99XUHN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781856683;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jd5eiwHth56Gz2G1AVOwqO5GyIs4kQktcD1yChHHYWI=;
 b=Mm99XUHNaCRdMfgz4M81OIjrVt/R7VPmHTuxuSOPN/9gJdNuBs58LPR3ABUl+K/atsSG3E
 m1Brw1pXbEaVS292OmbnVYa+rjRYuuLNAEgJAg9kQ5gYkVXiRVheuAfWdldfkO7ZTiTSBU
 1YNhfl7a5vNEPfCwf9725xvg63jKjzU2kcW150D560RBEzrUEIBk4VGpBnvzY1h41nqNC1
 BiEFMgkyptEPsBrqALoTlcwEykkRYlPdnWF3TfX/IvjMKu0lRsqDTJLPNTv7+dOZiqwlY/
 Y3Z3BLFS7NTn0acMfW78/YOeRmXE+Af87hwPYaf/sbTmJ1MOydy90VFp0HitpA==
Date: Fri, 19 Jun 2026 16:11:09 +0800
X-Original-From: chencheng@fnnas.com
X-Mailer: git-send-email 2.54.0
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] md/raid5: read batch_head under stripe_lock in make_stripe_request
Message-Id: <20260619081109.1218112-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.170.142]) by smtp.feishu.cn with ESMTPS; Fri, 19 Jun 2026 16:11:20 +0800
X-Lms-Return-Path: <lba+26a34f9a9+17f2eb+vger.kernel.org+chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

KCSAN reports race in raid5_make_request() vs. stripe_add_to_batch_list()

Writer flow (stripe_add_to_batch_list):
1. grab `head` stripe;
2. lock_two_stripes(head, sh);
3. re-check stripe_can_batch() for both head and sh, which requires
   STRIPE_BATCH_READY set on both;
4. write head->batch_head = head and sh->batch_head = head;
5. unlock_two_stripes.

STRIPE_BATCH_READY is cleared in two places:
- clear_batch_ready(), at the entry of handle_stripe();
- __add_stripe_bio(), for non-batchable bios.
And, both need to acquire `stripe_lock`.

Under stripe_lock, if STRIPE_BATCH_READY is clear, then:
- New writers cannot install a batch_head;
- Existing writers have already finished.
So .. handle_stripe() readers can ready `batch_head` locklessly.

Fix way:
Writer side make_stripe_request() under STRIPE_BATCH_READY, so , need
to be protected by stripe_lock when read something..

v1 -> v2:
- re-expalin how stripe_lock and batch_head work in commit message , and ,
- modify comment in raid5.h.

Fixs: f4aec6a097387


KCSAN report:
======================================
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
 drivers/md/raid5.h | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

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
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1c7b710fc9c1..9ff825697ba3 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -221,11 +221,17 @@ struct stripe_head {
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
 
-	struct stripe_head	*batch_head; /* protected by stripe lock */
+	/*
+	 * Writer protected by stripe_lock.
+	 * Reader hold stripe_lock when STRIPE_BATCH_READY is set.
+	 * Without STRIPE_BATCH_READY means no concurrent write,
+	 * lockless read is ok.
+	 */
+	struct stripe_head	*batch_head;
 	spinlock_t		batch_lock; /* only header's lock is useful */
 	struct list_head	batch_list; /* protected by head's batch lock*/
 
 	union {
 		struct r5l_io_unit	*log_io;
-- 
2.54.0
