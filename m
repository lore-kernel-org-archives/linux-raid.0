Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D2AC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbiG1MWD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbiG1MVp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AD212625
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1C1461FD93;
        Thu, 28 Jul 2022 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Z45tB4CelGKpmURZsfPSnPghlwnZRtoeGru3kwenDw=;
        b=lIaL0uZST1ciaLVub715N9oVxSx5VOC84T2s6GhygJ4o4pB1ksUocgTno9+CjtMCjEY0PN
        kwbl+KDXoVYmXCPv2RiSsN6ZyzZbe8voP2BwttYqja4Ku75/uTqd7mTy7g1PVfBeIqHgQx
        GHDFDP1zpEuXyHIU6aMkbVBIWEzMFnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010903;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Z45tB4CelGKpmURZsfPSnPghlwnZRtoeGru3kwenDw=;
        b=yUxUjZG9odxPFkdyxKIu2SnMiIGTkRQf4QMTBk1xEJI7H3W7joPawCveQlCYuOcUq0BWIQ
        jnMZboEWxPs4AUBw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 2D6442C141;
        Thu, 28 Jul 2022 12:21:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 08/23] tests/00raid0: add a test that validates raid0 with layout fails for 0.9
Date:   Thu, 28 Jul 2022 20:20:46 +0800
Message-Id: <20220728122101.28744-9-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

329dfc28debb disallows the creation of raid0 with layouts for 0.9
metadata. This test confirms the new behavior.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 tests/00raid0 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index 8bc18985..e6b21cc4 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -6,11 +6,9 @@ check raid0
 testdev $md0 3 $mdsize2_l 512
 mdadm -S $md0
 
-# now with version-0.90 superblock
+# verify raid0 with layouts fail for 0.90
 mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
-check raid0
-testdev $md0 4 $mdsize0 512
-mdadm -S $md0
+check opposite_result
 
 # now with no superblock
 mdadm -B $md0 -l0 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
-- 
2.35.3

