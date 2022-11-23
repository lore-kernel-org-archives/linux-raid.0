Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA61C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 19:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbiKWTKG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239765AbiKWTKE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 14:10:04 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDB98FB1A
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=bEvuirV01yQz9L2a6Cvbj9KL8+zwytplhbfj5fXDfJI=; b=F/EwBRvCFIc5zOZtHNfmqvmrUE
        GSmlmmmyMX0bfcl/hO/aodN3vpM0p6hPCOTQE3qc6JP/HgEZDKnMqOu8lNa2OtdN4AjPo94YzDm57
        pHwfxj9kwc7DsHThaQHNq0kTrllFG7cyfHOgxsXrghfwIdnQOsT/BnhZQHvI0Y70fsMjeG79X4Qiy
        MrTT0uN+zUYukfH+Pm7fCulQnhvT5ktI7yuDcxXFlrI6ujvWOAFBZHGvYftF4FcdQ0HnwFDg4T/G/
        oNicXGYOVKXoDpEHM0ksGxA5+eQGYsfOeEquEGseYl9phJUfPS3rgwmO3aNAoj1amt5bJaoH95He7
        2ms3qPaQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv8C-009Sj1-5r; Wed, 23 Nov 2022 12:10:00 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv89-000Opn-BY; Wed, 23 Nov 2022 12:09:57 -0700
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
Date:   Wed, 23 Nov 2022 12:09:54 -0700
Message-Id: <20221123190954.95391-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123190954.95391-1-logang@deltatee.com>
References: <20221123190954.95391-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v6 7/7] manpage: Add --write-zeroes option to manpage
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Document the new --write-zeroes option in the manpage.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
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

