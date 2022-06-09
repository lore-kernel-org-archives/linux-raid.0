Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA95C43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345261AbiFIVLq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbiFIVLn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:43 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7652123147B
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=HKNnb0uocQ5mz8TbQIStA9jkPVM6s1aXB3S7oRj3Xqg=; b=tPVki2v8+XSn5mfnvO4ja04O/k
        MAioxkrp1nGtZrxtgB6BtyKYVjZffevSUU138FkDyfbM6TiJ4fzCII0z/nmB1SMw9FFXRcf+mjLsu
        0o4H1iI2Ps0Tu5Z+D0wKFn+jYvfbZy76+vozvpQK4yD8vxlSCFmeGpVi4CKE9BqHcczyWX704IvRe
        LzCsa8JVMlJ+nMhsRABjjczYbZVBCQI/ItemuzqHZCtpCA8xZoLihVHVoSrjsVVkFYuUiNyM+GUe1
        6BEbFfW0cFXfXJG8kRRNKuRZnG/kPu5JV+OS7fAtjnyZXaR5yOHpWd8/hEpG5bHqS723r3SMJ70WD
        A24CH7jA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRJ-0037Xl-R3; Thu, 09 Jun 2022 15:11:38 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRE-0001LR-9L; Thu, 09 Jun 2022 15:11:32 -0600
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
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  9 Jun 2022 15:11:17 -0600
Message-Id: <20220609211130.5108-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 01/14] Makefile: Don't build static build with everything
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Running the test require building everything, but it seems to be
difficult to build the static version of mdadm now seeing there
is no readily available static udev library.

There's no need to build it, so just remove it.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index bf126033b841..f2f671cefe66 100644
--- a/Makefile
+++ b/Makefile
@@ -182,7 +182,7 @@ check_rundir:
 		echo "***** or set CHECK_RUN_DIR=0"; exit 1; \
 	fi
 
-everything: all mdadm.static swap_super test_stripe raid6check \
+everything: all swap_super test_stripe raid6check \
 	mdadm.Os mdadm.O2 man
 everything-test: all mdadm.static swap_super test_stripe \
 	mdadm.Os mdadm.O2 man
-- 
2.30.2

