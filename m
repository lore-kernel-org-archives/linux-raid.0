Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBE0C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C0B61354
	for <linux-raid@archiver.kernel.org>; Mon,  4 Oct 2021 15:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhJDPmT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 11:42:19 -0400
Received: from out10.migadu.com ([46.105.121.227]:56580 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhJDPmP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 4 Oct 2021 11:42:15 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633361706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+bAzGYAqr9FHkWrcCmQSO6gvtwk8V7Vzbvasb2bRmU=;
        b=j95LRkuABUsdFdeekkd+1KizEMzYLbGT9vt8qibyNKJLkAmqt1rnjaOLSiFKIs3GzfEc9M
        +Q0cFB9YNYBHeooiZkCwZnJNnsmO3ry69WSJ5kE6oUAgnNRlbrBXktrHcIEfUc49OZA5hb
        NetJhEbAzGarZBs1rkpuOK0Iljk3VlM=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 5/6] md/raid5: call roundup_pow_of_two in raid5_run
Date:   Mon,  4 Oct 2021 23:34:52 +0800
Message-Id: <20211004153453.14051-6-guoqing.jiang@linux.dev>
In-Reply-To: <20211004153453.14051-1-guoqing.jiang@linux.dev>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Let's call roundup_pow_of_two here instead of open code.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid5.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 02ed53b20654..4ea9e7b647b0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7732,10 +7732,7 @@ static int raid5_run(struct mddev *mddev)
 		 * discard data disk but write parity disk
 		 */
 		stripe = stripe * PAGE_SIZE;
-		/* Round up to power of 2, as discard handling
-		 * currently assumes that */
-		while ((stripe-1) & stripe)
-			stripe = (stripe | (stripe-1)) + 1;
+		stripe = roundup_pow_of_two(stripe);
 		mddev->queue->limits.discard_alignment = stripe;
 		mddev->queue->limits.discard_granularity = stripe;
 
-- 
2.31.1

