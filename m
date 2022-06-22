Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1B7CCA47F
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiFVUZx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiFVUZd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:33 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BD0369E6
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=XcXR64Qwb9vLxYzwc8/UgfWvyCJNhve+UaNp/DhwMSY=; b=cQ1zGWGKq8THdCAbKQByK+oQdK
        IIuobrr9qB04DqRBMbFVPUDafNzNu68Gnc4wRmgZFq/EHBfqBB/WuOsrD4zaeuSaABVmuwbvoWetG
        1JzGixtbUJD3rNI8C2npCXnsI47m6B5NeOTkXH4VeGAC/WEENr6C8qAm/48GmTGPIs0ZNSJOOcSy4
        bqrf7gOEaeTaXns5W7WOT2wJ6mEVARvmBBCNiE7fH9hfBbD4HlI5dEdm+11IVU/DCUJ7UeNoMc6sG
        tYhG5CWyxtLF8gqMO4h0QhyGESvlXZcK9uPDDBdtEJhaze66FwQ9289HEtUmGhwgsUMUoGiJEShlh
        blK2fVbw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uo-00EGyZ-7G; Wed, 22 Jun 2022 14:25:31 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uh-0009MM-9X; Wed, 22 Jun 2022 14:25:23 -0600
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
Date:   Wed, 22 Jun 2022 14:25:10 -0600
Message-Id: <20220622202519.35905-6-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 05/14] monitor: Avoid segfault when calling NULL get_bad_blocks
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Not all struct superswitch implement a get_bad_blocks() function,
yet mdmon seems to call it without checking for NULL and thus
occasionally segfaults in the test 10ddf-geometry.

Fix this by checking for NULL before calling it.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 monitor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/monitor.c b/monitor.c
index b877e595c998..820a93d0ceaf 100644
--- a/monitor.c
+++ b/monitor.c
@@ -311,6 +311,9 @@ static int check_for_cleared_bb(struct active_array *a, struct mdinfo *mdi)
 	struct md_bb *bb;
 	int i;
 
+	if (!ss->get_bad_blocks)
+		return -1;
+
 	/*
 	 * Get a list of bad blocks for an array, then read list of
 	 * acknowledged bad blocks from kernel and compare it against metadata
-- 
2.30.2

