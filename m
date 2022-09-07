Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328E3C38145
	for <linux-raid@archiver.kernel.org>; Wed,  7 Sep 2022 20:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIGUEP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIGUEI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Sep 2022 16:04:08 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C6FC0B76
        for <linux-raid@vger.kernel.org>; Wed,  7 Sep 2022 13:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=lguvncpYIn1T+Y6gxuDW7BR2TNW1QaHuuhfTnIOq8nc=; b=O1uxlC5CZCWj65M5OvZta4xry7
        RpAUTcSPZxoI+oICQBIevT94L/ZfHbLX83rOXlj6N6f6pxZOSLedJd4JJfOAgVcmGbRCebdE3iRJi
        UsCMMqaxkQ8Ir9HVl/S7zQHUDHkO4PJG4DgPc9xkeEP+qpH6GYRRxAcA+z2G/fTw2Hyk72N9p6Y6I
        El2CqdBXEIb+D+ByXj+wXWmcUK/z+XaQeHtly7BuJmlK9stcU+r7MY8F2xVi+LRcPg5Qz4T7OZ3KS
        1xkirca1s/ddQ5QyFBCw0EZaLK4WyPQMcOMbSRvqJG6NQak1bYRy/ym8RsiRbu8nj4k4/B8n5Ishd
        Dhkb3mEw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HH-000vwm-EK; Wed, 07 Sep 2022 14:04:05 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oW1HF-000rM5-F4; Wed, 07 Sep 2022 14:04:01 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed,  7 Sep 2022 14:03:55 -0600
Message-Id: <20220907200355.205045-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907200355.205045-1-logang@deltatee.com>
References: <20220907200355.205045-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm 2/2] manpage: Add --discard option to manpage
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Document the new --discard option in the manpage.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 mdadm.8.in | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index f273622641da..93a0a32dd314 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -836,6 +836,21 @@ array is resynced at creation.  From Linux version 3.0,
 .B \-\-assume\-clean
 can be used with that command to avoid the automatic resync.
 
+.TP
+.BR \-\-discard
+When creating an array, send block discard (aka trim or deallocate)
+requests to all the block devices. In most cases this should zero all
+the disks. If any discard fails, or if zeros are not read back from the
+disk, then the operation will be aborted.
+.IP
+If all discards succeed, and there are no missing disks specified,
+then the array should not need to be synchronized after it is created
+(as all disks are zero). The operation will thus proceed as if
+.B \-\-assume\-clean
+was specified.
+.IP
+This is only meaningful with --create.
+
 .TP
 .BR \-\-backup\-file=
 This is needed when
-- 
2.30.2

