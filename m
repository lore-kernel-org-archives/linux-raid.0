Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B0DC2B9F4
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 07:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A204460FE9
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 07:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhF1HRj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Jun 2021 03:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhF1HRj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Jun 2021 03:17:39 -0400
Received: from dogben.com (dogben.com [IPv6:2400:8902::f03c:91ff:febc:5721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78ACC061574
        for <linux-raid@vger.kernel.org>; Mon, 28 Jun 2021 00:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dogben.com;
        s=main; h=Message-Id:Cc:To:Subject:Date:From:Sender:Reply-To:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tC2OXm7Z7a7c2jCu+RhpiZk6Lrhj+RoP+JgckLZRWtI=; b=ojVEU3Uo89QeBxv3RVLjtEsZ+a
        VdWOPerBL3PMSx5ejc6KYB3qmr5LPQbVB1GIpntRhTrAVfIrA8ilwN7Sc9lX5W+8ZZwGyzzLei4GV
        /wvczrCSJ1OyOKBF8olwPUzrs9c1qyOLF12E8tKr7jGdOHldfQRcPFQ1QNQCX64DcGUNXyEPVtX/b
        KIRim5sifzXqufcuDitJ0O76iKhWbNEa222Y7YapBxOznWfXhqpfv82/sc7FlaXkNiXLx9W3NM0sA
        siR4AXsgDGcUelIwX3v22hPdNzjU3Y+D33FljxwFspOZzTs3xt7BiENRWvg0Tjhb72hBdPHjypWfn
        MHI6JOsg==;
Received: from [47.56.139.253] (helo=localhost)
        by dogben.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <wsy@dogben.com>)
        id 1lxlU5-002GZB-TY; Mon, 28 Jun 2021 07:15:10 +0000
From:   wsy@dogben.com
Date:   Mon, 28 Jun 2021 15:15:08 +0800
Subject: [PATCH v2][RESEND] md/raid10: properly indicate failure when ending a failed
 write request
To:     linux-raid@vger.kernel.org
Cc:     wsy@dogben.com, song@kernel.org, jgq516@gmail.com,
        paul.clements@us.sios.com, yuyufen@huawei.com
Message-Id: <E1lxlU5-002GZB-TY@dogben.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
fixes the same bug in raid10. Also cleanup the comments.

Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
Signed-off-by: Wei Shuyu <wsy@dogben.com>
---
 drivers/md/raid1.c  | 2 --
 drivers/md/raid10.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ced076ba560e..753822ca9613 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -472,8 +472,6 @@ static void raid1_end_write_request(struct bio *bio)
 		/*
 		 * When the device is faulty, it is not necessary to
 		 * handle write error.
-		 * For failfast, this is the only remaining device,
-		 * We need to retry the write without FailFast.
 		 */
 		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b2a73d..40e845fb9717 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -469,12 +469,12 @@ static void raid10_end_write_request(struct bio *bio)
 			/*
 			 * When the device is faulty, it is not necessary to
 			 * handle write error.
-			 * For failfast, this is the only remaining device,
-			 * We need to retry the write without FailFast.
 			 */
 			if (!test_bit(Faulty, &rdev->flags))
 				set_bit(R10BIO_WriteError, &r10_bio->state);
 			else {
+				/* Fail the request */
+				set_bit(R10BIO_Degraded, &r10_bio->state);
 				r10_bio->devs[slot].bio = NULL;
 				to_put = bio;
 				dec_rdev = 1;
-- 
2.32.0

