Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65986C3DA7A
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjABIiA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjABIh4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:56 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40056C19
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648675; x=1704184675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5NrnZa4XntvvSmOu0Tl/W69HOdTjeyIZmMfxWx5XCxw=;
  b=Wdumy+LudQnEVp9kZyAM4wFXAO8JzyLguHgbxnQV31g7b6wk7EhPvnjZ
   c6AG0xG3QxpzfQHvZpVX6wAxwiZvnyUp4p2pco0IGqtQOtBG0KeQKzotZ
   f30Vhb+7AP3Dtqty4qky85jMR99y9n9aKSZ3CIJZgPz+K6QKQvjC1LQKr
   3SKcgrG/L9rc/HRRg9BBY6i5qLgQpV10CZuxWs6Oto6E5RY3pg/x5lTsf
   FToFenkikLfC7+n081tRrG6+quFbdyfmw4Klg058DLg3Gy6KQsWG6nJz6
   QM2BQmK0rbgjouFilgv+Z5XDD/kZiC4nbwqjjolh3oh7KOQoCloOEH3xB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685362"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685362"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:37:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864660"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864660"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:37:52 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 07/10] super-intel: refactor the code for enum
Date:   Mon,  2 Jan 2023 09:35:21 +0100
Message-Id: <20230102083524.28893-8-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It prepares super-intel for change context->update to enum.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super-intel.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5f93f3d3..85fb7f17 100644
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
@@ -7889,17 +7894,25 @@ static int kill_subarray_imsm(struct supertype *st, char *subarray_id)
 	return 0;
 }
 
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
@@ -7909,7 +7922,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 
-	if (strcmp(update, "name") == 0) {
+	if (map_name(update_options, update) == UOPT_NAME) {
 		char *name = ident->name;
 		char *ep;
 		int vol;
@@ -7943,7 +7956,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			}
 			super->updates_pending++;
 		}
-	} else if (get_rwh_policy_from_update(update) != -1) {
+	} else if (get_rwh_policy_from_update(map_name(update_options, update)) != UOPT_UNDEFINED) {
 		int new_policy;
 		char *ep;
 		int vol = strtoul(subarray, &ep, 10);
@@ -7951,7 +7964,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 		if (*ep != '\0' || vol >= super->anchor->num_raid_devs)
 			return 2;
 
-		new_policy = get_rwh_policy_from_update(update);
+		new_policy = get_rwh_policy_from_update(map_name(update_options, update));
 
 		if (st->update_tail) {
 			struct imsm_update_rwh_policy *u = xmalloc(sizeof(*u));
-- 
2.26.2

