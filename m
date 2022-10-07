Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4089C43217
	for <linux-raid@archiver.kernel.org>; Fri,  7 Oct 2022 20:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJGULA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Oct 2022 16:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJGUKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Oct 2022 16:10:51 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B797D7A
        for <linux-raid@vger.kernel.org>; Fri,  7 Oct 2022 13:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=zRz4uZswhJhUKd38J9p7a6jMUYb+0P0hTyItfNwY4DQ=; b=hL9D2LJ3J9zmX49isPzW4eK6Ac
        d5FjLuczww95t9mikebu6mtBcgtTaQFEheJreWkwVLhbcTAxXUI/cGwmHW0moY33Mq5Mza9yl26XK
        WXP5mRxgfFjnIrmNKXWY+p9GPSIvs43MkejTGK4/usQQJ0Dug+T3A5mru1CKA5pjuD/BjpBR22a1Y
        2wffJH6N8+hW7HeL/x0cDLDIeG6Xinu8+rtTngceyYTSngOa7ggU4OwCNsSOLjEabMLAjDg50F8ZT
        G3ugQ9j9/EB8apxiWOaE8P8GjpOkWnybOLBGmzGBhS3fRdgxa+0mmz+cLnK3cpPAGiu1X73P5fFKA
        I+sNWULQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtgB-002hCl-DC; Fri, 07 Oct 2022 14:10:44 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtg8-0005I3-0D; Fri, 07 Oct 2022 14:10:40 -0600
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
Date:   Fri,  7 Oct 2022 14:10:37 -0600
Message-Id: <20221007201037.20263-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007201037.20263-1-logang@deltatee.com>
References: <20221007201037.20263-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v4 7/7] manpage: Add --write-zeroes option to manpage
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Document the new --write-zeroes option in the manpage.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 mdadm.8.in | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index 70c79d1e6e76..3beb475fd955 100644
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
+zeroing, but despit this zeroing can still take several minutes for
+large disks.  Thus a message is printed before and after zeroing and
+each disk is zeroed in parallel with the others.
+.IP
+This is only meaningful with --create.
+
 .TP
 .BR \-\-backup\-file=
 This is needed when
-- 
2.30.2

