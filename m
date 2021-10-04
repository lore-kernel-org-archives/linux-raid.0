Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F07C433FE
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B51660F9E
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhJDPmX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbhJDPmR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Oct 2021 11:42:17 -0400
Received: from out10.migadu.com (out10.migadu.com [IPv6:2001:41d0:2:e8e3::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B53C061745
        for <linux-raid@vger.kernel.org>; Mon,  4 Oct 2021 08:40:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633361701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02GsDaUizqhIdo+9MJ3mTLvp9xZApfjnFql4qVo46y0=;
        b=TiH7ouRF2PdjCQ13NnP1R0Up7zqS8vuSPXD9u76zHboxq0sHJ5n68JnxhrGutIA1RftEvG
        oCIZ/I2OjUP7OvPyBqdUMlT884XvzLIX5I7aIKVmFb7bvev1rymnG60z7f30iNBVyEqEZ1
        CqcUo4RegVMI+ZGj0RMYE0mH8yWmFVs=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/6] md/raid1: only allocate write behind bio for WriteMostly device
Date:   Mon,  4 Oct 2021 23:34:48 +0800
Message-Id: <20211004153453.14051-2-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-1-guoqing.jiang@linux.dev>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit 6607cd319b6b91bff94e90f798a61c031650b514 ("raid1: ensure write
behind bio has less than BIO_MAX_VECS sectors") tried to guarantee the
size of behind bio is not bigger than BIO_MAX_VECS sectors.

Unfortunately the same calltrace still could happen since an array could
enable write-behind without write mostly device.

To match the manpage of mdadm (which says "write-behind is only attempted
on drives marked as write-mostly"), we need to check WriteMostly flag to
avoid such unexpected behavior.

[1]. https://bugzilla.kernel.org/show_bug.cgi?id=213181#c25

Cc: stable@vger.kernel.org # v5.12+
Cc: Jens Stutte <jens@chianterastutte.eu>
Reported-by: Jens Stutte <jens@chianterastutte.eu>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19598bd38939..6ba12f0f0f03 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1496,7 +1496,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		if (!r1_bio->bios[i])
 			continue;
 
-		if (first_clone) {
+		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
-- 
2.31.1

