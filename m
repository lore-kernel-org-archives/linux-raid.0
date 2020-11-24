Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C24EC56201
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 14:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108A5206F9
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgKXO7D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 09:59:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:60773 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388165AbgKXO7D (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 09:59:03 -0500
IronPort-SDR: 8A47/15Sfyz50udPDg/vqJ0tVhIyUVEKHTedKXi4/gsLyxW0GEroInHLXX/vj/mBvl13LA0LCh
 gFmV3ExgI1xA==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="169393342"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="169393342"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 06:59:03 -0800
IronPort-SDR: CNYHSh6Uq431uYBG8IRogEKY2HWwJ7Bud+v0GCDwWmOXwJgS3iLoVun3/n/CYnEHFL5GGsjhfV
 qE5Fxyk+RF+g==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="536496442"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 06:59:02 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: remove redundant calls to imsm_get_map
Date:   Tue, 24 Nov 2020 15:58:53 +0100
Message-Id: <20201124145853.1482-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

MAP_0 is gotten and the beginning, there is no need to get it again.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9562064..95f4eaf 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8598,7 +8598,6 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 				break;
 			}
 			end_migration(dev, super, map_state);
-			map = get_imsm_map(dev, MAP_0);
 			map->failed_disk_num = ~0;
 			super->updates_pending++;
 			a->last_checkpoint = 0;
@@ -8610,7 +8609,6 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 				end_migration(dev, super, map_state);
 			else
 				map->map_state = map_state;
-			map = get_imsm_map(dev, MAP_0);
 			map->failed_disk_num = ~0;
 			super->updates_pending++;
 			break;
-- 
2.25.0

