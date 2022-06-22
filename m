Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D516C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiFVUZp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiFVUZc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:32 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BBC36682
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=jp66Uj0KPYNCtqYBFltKo8R5KGhIAqhSkkfIBhcMyHw=; b=rD8gBslipM98o84FPDQszfV5G/
        Ep5xQ8Nvri9J2FykBif0OTheYUY0dm/uI7otxxSCVRi64xRmGZJ5UhjsD93TM+lwVzG+uj/EIzL/C
        4qwWqA91m8DRF9er3kQBmgWZJ3cYcaNHn54tqscRIGVkOXocKodhOaD1ZnnYSLAZ0GhVpF99BnTZr
        aBvdMCndkj/7h4YrlZvoMUAHLR+QlaEYN58iYMCl8iQI4jcpvF+Cg7w5Q87EUM3lf/JZco3li8AVR
        OVlBTN3aO1lhXaawCXvPifrAMQIcYgWr/NCsgsBkMqRfmCFYyOR0d6SveYDGg6KfsmwVcZ5npWv2Y
        JmJeD6qw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46un-00EGyZ-Ds; Wed, 22 Jun 2022 14:25:30 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ui-0009Mf-0y; Wed, 22 Jun 2022 14:25:24 -0600
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
Date:   Wed, 22 Jun 2022 14:25:15 -0600
Message-Id: <20220622202519.35905-11-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, himanshu.madhani@oracle.com, sudhakar.panneerselvam@oracle.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 10/14] tests/04update-metadata: avoid passing chunk size to raid1
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

