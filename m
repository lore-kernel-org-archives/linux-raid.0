Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5BCC43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiFIVLv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345361AbiFIVLo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:44 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6BC26E909
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=jp66Uj0KPYNCtqYBFltKo8R5KGhIAqhSkkfIBhcMyHw=; b=elg6WNF4PkMkxv+P7LttJ7TX3W
        rPzIlCvrPRHSAvnp1/Q4Y4p64WcDzNqkoyONzbdYlxGKcAiDdlesS1NxWGwAn4iKMsg1utpHqOrOT
        mLxr5OFj1lzsv/V/w/Ev/PORtYFgKluXRPDTV75RHpGuMS8UDvb1T0xznHkFtkZpTnx70PVr3hRPI
        R+uHHh5KkFIdCuSBGBYUENXklrg9WtZ/W1rQmQ4HBLyY5a3wTSL4/AwObmSsIoa04/NZnmHBcbTQU
        g4YtKTLO681pPOPswO80qA8TJYVAq5XuDVYwsn6QRP3HBKAMCZqaC/80EIfHIk+RQTiWWBOONLJs3
        FNVrauhw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRM-0037Xl-8H; Thu, 09 Jun 2022 15:11:40 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRF-0001Lw-H7; Thu, 09 Jun 2022 15:11:33 -0600
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
Date:   Thu,  9 Jun 2022 15:11:26 -0600
Message-Id: <20220609211130.5108-11-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, himanshu.madhani@oracle.com, sudhakar.panneerselvam@oracle.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 10/14] tests/04update-metadata: avoid passing chunk size to raid1
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

'04update-metadata' test fails with error, "specifying chunk size is
forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
correcting the test to ignore passing chunk size to raid1.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
[logang@deltatee.com: fix if/then style and dropped unrelated hunk]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/04update-metadata | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/04update-metadata b/tests/04update-metadata
index 08c14af7ed29..2b72a303b6a0 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -11,7 +11,11 @@ dlist="$dev0 $dev1 $dev2 $dev3"
 for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
-  mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  if [[ $l == 'raid1' ]]; then
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
+  else
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  fi
   testdev $md0 $s 19904 64
   mdadm -S $md0
   mdadm -A $md0 --update=metadata $dlist
-- 
2.30.2

