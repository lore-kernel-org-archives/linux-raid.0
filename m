Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28ABFC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 19:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiKWTKL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239782AbiKWTKE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 14:10:04 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D175890589
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=fsT4GyZraUULLUCSqNPFpxDD29UsbWsjXCW1JwNTiNU=; b=HSvhHFM6e3vX2MFOErCwciDGHy
        9lUu4aPnyPVjB6IwEBSWAi9I/le4JxNZ41Zxrr7oiupBLh5NAU5xaMPJwoSArxhIlveNV3K9bIdbd
        IWa+cQc1LFW0US/ZRNQrI70BU244Xx4w/qdrGZQlciXGKlQBAUZrCeT5X4CbGOgL8y9laz95EPQK5
        xb91H413xijLzEUYgJssOi1Vr62ERoRL/CSr78rPaXh+KAPcSnxPFESmeNG/osKq4pxvZW3/tLRET
        VcF5pCheQK7wkE/nw3hSbz5WJlJBFHhP1bU+GuOQ33vXKwmeDt4rr2Q9HjdmaNmKvFH4MI6wke0Py
        UkYDIocg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv8C-009Six-9Q; Wed, 23 Nov 2022 12:10:01 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv89-000Opk-82; Wed, 23 Nov 2022 12:09:57 -0700
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
Date:   Wed, 23 Nov 2022 12:09:53 -0700
Message-Id: <20221123190954.95391-7-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123190954.95391-1-logang@deltatee.com>
References: <20221123190954.95391-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v6 6/7] tests/00raid5-zero: Introduce test to exercise --write-zeros.
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
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
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

