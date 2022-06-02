Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC904C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  2 Jun 2022 18:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiFBSSh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237920AbiFBSSX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Jun 2022 14:18:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95394D9CF;
        Thu,  2 Jun 2022 11:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=3NgWxjjGjfH7QAQ8Wc4h1yGFk2yNyL7ffDtojTNOAXU=; b=oQuiLH+o6kVXVs6A4NxLoL+hff
        xflJWX4GpVLBxKPXa2Zh1+xUlxN3OvJKYMDB1SB5wXXnCTgIHxotY2m9m8wVcAPd0nGWcoxaF2wrD
        LVmm+rHmIhoL7TTgfuLeWhbaKIObvHxFr0ZhHzIaTYaqoCERCAzV0vdbAbH7wVFXtDGoykASfof3Z
        /9IPGWSX3AboqPnJ4sdwXDiI9Btt7KWT4NzTEJjY6BisxVzyHMvEK0wtEZx/kERIRlehlk0z2n2k7
        dU7TRYVc14QhG0AM1lkjAm7Z48VosWKcLJlWe0TabyWtanN7xP1o+EJV4iZVsQn57Tdp3xkrk01NS
        noR3iFbg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nwpOm-00EPmZ-Pu; Thu, 02 Jun 2022 12:18:22 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nwpOm-000DDM-0j; Thu, 02 Jun 2022 12:18:20 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  2 Jun 2022 12:18:10 -0600
Message-Id: <20220602181818.50729-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220602181818.50729-1-logang@deltatee.com>
References: <20220602181818.50729-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 04/11] md/raid5-cache: Take mddev_lock in r5c_journal_mode_show()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The mddev->lock spinlock doesn't protect against the removal of
conf->log in r5l_exit_log() so conf->log may be freed before it
is used.

To fix this, take the mddev_lock() insteaad of the mddev->lock spinlock.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid5-cache.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 83c184eddbda..69b95005abca 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2534,10 +2534,13 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	struct r5conf *conf;
 	int ret;
 
-	spin_lock(&mddev->lock);
+	ret = mddev_lock(mddev);
+	if (ret)
+		return ret;
+
 	conf = mddev->private;
 	if (!conf || !conf->log) {
-		spin_unlock(&mddev->lock);
+		mddev_unlock(mddev);
 		return 0;
 	}
 
@@ -2557,7 +2560,7 @@ static ssize_t r5c_journal_mode_show(struct mddev *mddev, char *page)
 	default:
 		ret = 0;
 	}
-	spin_unlock(&mddev->lock);
+	mddev_unlock(mddev);
 	return ret;
 }
 
@@ -3167,6 +3170,8 @@ void r5l_exit_log(struct r5conf *conf)
 {
 	struct r5l_log *log = conf->log;
 
+	lockdep_assert_held(&conf->mddev->reconfig_mutex);
+
 	conf->log = NULL;
 	synchronize_rcu();
 
-- 
2.30.2

