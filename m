Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070D2C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  7 Oct 2022 20:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJGUKy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Oct 2022 16:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJGUKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Oct 2022 16:10:51 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4B792F4C
        for <linux-raid@vger.kernel.org>; Fri,  7 Oct 2022 13:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=4HsPQhP54k/BnsaoubsCMfQrH3B5ZDFJ3LyVnvBAjxU=; b=mVqWnpxf/o4TvGrTtwt0Rv6VXK
        aZOIUZGvNRq/0xhQmFvpcoORmBCg9l54En+MvWixy+GV0r5SXS5fXhJmNrxWiCr8mlnECzT4LGDsR
        COCb9nSkMHM1uhm/4of75WL+TkInp4upXv2mkh7VK8XcCQawarr0HQYCaqpyv6QixqnjUuoo5Crzv
        bR4noWrDLfWyErJGZ9JT2XuYdmp0tnzhas6Qhg9YPZKUgrh3tESlSKz0tntLhMaWq/y7myzNwfncP
        H4930BYY2mt0x4Lw0iKI3kksGtyX4eew1nXhw8/yrxidvK4S/QvM641mkJhsEIIg0CAZf0CBGZBGa
        vv1ygOXg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtgA-002hCi-9n; Fri, 07 Oct 2022 14:10:43 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtg7-0005Hl-6J; Fri, 07 Oct 2022 14:10:39 -0600
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
        Logan Gunthorpe <logang@deltatee.com>
Date:   Fri,  7 Oct 2022 14:10:31 -0600
Message-Id: <20221007201037.20263-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007201037.20263-1-logang@deltatee.com>
References: <20221007201037.20263-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v4 1/7] Create: goto abort_locked instead of return 1 in error path
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The return 1 after the fstat_is_blkdev() check should be replaced
with an error return that goes through the error path to unlock
resources locked by this function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
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

