Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1D3C4167B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjABIhf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjABIhb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD2C10FD
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648649; x=1704184649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hPGzgyKKIOG70MyJO5bqbqgutnXydnL3C9SV1WvjVRs=;
  b=bVFVYBVADZ6vXCAtVKJyY0d7AwZ1ROZLNECb05sMSmrs2wINSYhF0Anp
   Zj2bkNj9sA1Pwl+TBM+5E2CXP2/7ld/wUpH34JV7dUMotEBFzJXIAETyc
   /lzsTq2Ew8sYkP+ZRT2YH72IjnNqaItVjUnW1cIl594UzEywOqdo+0m/a
   bdx181CLccSX3B5I9LIzbhwMZWPPMNn882M8Y7oacku7MHq6iv/+qtL0H
   wqxa1eUyxVth9qPheBNWYMMg6DIQxKs51zLIqgAnrb0eaM7rjgHv1qs5c
   oCVebXM0PTRdFZrhKPYxIS6u0Vol05sqNzo78twa7NksscO3i8tKqmQY0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685329"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685329"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:37:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864632"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864632"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:37:27 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 04/10] super-ddf: Remove update_super_ddf.
Date:   Mon,  2 Jan 2023 09:35:18 +0100
Message-Id: <20230102083524.28893-5-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is not supported by ddf.
It hides errors by returning success status for some updates.
Remove update_super_dff().

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super-ddf.c | 70 -----------------------------------------------------
 1 file changed, 70 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 9d1e3b94..309812df 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2139,75 +2139,6 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 		}
 }
 
-static int update_super_ddf(struct supertype *st, struct mdinfo *info,
-			    char *update,
-			    char *devname, int verbose,
-			    int uuid_set, char *homehost)
-{
-	/* For 'assemble' and 'force' we need to return non-zero if any
-	 * change was made.  For others, the return value is ignored.
-	 * Update options are:
-	 *  force-one : This device looks a bit old but needs to be included,
-	 *        update age info appropriately.
-	 *  assemble: clear any 'faulty' flag to allow this device to
-	 *		be assembled.
-	 *  force-array: Array is degraded but being forced, mark it clean
-	 *	   if that will be needed to assemble it.
-	 *
-	 *  newdev:  not used ????
-	 *  grow:  Array has gained a new device - this is currently for
-	 *		linear only
-	 *  resync: mark as dirty so a resync will happen.
-	 *  uuid:  Change the uuid of the array to match what is given
-	 *  homehost:  update the recorded homehost
-	 *  name:  update the name - preserving the homehost
-	 *  _reshape_progress: record new reshape_progress position.
-	 *
-	 * Following are not relevant for this version:
-	 *  sparc2.2 : update from old dodgey metadata
-	 *  super-minor: change the preferred_minor number
-	 *  summaries:  update redundant counters.
-	 */
-	int rv = 0;
-//	struct ddf_super *ddf = st->sb;
-//	struct vd_config *vd = find_vdcr(ddf, info->container_member);
-//	struct virtual_entry *ve = find_ve(ddf);
-
-	/* we don't need to handle "force-*" or "assemble" as
-	 * there is no need to 'trick' the kernel.  When the metadata is
-	 * first updated to activate the array, all the implied modifications
-	 * will just happen.
-	 */
-
-	if (strcmp(update, "grow") == 0) {
-		/* FIXME */
-	} else if (strcmp(update, "resync") == 0) {
-//		info->resync_checkpoint = 0;
-	} else if (strcmp(update, "homehost") == 0) {
-		/* homehost is stored in controller->vendor_data,
-		 * or it is when we are the vendor
-		 */
-//		if (info->vendor_is_local)
-//			strcpy(ddf->controller.vendor_data, homehost);
-		rv = -1;
-	} else if (strcmp(update, "name") == 0) {
-		/* name is stored in virtual_entry->name */
-//		memset(ve->name, ' ', 16);
-//		strncpy(ve->name, info->name, 16);
-		rv = -1;
-	} else if (strcmp(update, "_reshape_progress") == 0) {
-		/* We don't support reshape yet */
-	} else if (strcmp(update, "assemble") == 0 ) {
-		/* Do nothing, just succeed */
-		rv = 0;
-	} else
-		rv = -1;
-
-//	update_all_csum(ddf);
-
-	return rv;
-}
-
 static void make_header_guid(char *guid)
 {
 	be32 stamp;
@@ -5211,7 +5142,6 @@ struct superswitch super_ddf = {
 	.match_home	= match_home_ddf,
 	.uuid_from_super= uuid_from_super_ddf,
 	.getinfo_super  = getinfo_super_ddf,
-	.update_super	= update_super_ddf,
 
 	.avail_size	= avail_size_ddf,
 
-- 
2.26.2

