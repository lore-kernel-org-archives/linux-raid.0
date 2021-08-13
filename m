Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB167C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 06:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB63D6109D
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 06:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhHMGGQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 02:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbhHMGGQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Aug 2021 02:06:16 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FBEC061756
        for <linux-raid@vger.kernel.org>; Thu, 12 Aug 2021 23:05:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628834742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jt44+DCpNCkJ5sGOI0gyZ0k8KIlUKKzw3QWRRqY1c74=;
        b=TGuE1CkkemQt+Wo9uAe0cUNR5AxcUiGwE21X2rQaGJ0YbL20iPLAlz3iP0e3uvSAofDDdn
        lXchzpawe4vslJvwl+lzTfpF2KuqGR+Le2mtuYGp0uLHAVuaB3Xs4lJYdU9La1G+qLKD9N
        TD7+xDQ8cSRsRX19mKfFq3fKcPdEBYM=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, jens@chianterastutte.eu
Subject: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS sectors
Date:   Fri, 13 Aug 2021 14:05:10 +0800
Message-Id: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Guoqing Jiang <jiangguoqing@kylinos.cn>

We can't split bio with more than BIO_MAX_VECS sectors, otherwise the
below call trace was triggered because we could allocate oversized
write behind bio later.

[ 8.097936] bvec_alloc+0x90/0xc0
[ 8.098934] bio_alloc_bioset+0x1b3/0x260
[ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]
[ 8.100988] ? __bio_clone_fast+0xa8/0xe0
[ 8.102008] md_handle_request+0x158/0x1d0 [md_mod]
[ 8.103050] md_submit_bio+0xcd/0x110 [md_mod]
[ 8.104084] submit_bio_noacct+0x139/0x530
[ 8.105127] submit_bio+0x78/0x1d0
[ 8.106163] ext4_io_submit+0x48/0x60 [ext4]
[ 8.107242] ext4_writepages+0x652/0x1170 [ext4]
[ 8.108300] ? do_writepages+0x41/0x100
[ 8.109338] ? __ext4_mark_inode_dirty+0x240/0x240 [ext4]
[ 8.110406] do_writepages+0x41/0x100
[ 8.111450] __filemap_fdatawrite_range+0xc5/0x100
[ 8.112513] file_write_and_wait_range+0x61/0xb0
[ 8.113564] ext4_sync_file+0x73/0x370 [ext4]
[ 8.114607] __x64_sys_fsync+0x33/0x60
[ 8.115635] do_syscall_64+0x33/0x40
[ 8.116670] entry_SYSCALL_64_after_hwframe+0x44/0xae

[1]. https://bugs.archlinux.org/task/70992

Reported-by: Jens Stutte <jens@chianterastutte.eu>
Tested-by: Jens Stutte <jens@chianterastutte.eu>
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
Note: this depends on commit 018eca456c4b4dca56aaf1ec27f309c74d0fe246
in linux-block for-next branch.

 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3c44c4bb40fc..ab21abc056b8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1454,6 +1454,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		goto retry_write;
 	}
 
+	max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SECTORS);
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
-- 
2.25.1

