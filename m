Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E05C25B08
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 12:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbiHQMGK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Aug 2022 08:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239326AbiHQMFv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Aug 2022 08:05:51 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4225985FE0
        for <linux-raid@vger.kernel.org>; Wed, 17 Aug 2022 05:05:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660737941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnFOAPjq79TWgK/Y04oyk4luIKOEqpaPumfEGW8kbVc=;
        b=dWzH1w2m/0B5ZUIZ/uZVLcGSQSJxDSZ025M4ncV7z5AvGgc1a9C3W0FUg2WwoZbQdGCsFB
        X+AD47d6MRgn1qt3+IVA69FYl7eQ4j4H2vbYDrg5uBfLLV7uEd0kInYy3GEPNTp2UY6fw6
        DW8ehNsHAk4idzI+bi3fTj/Bu/72I7k=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     neilb@suse.de, mpatocka@redhat.com
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 2/2] md: call __md_stop_writes in md_stop
Date:   Wed, 17 Aug 2022 20:05:14 +0800
Message-Id: <20220817120514.5536-3-guoqing.jiang@linux.dev>
In-Reply-To: <20220817120514.5536-1-guoqing.jiang@linux.dev>
References: <20220817120514.5536-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From the link [1], we can see raid1d was running even after the path
raid_dtr -> md_stop -> __md_stop.

Let's stop write first in destructor to align with normal md-raid to
fix the KASAN issue.

[1]. https://lore.kernel.org/linux-raid/CAPhsuW5gc4AakdGNdF8ubpezAuDLFOYUO_sfMZcec6hQFm8nhg@mail.gmail.com/T/#m7f12bf90481c02c6d2da68c64aeed4779b7df74a

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 76acd2c72f84..8b43cf328dc3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6260,6 +6260,7 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
+	__md_stop_writes(mddev);
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-- 
2.31.1

