Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA88FC433E3
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 05:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D61B92075B
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 05:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHRFtP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 01:49:15 -0400
Received: from smtp.h3c.com ([60.191.123.50]:8241 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgHRFtO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 Aug 2020 01:49:14 -0400
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([10.8.0.66])
        by h3cspam02-ex.h3c.com with ESMTPS id 07I5mrPN027012
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 13:48:53 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 18 Aug 2020 13:48:55 +0800
From:   Xianting Tian <tian.xianting@h3c.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xianting Tian <tian.xianting@h3c.com>
Subject: [PATCH] md: only calculate blocksize once and use i_blocksize()
Date:   Tue, 18 Aug 2020 13:42:06 +0800
Message-ID: <20200818054206.6612-1-tian.xianting@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66)
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 07I5mrPN027012
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We alreday has the interface i_blocksize(), which can be used
to get blocksize, so use it.
Only calculate blocksize once and use it within read_page().

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
---
 drivers/md/md-bitmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 95a5f3757..0d5544868 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -357,11 +357,12 @@ static int read_page(struct file *file, unsigned long index,
 	struct inode *inode = file_inode(file);
 	struct buffer_head *bh;
 	sector_t block, blk_cur;
+	unsigned long blocksize = i_blocksize(inode);
 
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, false);
+	bh = alloc_page_buffers(page, blocksize, false);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
@@ -383,10 +384,10 @@ static int read_page(struct file *file, unsigned long index,
 
 			bh->b_blocknr = block;
 			bh->b_bdev = inode->i_sb->s_bdev;
-			if (count < (1<<inode->i_blkbits))
+			if (count < blocksize)
 				count = 0;
 			else
-				count -= (1<<inode->i_blkbits);
+				count -= blocksize;
 
 			bh->b_end_io = end_bitmap_write;
 			bh->b_private = bitmap;
-- 
2.17.1

