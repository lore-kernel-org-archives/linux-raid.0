Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2D4C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 16 Nov 2022 23:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiKPXuQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Nov 2022 18:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiKPXuP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Nov 2022 18:50:15 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600C628716
        for <linux-raid@vger.kernel.org>; Wed, 16 Nov 2022 15:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=BtJOqeCS7SNVXx7/5uk1g4w35hWKG91Ntf3f/X0gC7M=; b=oID8kqgTHDaR0Jje1P2rrLRk6h
        BhdlGqbWYRweJzfe8iU/Z/lWbLlGXsJVdkJDYzdk+casdDt2SuAb+pMcviLr7AFS7BgRmbViXxWs7
        6TH1bsf2ri1wsY5VI9F9aQ4c2Z3Lg5S2qyN4E/cyyku1m2KrfClpGi9H+w/aj74GBhfkYwxDEVT6S
        IynkkdrW/bZsN+iHbWIzyqGzVVtPGdRgOAsCDBmf/97480e/12nqP3EoZ0BmuI2rKSecqSJ35ghgB
        BFH2zI1oi2ZLqAG57PmDi8+JyMV5/xHF0NXqOGYM7MgmGKYqwngz+MS7ZCmlnpmdEi9G3GcDAx8Rs
        KtfaWQEQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovSAW-0043zP-KJ; Wed, 16 Nov 2022 16:50:13 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovSAW-000KnF-Dt; Wed, 16 Nov 2022 16:50:12 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Date:   Wed, 16 Nov 2022 16:50:03 -0700
Message-Id: <20221116235009.79875-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116235009.79875-1-logang@deltatee.com>
References: <20221116235009.79875-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v5 1/7] Create: goto abort_locked instead of return 1 in error path
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The return 1 after the fstat_is_blkdev() check should be replaced
with an error return that goes through the error path to unlock
resources locked by this function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
---
 Create.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 953e73722518..2e8203ecdccd 100644
--- a/Create.c
+++ b/Create.c
@@ -939,7 +939,7 @@ int Create(struct supertype *st, char *mddev,
 						goto abort_locked;
 					}
 					if (!fstat_is_blkdev(fd, dv->devname, &rdev))
-						return 1;
+						goto abort_locked;
 					inf->disk.major = major(rdev);
 					inf->disk.minor = minor(rdev);
 				}
-- 
2.30.2

