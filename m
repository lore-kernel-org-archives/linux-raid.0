Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E82C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbiHRO5r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbiHRO5q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:57:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBBCBD085
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834665; x=1692370665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KDl7oAZcLzUV1tCjtV738SirG9mN3K9CJHylgmLD/ic=;
  b=CDrk2UDIKZirN0UWQcJxh3C774OeZoJrFiKK64clB+NLExZ+4gddvTOr
   /xlkn+I0aweyen4WabcbKvhGGRoNb8wMf2qDtLv1e3G+qVhO6DXcD4uYS
   EdKjMtmry/IiUGlkJGEiMuUQaD8rJ3x8mlvLu6gLXM+mq1MSfC3F+oyul
   dCVKkEFQmWeR729AtpXfYaP5YWESoS81mJQxwO3wpi43pv3qKhIKscRXK
   4bHNvCZ/GfZQFHx2TJoRACZDgV6B3J2CREUD66szvWlyhurjHmDsATv1Z
   LsEF1JWU2xmVyMP/J1nkzf8JDwmlipH7Uo7l9G8BOrKmg5DHg6WwhSlhM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318799017"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="318799017"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084547"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:57:44 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 04/10] super-ddf: Remove update_super_ddf.
Date:   Thu, 18 Aug 2022 16:56:15 +0200
Message-Id: <20220818145621.21982-5-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
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
index 949e7d15..ec59b8af 100644
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

