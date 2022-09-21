Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56ECC6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 20:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIUUoK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIUUoH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 16:44:07 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F95A1A5B
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=C9njKuHJey4mbVDcLPNMY/HZOYTGdBFGokirIE34hTI=; b=KYo88TG7ILSQDdI/p5Q+Cj0Ehd
        H4bJ/IPADz3aG1qZ498sCGq93OPfKvIFUgRGN4I/ewxPqvzLA6vadX3GOTlIsdnoUvd4qltGFApQ5
        0FrY6IM1vAHHZElAm8telhkAlThsn/WZln84LuuIONWlh2h0czZuJ7O1INnK7JkkBNl7hMrpTmHFV
        AawGVuqAyhXDtTlAUDX7sfd0GaoCO8thye1I1/KKlvaI99eI6sIQbZsC3ZVAiJkACekSkZS49//nL
        UM/XWQOYArg1y5LIFJ9q5rm94NTvj6kC6ssftLsqadW6vsB1OGTFrnbirz00LO/fdYP2brPfvnzP6
        5bARjc2g==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ob6Zg-007H4k-AR; Wed, 21 Sep 2022 14:44:05 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ob6Ze-00019A-2r; Wed, 21 Sep 2022 14:44:02 -0600
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
Date:   Wed, 21 Sep 2022 14:43:56 -0600
Message-Id: <20220921204356.4336-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921204356.4336-1-logang@deltatee.com>
References: <20220921204356.4336-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v3 7/7] manpage: Add --write-zeroes option to manpage
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
index f273622641da..4e57358d9c1e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -836,6 +836,22 @@ array is resynced at creation.  From Linux version 3.0,
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

