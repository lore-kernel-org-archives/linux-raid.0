Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED3BC49EA6
	for <linux-raid@archiver.kernel.org>; Thu, 24 Jun 2021 18:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA62613CC
	for <linux-raid@archiver.kernel.org>; Thu, 24 Jun 2021 18:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhFXSy6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Jun 2021 14:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXSy6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Jun 2021 14:54:58 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Jun 2021 11:52:38 PDT
Received: from dogben.com (dogben.com [IPv6:2400:8902::f03c:91ff:febc:5721])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1ABC061574
        for <linux-raid@vger.kernel.org>; Thu, 24 Jun 2021 11:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dogben.com;
        s=main; h=Message-Id:Cc:To:Subject:Date:From:Sender:Reply-To:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xg6GYr34kqqGF31L9ID+Xpn6gpfzr3/CdT/uBI7+tH4=; b=G0k6e2rwazKqVqTGNbZR6VhB8h
        D13iNO2tLzYL+SKDJZCPr8wvoncHwhjSxG+miWAZlVS7w1NoT5IR5QvFjZfYuYwvI8GbARZFo8U0X
        BSZpeKXSSKpi2T+IPJfbbhqzsh601NuZDiWyGclY6o42uXe5ENj71Epy+/U4/lUSyL4pOsAABUZ+X
        ujg2/MtnFqlb+X8N4GTkoXGp0HGhyYRUKzgmXA43TxFhYCFMuCJ5Xs/4p0j8V/7bNQmNJV7oWkBZ6
        fAN6BhZxapzIFubg4dsEBQnBVEJlpqt3rwfbI8jzZeFn7Dqyo3SH0XWds68Cw178XcQeBovHElUWo
        eDOINHhQ==;
Received: from [47.56.139.253] (helo=localhost)
        by dogben.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <wsy@dogben.com>)
        id 1lwU4E-0029Uw-MM; Thu, 24 Jun 2021 18:27:10 +0000
From:   wsy@dogben.com
Date:   Fri, 25 Jun 2021 02:27:09 +0800
Subject: [PATCH] md/raid10: properly indicate failure when ending a failed
 write request
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
Message-Id: <E1lwU4E-0029Uw-MM@dogben.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Similar to commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd, this patch
fixes the same bug in raid10.

Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
Signed-off-by: Wei Shuyu <wsy@dogben.com>
---

Maybe there are other bugs fixed in one but left open in the other?

 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b2a73d..f9c3b2323d7c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -475,6 +475,8 @@ static void raid10_end_write_request(struct bio *bio)
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

