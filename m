Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFE9C48BDF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE136117A
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhFRNz7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:55:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:64183 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234059AbhFRNz7 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 18 Jun 2021 09:55:59 -0400
IronPort-SDR: YG6m169GnGmPM5t8jj8yUi/OAh9dpaYD4nZJT+p13OBDdppufZH0+5VZ8mkfHQW9jU574AyI1W
 zPbO6AUB0sPA==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="228083603"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="228083603"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:53:49 -0700
IronPort-SDR: 16ptMKEToSoan8flxtJgqLLB+cz9HEdGIT3g6/bxFqJBa+i2t6qnGR+GPW49ty6N1/OeILgbrw
 /Iagm4zQ2MoQ==
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="451401719"
Received: from unknown (HELO gklab-108-126.igk.intel.com) ([10.102.108.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:53:48 -0700
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Subject: [PATCH 1/3] imsm: correct offset for 4k disks in --examine output
Date:   Fri, 18 Jun 2021 15:53:30 +0200
Message-Id: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

"Sector Offset" field in Examine output was always printed in 512
byte sectors. Update it to support 4096 sector size.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
---
 super-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 54699129..caeb6db3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1663,7 +1663,7 @@ static void print_imsm_dev(struct intel_super *super,
 		   (unsigned long long)sz * 512 / super->sector_size,
 	       human_size(sz * 512));
 	printf("  Sector Offset : %llu\n",
-		pba_of_lba0(map));
+		pba_of_lba0(map) * 512 / super->sector_size);
 	printf("    Num Stripes : %llu\n",
 		num_data_stripes(map));
 	printf("     Chunk Size : %u KiB",
-- 
2.27.0

