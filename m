Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8069AC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Jun 2022 19:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377939AbiFPTT6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiFPTTz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Jun 2022 15:19:55 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB79856384;
        Thu, 16 Jun 2022 12:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=I6q4dKvk9uVUvtNALIt0GxW4LwedkxdjSmse0vN/buc=; b=a4lHtb9nA0RdHYCz392I5pzW7Z
        7dDueIg5lJRJZHghoTzuh2WcLEWj/iFVWZ7du2buNlxbbs7kppmhzR8k/UhFevMj9tqbcfjKvXSU7
        oNlv6BEGKDwPVIXO6lEKVfScu5Z/O0b45U9fMA65HfRM1w8y+2b12beQpS6cVpOgv5sl4u20cc3N0
        d6600nKzM6LLVDIMmMmZ38tfroAoDQUi29K5nYfdtLitvCy63E+C2kJzou484Ie6lOejZyoRS6xX9
        ix7tirWza1NojBC0zuixcrHtpZ0brcEBlfqoxbilcooPDgQTnUchGEKX9phfz9gKSLblLwjmwAsLq
        e0LKXdew==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o1v1y-0092ij-U6; Thu, 16 Jun 2022 13:19:51 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o1v1w-0006Fw-Vx; Thu, 16 Jun 2022 13:19:49 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 16 Jun 2022 13:19:45 -0600
Message-Id: <20220616191945.23935-16-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616191945.23935-1-logang@deltatee.com>
References: <20220616191945.23935-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 15/15] md/raid5: Increase restriction on max segments per request
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The block layer defaults the maximum segments to 128, which means
requests tend to get split around the 512KB depending on how many
pages can be merged. There's no such restriction in the raid5 code
so increase the limit to USHRT_MAX so that larger requests can be
sent as one.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e48c16bfe657..5723a497108a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8005,6 +8005,9 @@ static int raid5_run(struct mddev *mddev)
 		 */
 		blk_queue_max_hw_sectors(mddev->queue,
 			RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf));
+
+		/* No restrictions on the number of segments in the request */
+		blk_queue_max_segments(mddev->queue, USHRT_MAX);
 	}
 
 	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
-- 
2.30.2

