Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D44C1B0E9
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 15:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiHYPqm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 11:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiHYPqk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 11:46:40 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2E3B07C2
        for <linux-raid@vger.kernel.org>; Thu, 25 Aug 2022 08:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=s9NBwDqKZpM0MIi2ZR242F1RGlH9gHbpD182yw849eU=; b=aailzl2WIFNknCCS0E4Mj14cVx
        9w1kXkIIXVnXaPcHr76qLnxABiWIcdRVlM7h0cZ/HNZW22GW53UM7DoKAsU2mSuXUjYjqyQ5QAvwZ
        xPQr9MOM49QO7T2tInXQTeFG1pqtczMDVUdjzNcTW+JVSfqBVInywhWcQqZ7fLVfrOeAaFg1kjehx
        60memc8cKavxDl81EtBJOQF/ii4oSbw5Nd9mU+Vrl/7Fmk15adUFTA1BneWsmK62oyI8Kxo5yLdQZ
        IOluiAlEw0X46izGXvSS8pPyt06wotJUb1kvSmuoqtYeE02DxYd5pynAMweOZ3vmetcCrTcKZRWbj
        22P1O48A==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oRF42-0086e6-RR; Thu, 25 Aug 2022 09:46:39 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oRF42-0001nk-6F; Thu, 25 Aug 2022 09:46:38 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 25 Aug 2022 09:46:27 -0600
Message-Id: <20220825154627.6879-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: song@kernel.org, linux-raid@vger.kernel.org, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH] md/raid5: Ensure stripe_fill happens on non-read IO with journal
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When doing degrade/recover tests using the journal a kernel BUG
is hit at drivers/md/raid5.c:4381 in handle_parity_checks5():

  BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));

This was found to occur because handle_stripe_fill() was skipped
for stripes in the journal due to a condition in that function.
Thus blocks were not fetched and R5_UPTODATE was not set when
the code reached handle_parity_checks5().

To fix this, don't skip handle_stripe_fill() unless the stripe is
for read.

Fixes: 07e83364845e ("md/r5cache: shift complex rmw from read path to write path")
Link: https://lore.kernel.org/linux-raid/e05c4239-41a9-d2f7-3cfa-4aa9d2cea8c1@deltatee.com/
Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 31a0cbf63384..4ec33fd62018 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4047,7 +4047,7 @@ static void handle_stripe_fill(struct stripe_head *sh,
 		 * back cache (prexor with orig_page, and then xor with
 		 * page) in the read path
 		 */
-		if (s->injournal && s->failed) {
+		if (s->to_read && s->injournal && s->failed) {
 			if (test_bit(STRIPE_R5C_CACHING, &sh->state))
 				r5c_make_stripe_write_out(sh);
 			goto out;

base-commit: ba5f3643ff6eed7300fd0cfb327ecb48a8be3fb6
--
2.30.2
