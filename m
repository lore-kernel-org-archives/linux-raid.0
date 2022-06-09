Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8D9C43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345423AbiFIVL4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345381AbiFIVLo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:44 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9455C26E92F
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=jRp3SM7RH3XEZbQpMQA5f2N3ArXh8hGpvX2L5gF7mKo=; b=omNcalOZFisLXlT963K6nFEWnO
        jYUND76peOSgGC23N2baqNII3bzd8GXRsyRz2wxbgAjE8g/kjsrRpOhAfgh/iymcrLkaqUewB2WeZ
        mJvde9msWVKi0QHAf8HBTUjIgn9A3UtmhFK2FyEnGAQMr5yCqhI1QOATWc/R8+YBvbz3jPcouusUo
        hBnHCJfOk5VdYucI8+2mILIlvDa6iiwfjOgx8Rcvf2XNSYIPQ2DFNS3pEOkgzD16vx6aNvavop5lS
        ZyfHQxE4fWyTbCsOGIVGGrwsL8an5eVGeBj427cUD3i9yEfHO5A8ACMEb1s4WBK/ryB7dAxw3Da5+
        vvPkHMOw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRO-0037Xk-6G; Thu, 09 Jun 2022 15:11:42 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRF-0001Lm-54; Thu, 09 Jun 2022 15:11:33 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  9 Jun 2022 15:11:24 -0600
Message-Id: <20220609211130.5108-9-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, himanshu.madhani@oracle.com, sudhakar.panneerselvam@oracle.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 08/14] tests/00raid0: add a test that validates raid0 with layout fails for 0.9
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

329dfc28debb disallows the creation of raid0 with layouts for 0.9
metadata. This test confirms the new behavior.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/00raid0 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index 8bc18985f91a..e6b21cc419eb 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -6,11 +6,9 @@ check raid0
 testdev $md0 3 $mdsize2_l 512
 mdadm -S $md0
 
-# now with version-0.90 superblock
+# verify raid0 with layouts fail for 0.90
 mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
-check raid0
-testdev $md0 4 $mdsize0 512
-mdadm -S $md0
+check opposite_result
 
 # now with no superblock
 mdadm -B $md0 -l0 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
-- 
2.30.2

