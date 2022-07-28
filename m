Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99692C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiG1MVb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbiG1MVT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802847B82
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:18 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D26073736A;
        Thu, 28 Jul 2022 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdfQ60n78vGGFkDp72HrNREYCO0TbAKVi/mL9sicK0Y=;
        b=DwHsa4Xtoz6y1zYv01vcMRaflNtFmxEKzGNBqyMqNAq1LKgfvkX+OBxd8+iuHVms3YKvzq
        qMv8p8AOYCKfyN4cnByTYLXo+n5a9ayC02FFiyce7UO/Uwoo37Yrc/mA5eCbz1sNFZtwMA
        oSKk46pMGW2uYGIC2e9fEdV8drg922s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010876;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdfQ60n78vGGFkDp72HrNREYCO0TbAKVi/mL9sicK0Y=;
        b=kjMPbjGJzwRqy6gSn3FB0x6HqbCGaV3JB1S9kO1ej5mel8AeiaWoVuILP0R3zVKQAF+0DN
        vdQ978ygTAGrybDg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 9F5D72C141;
        Thu, 28 Jul 2022 12:21:13 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 01/23] Makefile: Don't build static build with everything and everything-test
Date:   Thu, 28 Jul 2022 20:20:39 +0800
Message-Id: <20220728122101.28744-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

Running the test suite requires building everything, but it seems to be
difficult to build the static version of mdadm now seeing there
is no readily available static udev library.

The test suite doesn't need the static binary so just don't build it
with the everything or everything-test targets.

Leave the mdadm.static and install-static targets in place in case
someone still has a use case for the static binary.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bf126033..ec1f99ed 100644
--- a/Makefile
+++ b/Makefile
@@ -182,9 +182,9 @@ check_rundir:
 		echo "***** or set CHECK_RUN_DIR=0"; exit 1; \
 	fi
 
-everything: all mdadm.static swap_super test_stripe raid6check \
+everything: all swap_super test_stripe raid6check \
 	mdadm.Os mdadm.O2 man
-everything-test: all mdadm.static swap_super test_stripe \
+everything-test: all swap_super test_stripe \
 	mdadm.Os mdadm.O2 man
 # mdadm.uclibc doesn't work on x86-64
 # mdadm.tcc doesn't work..
-- 
2.35.3

