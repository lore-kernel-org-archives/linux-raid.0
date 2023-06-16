Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511F3EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 09:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344252AbjFPJ0u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 05:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344440AbjFPJ0a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 05:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7561435A2;
        Fri, 16 Jun 2023 02:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9DB63291;
        Fri, 16 Jun 2023 09:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F689C433C8;
        Fri, 16 Jun 2023 09:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686907538;
        bh=XHQLN9nl8TdAAC8nr9pRDK1MMoc21zbzvmAMT6d+aV8=;
        h=From:To:Cc:Subject:Date:From;
        b=HWwpM+qfAVvgds/zGb334+M25YQhO4zvPLkXeZuxOO6aLId+XwaBREqJ6hREUpJo5
         EJW8rExR4qi4/YMSgUPGdgdWX9LiWvs9E8h31BS7/iqKGuUwDq/eOEVcJ/d/lug0dv
         wG1DCN7/T8kEpgumUCGYp8bCZ5VHOmBQ7p5GT12nvk0ehAzrIb8OmoRodmdbYtVQqo
         v+xlbGgGnylf+NqrZqYjX7GFMUXoQYr0QQ4gA3SmlCRguzjhLxaW8EDIo11R1fEMF2
         06F5f0v+u3x1AdpNHCrTxPc2PFnAWWJpU3wsxZ7x7vjNdXPo/IKWKUV/0qbB1gH7H4
         1BcDrDR0d8d8w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid1-10: shut up randstruct warning again
Date:   Fri, 16 Jun 2023 11:24:48 +0200
Message-Id: <20230616092532.3307719-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A code reorganization brought back a warning when structure randomization
is enabled:

drivers/md/raid1-10.c:119:25: error: casting from randomized structure pointer type 'struct block_device *' to 'struct md_rdev *'
        struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
                               ^

Before the rework, this used a (void*) cast, so go back to that in order
to avoid the warning. Casting between pointers to incompatible types is
clearly something that is dangerous, but this driver has always done so,
and it's not made any worse by the struct randomization in this case.

Fixes: 8295efbe68c08 ("md/raid1-10: factor out a helper to submit normal write")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/raid1-10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 169ebe296f2d0..3f22edec70e78 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -116,7 +116,7 @@ static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
 
 static inline void raid1_submit_write(struct bio *bio)
 {
-	struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
+	struct md_rdev *rdev = (void *)bio->bi_bdev;
 
 	bio->bi_next = NULL;
 	bio_set_dev(bio, rdev->bdev);
-- 
2.39.2

