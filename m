Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545DBC32772
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343903AbiHRO6i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343902AbiHRO6X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:58:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFE5767E
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834699; x=1692370699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lG9CEH0+VHoRlvfhByJYLvpdKHUKN/dvMvz/N8vlL6c=;
  b=RXA6Q2qYsYVYJPGW3hpDFymfaB6jA9P5f/eGRhf7LIymaKLhm1EOFeL/
   M8saumCQzzgsZQM7zlMW1DK5AtxfUpsuuQJloM0gIN5e3iPvA+Rud4AHD
   O5tGshV/Rl5vAc8tgzxAWIDSonWthgy/wYNTcTkNBtHPVYhNd4FRCmz6C
   boHpTJeSTZfxIpDNhJnmZZ76tJppjOCLOoL31opS3ydz5ngCIy3zhc2e5
   +8RfweVVjGxyvvB8XU7fdiS9pGiipa8GogAkhH+XaP0DEpLe7+EkkroXx
   L08KyX1UYbFwyZjKFAdP5OumfjgRaokdXxVCzzqabgDoHV0iOQUR4Fyjd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292774671"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="292774671"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084734"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:58:10 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 07/10] super-intel: refactor the code for enum
Date:   Thu, 18 Aug 2022 16:56:18 +0200
Message-Id: <20220818145621.21982-8-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It prepares super-intel for change context->update to enum.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super-intel.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 672f946e..3de3873e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3930,7 +3930,8 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 
 	mpb = super->anchor;
 
-	if (strcmp(update, "uuid") == 0) {
+	switch (map_name(update_options, update)) {
+	case UOPT_UUID:
 		/* We take this to mean that the family_num should be updated.
 		 * However that is much smaller than the uuid so we cannot really
 		 * allow an explicit uuid to be given.  And it is hard to reliably
@@ -3954,10 +3955,14 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 		}
 		if (rv == 0)
 			mpb->orig_family_num = info->uuid[0];
-	} else if (strcmp(update, "assemble") == 0)
+		break;
+	case UOPT_SPEC_ASSEMBLE:
 		rv = 0;
-	else
+		break;
+	default:
 		rv = -1;
+		break;
+	}
 
 	/* successful update? recompute checksum */
 	if (rv == 0)
@@ -7888,18 +7893,25 @@ static int kill_subarray_imsm(struct supertype *st, char *subarray_id)
 
 	return 0;
 }
-
-static int get_rwh_policy_from_update(char *update)
+/**
+ * get_rwh_policy_from_update() - Get the rwh policy for update option.
+ * @update: Update option.
+ */
+static int get_rwh_policy_from_update(enum update_opt update)
 {
-	if (strcmp(update, "ppl") == 0)
+	switch (update) {
+	case UOPT_PPL:
 		return RWH_MULTIPLE_DISTRIBUTED;
-	else if (strcmp(update, "no-ppl") == 0)
+	case UOPT_NO_PPL:
 		return RWH_MULTIPLE_OFF;
-	else if (strcmp(update, "bitmap") == 0)
+	case UOPT_BITMAP:
 		return RWH_BITMAP;
-	else if (strcmp(update, "no-bitmap") == 0)
+	case UOPT_NO_BITMAP:
 		return RWH_OFF;
-	return -1;
+	default:
+		break;
+	}
+	return UOPT_UNDEFINED;
 }
 
 static int update_subarray_imsm(struct supertype *st, char *subarray,
@@ -7909,7 +7921,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 
-	if (strcmp(update, "name") == 0) {
+	if (map_name(update_options, update) == UOPT_NAME) {
 		char *name = ident->name;
 		char *ep;
 		int vol;
@@ -7943,7 +7955,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			}
 			super->updates_pending++;
 		}
-	} else if (get_rwh_policy_from_update(update) != -1) {
+	} else if (get_rwh_policy_from_update(map_name(update_options, update)) != UOPT_UNDEFINED) {
 		int new_policy;
 		char *ep;
 		int vol = strtoul(subarray, &ep, 10);
@@ -7951,7 +7963,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 		if (*ep != '\0' || vol >= super->anchor->num_raid_devs)
 			return 2;
 
-		new_policy = get_rwh_policy_from_update(update);
+		new_policy = get_rwh_policy_from_update(map_name(update_options, update));
 
 		if (st->update_tail) {
 			struct imsm_update_rwh_policy *u = xmalloc(sizeof(*u));
-- 
2.26.2

