Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728B3C43334
	for <linux-raid@archiver.kernel.org>; Thu,  7 Jul 2022 09:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiGGJJD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Jul 2022 05:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiGGJJD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Jul 2022 05:09:03 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92400237CE
        for <linux-raid@vger.kernel.org>; Thu,  7 Jul 2022 02:09:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657184939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6Sgqxrvdf/3/yjpJqTpJ2sol2fL+Bre4D60T+/hHsWc=;
        b=gaB1lN2lYrLnumH2v6GSLx1fOwwpIYE79UqdSMXKmsY+dn1vYfBppuZH+/fRdD8fJP9JE3
        StjVY3ReRX9Ra2hC2S6+NvtABL/PKI2wam/tcDszZO8Gs3jVSEFigoqt6beIvnenAyd8Qf
        Tu4oRZhoGKZT1hcfFSLNVLZkNxnELKc=
From:   Jackie Liu <liu.yun@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] raid5: fix duplicate checks for rdev->saved_raid_disk
Date:   Thu,  7 Jul 2022 17:08:34 +0800
Message-Id: <20220707090834.1881470-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

'first' will always be greater than or equal to 0, it is unnecessary to
repeat the 0 check, clean it up.

Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 20e53b167f81..a0b38a0ea9c3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8063,8 +8063,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 * find the disk ... but prefer rdev->saved_raid_disk
 	 * if possible.
 	 */
-	if (rdev->saved_raid_disk >= 0 &&
-	    rdev->saved_raid_disk >= first &&
+	if (rdev->saved_raid_disk >= first &&
 	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
-- 
2.25.1

