Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55FEC19F29
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jul 2022 21:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiG0Vwz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiG0Vwx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Jul 2022 17:52:53 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FB92C66C
        for <linux-raid@vger.kernel.org>; Wed, 27 Jul 2022 14:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=spNn6kAf+cJtNnyeDwvAQxIQMnoncOP4xAI759b8+Vg=; b=mNF54m5u60cwkEioJp95GcmKgL
        zw3rjaAfUpGiFqdLSUaB39Nb2hSLKP4CwX1n2ChMy3L/TdGZMxMCcKL0gqHIyfh/g+4zDsEYHQ54C
        VVrjR5jolP85FFVaN/MTYcTI6u2Uge4S3EQ3WvGvjhsy3oDEyAlMipZ2zMd3yiiniOUz3ZzXLKcAN
        m7Ob+zvZkvju9pslEaARIUMOcFRLvkDBd6Q+aRN/jZ9B+7IcCJeyzcGXyOsyR7jju/v4exVVZCDUb
        654PA8fzeGp9PPJwngSGY6ZJkH+uVOdyMMfnOxT8zf/rcxUJPiq2SeKW6lSm8S2imdjk7R6eCklcT
        kxCm7DYg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxX-001qTf-2b; Wed, 27 Jul 2022 15:52:52 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oGoxU-000VaN-Di; Wed, 27 Jul 2022 15:52:48 -0600
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
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 27 Jul 2022 15:52:45 -0600
Message-Id: <20220727215246.121365-2-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727215246.121365-1-logang@deltatee.com>
References: <20220727215246.121365-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v3 1/2] tests/00readonly: Run udevadm settle before setting ro
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In some recent kernel versions, 00readonly fails with:

  mdadm: failed to set readonly for /dev/md0: Device or resource busy
  ERROR: array is not read-only!

This was traced down to a race condition with udev holding a reference
to the block device at the same time as trying to set it read only.

To fix this, call udevadm settle before setting the array read only.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/00readonly | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/00readonly b/tests/00readonly
index 39202487f614..afe243b3a0b0 100644
--- a/tests/00readonly
+++ b/tests/00readonly
@@ -12,6 +12,7 @@ do
 			$dev1 $dev2 $dev3 $dev4 --assume-clean
 		check nosync
 		check $level
+		udevadm settle
 		mdadm -ro $md0
 		check readonly
 		state=$(cat /sys/block/md0/md/array_state)
-- 
2.30.2

