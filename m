Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E27C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiFVUZc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiFVUZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:30 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1436682
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=TTn1WzCN0/LrewIAnaPv3/sGK5F+cFuKEinrc1xWq/I=; b=ZwpcM+N7Q2cq3yb1liP2gd5PIk
        LzkrkdfeM1soJx7RvwUY7hgNq1FzzpGIcrwQ/Dl/RdWZXSlh03HZZVyZyLMsSq3ySVP9qp+Nk5JlU
        RVbdodWWeKotsBSitlE5qrm43HKi97RJhUi4zfgok6hCjfdAbKdf/mNvI+hZOJzyQnMYCwIbpmU6k
        F/2OnFfGkDn1F1j55vsu6JfHmxleMWCO+r6SvWmtYvndDZIG8nr+g5XoJI/Ro1DNMtzzl44hIZCNC
        NfG2ujTXO3qcupCVcmHeQR/aARbRt8W7HUPTfSdpwMIe/AP2tqCqcYTn3OJN/GcrQzabFbcLJZ+9Q
        Oe0+CyJA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uk-00EGyY-Qt; Wed, 22 Jun 2022 14:25:27 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ug-0009MA-SX; Wed, 22 Jun 2022 14:25:22 -0600
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
Date:   Wed, 22 Jun 2022 14:25:06 -0600
Message-Id: <20220622202519.35905-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 01/14] Makefile: Don't build static build with everything and everything-test
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Running the test suite requires building everything, but it seems to be
difficult to build the static version of mdadm now seeing there
is no readily available static udev library.

The test suite doesn't need the static binary so just don't build it
with the everything or everything-test targets.

Leave the mdadm.static and install-static targets in place in case
someone still has a use case for the static binary.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bf126033b841..ec1f99ed5d83 100644
--- a/Makefile
+++ b/Makefile
@@ -182,9 +182,9 @@ check_rundir:
 		echo "***** or set CHECK_RUN_DIR=0"; exit 1; \
 	fi
 
-everything: all mdadm.static swap_super test_stripe raid6check \
+everything: all swap_super test_stripe raid6check \
 	mdadm.Os mdadm.O2 man
-everything-test: all mdadm.static swap_super test_stripe \
+everything-test: all swap_super test_stripe \
 	mdadm.Os mdadm.O2 man
 # mdadm.uclibc doesn't work on x86-64
 # mdadm.tcc doesn't work..
-- 
2.30.2

