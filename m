Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A85BC678D4
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 20:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCAUlt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 15:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCAUlo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 15:41:44 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873FB4DBCD
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 12:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=GRnYe8AEcFDL2HVmbgZ2j6ZuzB48ZOMQ4epIhUeq+j8=; b=VZZv9tXJnI5aITW+dUl0ytcz7Z
        8Z01PvZ2FKExpAULq5qOvUEigyj1jzQ4GjuzwwxJrd2ihgOgnW+JBEJnGaPn5W06KVmB9TfPsINfG
        l3d2/Ff25azZehQ+z1hD342O3WKhCOjIbrcVbkSDgClaRSefunfGazdWsh2bLHR79cGsDtkgVDLME
        Mrfopll3dQiJEJ6k8ZL7fAczZaC6NVeRzv8KPInlgMX3KIqBGkIGGLaEa8BZWt/A3brhBnPtQRnUd
        JGq5aGWm9xR9Ajhb49Eze7zvNvDhkjcUMt1+PNHaPbi3gnH15Fl38u+IMZZ9R7iBlZ56gkJe6hDEI
        cQJoQnUw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGe-006cuC-Br; Wed, 01 Mar 2023 13:41:41 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGb-000ADv-QO; Wed, 01 Mar 2023 13:41:37 -0700
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
        Kinga Tanska <kinga.tanska@linux.intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Date:   Wed,  1 Mar 2023 13:41:34 -0700
Message-Id: <20230301204135.39230-7-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com>
References: <20230301204135.39230-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com, chaitanyak@nvidia.com, kch@nvidia.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v7 6/7] tests/00raid5-zero: Introduce test to exercise --write-zeros.
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
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Acked-by: Coly Li <colyli@suse.de>
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

