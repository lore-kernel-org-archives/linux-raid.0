Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADA6C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 16 Nov 2022 23:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiKPXqu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Nov 2022 18:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiKPXqm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Nov 2022 18:46:42 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F929F5F
        for <linux-raid@vger.kernel.org>; Wed, 16 Nov 2022 15:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=fsT4GyZraUULLUCSqNPFpxDD29UsbWsjXCW1JwNTiNU=; b=dxWx2ywMVu6VTw6MU3CDmD1kYu
        1Uz+30DcK427eHSZ5H+DwtjZ7ku4x1/z0wGiZOZBVVT26YTR7tnTczxwF0MOA9SqvD2VdamCxUeYh
        SOu+xf005H4yUzakhs1j9jP6H+JY9iPD+eeQafR3kZLHoAiW59beWvP0eYDp9MYquUrGvmvmSW5zp
        kvqvDMYstLAyIt9oaHL+ePcTt8aJU8wI2ZdzvSx7+ooAd9g2qU88ONw3fhvnXc5HjhRJTCvKffVsy
        5U+7FVzXwuErF963Dr9HnhvM/N5snjp4Gm+8lCpRdj4K2jB46m3DN1wumSZ3i9rY3wMSW8eN+RrEH
        NHpkJ57A==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovS6y-0043vQ-9t; Wed, 16 Nov 2022 16:46:35 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovS6w-000KgD-6a; Wed, 16 Nov 2022 16:46:30 -0700
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
Date:   Wed, 16 Nov 2022 16:46:10 -0700
Message-Id: <20221116234617.79441-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v5 6/7] tests/00raid5-zero: Introduce test to exercise --write-zeros.
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

