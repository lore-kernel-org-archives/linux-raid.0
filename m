Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB97AC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 19:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiKWTKF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbiKWTKE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 14:10:04 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF868FB3F
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=BtJOqeCS7SNVXx7/5uk1g4w35hWKG91Ntf3f/X0gC7M=; b=t7xoOshEUxkdaF3RXYZocFKO/6
        soRvxZyJkyHY8T5t6MdJixXjP/W8x0+KDEF8oxd2E8/cD8x3GJ/60AMA9TEQSIuFfp5wdoeYPchgv
        6EfYPsrSfVsXSIXXxKJ4qttFHlPIRkJCMZ7zZwF+kKncJPTQndMPBVjuwuaWcvHFU82ZmLh/yKo5P
        ODEhiXdxdNOVN4cFy94FkOWlUKY9CYcypo1UzamnuFO6aBePs0VUqSG1L6VNdRuW+IfU1C/Ansjdj
        O43XagNWmKmCHVswKrZCD4Lb2Tg0mXGdNU3FC4rOjky3EI1NYaUOrzlDQVpqxcCrFR29WsABxT+QI
        mpWMDnMQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv8B-009Siy-EC; Wed, 23 Nov 2022 12:10:00 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv88-000OpV-Mk; Wed, 23 Nov 2022 12:09:56 -0700
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
Date:   Wed, 23 Nov 2022 12:09:48 -0700
Message-Id: <20221123190954.95391-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123190954.95391-1-logang@deltatee.com>
References: <20221123190954.95391-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v6 1/7] Create: goto abort_locked instead of return 1 in error path
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

