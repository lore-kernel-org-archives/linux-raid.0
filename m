Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C736FC19F21
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jul 2022 21:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbiG0VIx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiG0VIf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Jul 2022 17:08:35 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A518961737;
        Wed, 27 Jul 2022 14:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=grvheGVvup9YTpeIxKlrbH4yr1vdjhEqEftjGji1hi4=; b=M5JTO/qX+gDbSsaY1y5DtCne5a
        kA3+niW7Kc1MrCoYJRdPJMA6n12G1ewKs2uqeB2+rDC8Jkp2j+ZVTIakSm5Q7qG0N0ITGyBroFT//
        rNQBC4XALKn5qvQbPDhUz8cjjXUxo38wRDaY4Onx9yFW6D+hFBRdeDfoMxDpi7+TO9usq2FcTCDwu
        SWacAJjo1HAeJi2z2vICZ/c0X5l6e6t+iV8ZC8PEPsWtljQ7jDLTQoZ/TCrQ3kM63dCCXHetctAPT
        rgarnWEvraQeZnsnfdNvHgImxwhTNksGUnxOMjHGfCzM+iqHZcTvilpZ0B89OlqU3wi4QpcYxM3Ph
        Gp2MHU6Q==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoEG-001pyE-GJ; Wed, 27 Jul 2022 15:06:06 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoEE-000VI0-Ql; Wed, 27 Jul 2022 15:06:02 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 27 Jul 2022 15:05:57 -0600
Message-Id: <20220727210600.120221-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727210600.120221-1-logang@deltatee.com>
References: <20220727210600.120221-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH 2/5] md/raid5: Make is_inactive_blocked() helper
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The logic to wait_for_stripe is difficult to parse being on so many
lines and with confusing operator precedence. Move it to a helper
function to make it easier to read.

No functional changes intended.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b1cb0be8fa67..e7e02a979670 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -755,6 +755,24 @@ static bool has_failed(struct r5conf *conf)
 	return degraded > conf->max_degraded;
 }
 
+/*
+ * Block until another thread clears R5_INACTIVE_BLOCKED or
+ * there are fewer than 3/4 the maximum number of active stripes
+ * and there is an inactive stripe available.
+ */
+static bool is_inactive_blocked(struct r5conf *conf, int hash)
+{
+	int active = atomic_read(&conf->active_stripes);
+
+	if (list_empty(conf->inactive_list + hash))
+		return false;
+
+	if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
+		return true;
+
+	return active < (conf->max_nr_stripes * 3 / 4);
+}
+
 struct stripe_head *
 raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			int previous, int noblock, int noquiesce)
@@ -796,11 +814,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 	set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
 	r5l_wake_reclaim(conf->log, 0);
 	wait_event_lock_irq(conf->wait_for_stripe,
-			    !list_empty(conf->inactive_list + hash) &&
-			    (atomic_read(&conf->active_stripes)
-				  < (conf->max_nr_stripes * 3 / 4)
-				 || !test_bit(R5_INACTIVE_BLOCKED,
-					      &conf->cache_state)),
+			    is_inactive_blocked(conf, hash),
 			    *(conf->hash_locks + hash));
 	clear_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
 	goto retry;
-- 
2.30.2

