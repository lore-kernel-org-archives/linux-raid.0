Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E37C7EE33
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 20:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCAUls (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 15:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCAUlo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 15:41:44 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8730E4DBC8
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 12:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=2Hg3vSAwWQuL/w6wWsKr04np3XKVq0j5C9lulcMzPCg=; b=g8mXUABeqx6ZZJ1n2q9+5qU1L0
        hj0DnzmgvPt043BV4sqAGkJXNbZxfGoR/pkJrrhuua/gzcBKmGUE+HqTe6Ox70kDrCa53xuhJaFd1
        GuCNgN7wki/rNomKlGZ5sYgP9jHePElYnaOivRKsg8COEZEL/e5bbbYMSt3CysjfN6edWPb/CqNFg
        rCOc8dEmimpuYq5l+x2u/sLNABwK96HU6ZVViRLcIHsKgMFCNokXqag2YX+bU+88JF36iYUzDcYlT
        B7IAQu60wMe+ls/KKMExLfmR3gHLuKWMraQDsJA60VvgQl2LotN2O+hCuGa2iirXKffwM08rxH0ze
        f6h7BnLA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGe-006cuA-BH; Wed, 01 Mar 2023 13:41:41 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGb-000ADy-UQ; Wed, 01 Mar 2023 13:41:37 -0700
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
Date:   Wed,  1 Mar 2023 13:41:35 -0700
Message-Id: <20230301204135.39230-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com>
References: <20230301204135.39230-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com, chaitanyak@nvidia.com, kch@nvidia.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v7 7/7] manpage: Add --write-zeroes option to manpage
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Document the new --write-zeroes option in the manpage.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Acked-by: Coly Li <colyli@suse.de>
---
 mdadm.8.in | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 64f71ed1df43..6f0f6c13baf1 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -837,6 +837,22 @@ array is resynced at creation.  From Linux version 3.0,
 .B \-\-assume\-clean
 can be used with that command to avoid the automatic resync.
 
+.TP
+.BR \-\-write-zeroes
+When creating an array, send write zeroes requests to all the block
+devices.  This should zero the data area on all disks such that the
+initial sync is not necessary and, if successfull, will behave
+as if
+.B \-\-assume\-clean
+was specified.
+.IP
+This is intended for use with devices that have hardware offload for
+zeroing, but despite this zeroing can still take several minutes for
+large disks.  Thus a message is printed before and after zeroing and
+each disk is zeroed in parallel with the others.
+.IP
+This is only meaningful with --create.
+
 .TP
 .BR \-\-backup\-file=
 This is needed when
@@ -1370,7 +1386,7 @@ and
 .B layout\-alternate
 options are for RAID0 arrays with non-uniform devices size that were in
 use before Linux 5.4.  If the array was being used with Linux 3.13 or
-earlier, then to assemble the array on a new kernel, 
+earlier, then to assemble the array on a new kernel,
 .B \-\-update=layout\-original
 must be given.  If the array was created and used with a kernel from Linux 3.14 to
 Linux 5.3, then
-- 
2.30.2

