Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC19C19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiG1MVp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiG1MVe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F19A4B0C6
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F234D1FE12;
        Thu, 28 Jul 2022 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgG8zd/cuwJz+QutpHwoeHGTGoQ583pS1DbClNMQ9Ik=;
        b=2FQe3/zBv79EtBJUx0xwTURJrWb3F5f4ApKUDzlXeYZgAhN8Pwol1CWo6Ps4ifHZUcr+U3
        bIsJ+N+Km5ZeXEzlZL5ulTC8l1pmX5RCH1gZlBFq6fyk1YetVqWNLX7DMzqPsuunQTK7HK
        q0nUCZ0EGhMgew+QTwbX24O/dYdllVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010891;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgG8zd/cuwJz+QutpHwoeHGTGoQ583pS1DbClNMQ9Ik=;
        b=Nudh+yl/bnsuHYa3MMyoERpqHdAVPUWtICMwSgAgumV1NlQuQpA0D/Lt0+WrLYlKUVDOPw
        p5/6hCWV3v7LgqDw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 6874B2C141;
        Thu, 28 Jul 2022 12:21:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 05/23] monitor: Avoid segfault when calling NULL get_bad_blocks
Date:   Thu, 28 Jul 2022 20:20:43 +0800
Message-Id: <20220728122101.28744-6-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

Not all struct superswitch implement a get_bad_blocks() function,
yet mdmon seems to call it without checking for NULL and thus
occasionally segfaults in the test 10ddf-geometry.

Fix this by checking for NULL before calling it.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 monitor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/monitor.c b/monitor.c
index b877e595..820a93d0 100644
--- a/monitor.c
+++ b/monitor.c
@@ -311,6 +311,9 @@ static int check_for_cleared_bb(struct active_array *a, struct mdinfo *mdi)
 	struct md_bb *bb;
 	int i;
 
+	if (!ss->get_bad_blocks)
+		return -1;
+
 	/*
 	 * Get a list of bad blocks for an array, then read list of
 	 * acknowledged bad blocks from kernel and compare it against metadata
-- 
2.35.3

