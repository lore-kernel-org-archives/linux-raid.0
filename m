Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C584C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 20:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiIUUoP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIUUoH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 16:44:07 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1D4A4045
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 13:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=jYRRA3Y3GV2CCww+fuAWzB1qlgX/6h/DeZRk6odNSLc=; b=Oil9cFiVRiGkEfnB6Q9pz2BkiD
        4rmLuZ8WQk5W4ap4NTIWfQnd6SOH2jLM2D1SDQM1um19hJCPoGbICNpaXsXj+kI6fiLgtzDV9T0ow
        gecVMXDilxdNriqcnY68gXctDQ5LTmQPiPT3sHeshb1moQIGYfd0uGRwRh5IR38iaPQh36BAgE0SQ
        VFZLgVtnSwnJwIkiYWP+SjisANl4n9RoQBqMQ47GnPqjYrc1yf+Rupe1QYe33yVLykoMjqVqmqaMs
        eWggr4LqttRpqLnHZ498J4QJ9p30n1JB/1IyVAP5s+OK8qglaHZ+iieSqMVV1950X8CUUgbz28EiV
        2+SzOglQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ob6Zg-007H4j-Uu; Wed, 21 Sep 2022 14:44:06 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ob6Zd-000197-Uc; Wed, 21 Sep 2022 14:44:01 -0600
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
Date:   Wed, 21 Sep 2022 14:43:55 -0600
Message-Id: <20220921204356.4336-7-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921204356.4336-1-logang@deltatee.com>
References: <20220921204356.4336-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v3 6/7] tests/00raid5-zero: Introduce test to exercise --write-zeros.
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Attempt to create a raid5 array with --write-zeros. If it is successful
check the array to ensure it is in sync.

If it is unsuccessful and an unsupported error is printed, skip the
test.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/00raid5-zero | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 tests/00raid5-zero

diff --git a/tests/00raid5-zero b/tests/00raid5-zero
new file mode 100644
index 000000000000..7d0f05a12539
--- /dev/null
+++ b/tests/00raid5-zero
@@ -0,0 +1,12 @@
+
+if mdadm -CfR $md0 -l 5 -n3 $dev0 $dev1 $dev2 --write-zeroes ; then
+  check nosync
+  echo check > /sys/block/md0/md/sync_action;
+  check wait
+elif grep "zeroing [^ ]* failed: Operation not supported" \
+     $targetdir/stderr; then
+  echo "write-zeros not supported, skipping"
+else
+  echo >&2 "ERROR: mdadm return failure without not supported message"
+  exit 1
+fi
-- 
2.30.2

