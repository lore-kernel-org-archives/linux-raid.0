Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CD2C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiG1MWJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235742AbiG1MVy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800ED4AD4B
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:52 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 438DB1FD87;
        Thu, 28 Jul 2022 12:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tjCkmvKLj0dHvVKXuabGLsYskKvcBfqN/98BuZp95gM=;
        b=0/rI2FQfN7n6nBawj1G4FU1ca447ERzMdfUjezigi0blog4t6+LxfijNU3oK0eKYV3SKSe
        3gY2Ku+Hf7PYpUOS7Be+nIZsW23IWkS8TzAFIpbf/ZVsFxOpNJfB0154tKgSC2MBvoZqW1
        i0wX7i5bMXPsBeHJqSTB2XNW6nDrPRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010911;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tjCkmvKLj0dHvVKXuabGLsYskKvcBfqN/98BuZp95gM=;
        b=FDxlHKCPUgmF5xkwBU1bWASaURksF/D8mYSGcQIMDwdV6Gvc4fSQdcivp98+lrLy0I2EpI
        Ozua+y9IAXpQ85Cw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 591AA2C141;
        Thu, 28 Jul 2022 12:21:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 10/23] tests/04update-metadata: avoid passing chunk size to raid1
Date:   Thu, 28 Jul 2022 20:20:48 +0800
Message-Id: <20220728122101.28744-11-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

'04update-metadata' test fails with error, "specifying chunk size is
forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
correcting the test to ignore passing chunk size to raid1.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
[logang@deltatee.com: fix if/then style and dropped unrelated hunk]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 tests/04update-metadata | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/04update-metadata b/tests/04update-metadata
index 08c14af7..2b72a303 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -11,7 +11,11 @@ dlist="$dev0 $dev1 $dev2 $dev3"
 for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
-  mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  if [[ $l == 'raid1' ]]; then
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
+  else
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  fi
   testdev $md0 $s 19904 64
   mdadm -S $md0
   mdadm -A $md0 --update=metadata $dlist
-- 
2.35.3

