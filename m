Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D322CC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345377AbiFIVLt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345121AbiFIVLn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:43 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077BA26D89C
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=5dbV102Q994V1lyNgmKcn4tb5fiwa3NLzz1hJcS0cnE=; b=dSUN7slw4b32FQZpVAj1kLS2cj
        IuJmBoeG1k2hgtq2SHXZcE6cr3kuTnBAaArLEL/jAg7FlhoY4I2+fpIFnaOMmrqNsAPsFf2aZwu3p
        SJyDMvSPPoTGSX6khMfXc0f4z5Pd7mFiLHw/U9E4K9JwvN6U+DVpuwLngmo6ipPFiTzn8HuY48bv2
        UOzoMSdopsUIT3RBmXQwVxYbvEk185bvImDeUzlACMPVonACwq7iR1bBQlG6WA7I3472RPEZwqXrg
        efDgXMwV+a6g0G/BNGW1hZeqO7fNtMv42Klo8L0cgmJgeHokAmyfjQla2AnZJRU8f13OZ1ZaWC37l
        XjmEX0vQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRM-0037Xk-2T; Thu, 09 Jun 2022 15:11:40 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRF-0001M0-Lz; Thu, 09 Jun 2022 15:11:33 -0600
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
Date:   Thu,  9 Jun 2022 15:11:27 -0600
Message-Id: <20220609211130.5108-12-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, himanshu.madhani@oracle.com, sudhakar.panneerselvam@oracle.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 11/14] tests/02lineargrow: clear the superblock at every iteration
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

This fixes 02lineargrow test as prior metadata causes --add operation
to misbehave.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/02lineargrow | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/02lineargrow b/tests/02lineargrow
index e05c219d113a..595bf9f20802 100644
--- a/tests/02lineargrow
+++ b/tests/02lineargrow
@@ -20,4 +20,6 @@ do
   testdev $md0 3 $sz 1
 
   mdadm -S $md0
+  mdadm --zero /dev/loop2
+  mdadm --zero /dev/loop3
 done
-- 
2.30.2

