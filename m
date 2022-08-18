Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C200C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343867AbiHRO5n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbiHRO5l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:57:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D06BCC35
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834660; x=1692370660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J0+IUAABr/57esZX45e23Mwlxk7zFXCHaU/9RhLS4JU=;
  b=H4URPZqDc+PJhS/FcM9XA4Ilkk3CJ4CQDwUJpMxoRvcZMuGodABTVV67
   TusyiJtidXTdiw0ZHbP9ND5p5968WMFWZdNOhCxQQIvlHXNlk/F/cyA6O
   WCCcXwpRvzQLs/oYweNSOMLz8vBKMd7rpZvxV2ziI9vCVCORO7HL+gmG5
   bSxcYgbuxFx7ZbVJx9kb23MthO15kATiCSFwfAXgZMABl4VoZKXyoZKDJ
   bQQlt0P4Or1wbDCWJYffUibxdJ1Mb7vz0khYNeGUPv6JWXN/9dae5QVZ/
   y5rE45X4SdSghiIkJUNUsVfK+eTKRoeaVsD143cBYV/T9cP0UXZOMt9B4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="293567487"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="293567487"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:57:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084482"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:57:36 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 03/10] Add code specific update options to enum.
Date:   Thu, 18 Aug 2022 16:56:14 +0200
Message-Id: <20220818145621.21982-4-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some of update options aren't taken from user input, but are hard-coded
as strings.
Include those options in enum.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 maps.c  | 21 +++++++++++++++++++++
 mdadm.h | 15 +++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/maps.c b/maps.c
index b586679a..c59036f1 100644
--- a/maps.c
+++ b/maps.c
@@ -194,6 +194,27 @@ mapping_t update_options[] = {
 	{ "byteorder", UOPT_BYTEORDER },
 	{ "help", UOPT_HELP },
 	{ "?", UOPT_HELP },
+	/*
+	 * Those enries are temporary and will be removed in this patchset.
+	 *
+	 * Before update_super:update can be changed to enum,
+	 * all update_super sub-functions must be adapted first.
+	 * Update options will be passed as string (as it is for now),
+	 * and then mapped, so all options must be handled temporarily.
+	 *
+	 * Those options code specific and should not be accessible for user.
+	 */
+	{ "force-one", UOPT_SPEC_FORCE_ONE },
+	{ "force-array", UOPT_SPEC_FORCE_ARRAY },
+	{ "assemble", UOPT_SPEC_ASSEMBLE },
+	{ "linear-grow-new", UOPT_SPEC_LINEAR_GROW_NEW },
+	{ "linear-grow-update", UOPT_SPEC_LINEAR_GROW_UPDATE },
+	{ "_reshape_progress", UOPT_SPEC__RESHAPE_PROGRESS },
+	{ "writemostly", UOPT_SPEC_WRITEMOSTLY },
+	{ "readwrite", UOPT_SPEC_READWRITE },
+	{ "failfast", UOPT_SPEC_FAILFAST },
+	{ "nofailfast", UOPT_SPEC_NOFAILFAST },
+	{ "revert-reshape-nobackup", UOPT_SPEC_REVERT_RESHAPE_NOBACKUP },
 	{ NULL, UOPT_UNDEFINED}
 };
 
diff --git a/mdadm.h b/mdadm.h
index 43e6b544..7bc31b16 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -523,6 +523,21 @@ enum update_opt {
 	UOPT_LAYOUT_UNSPECIFIED,
 	UOPT_BYTEORDER,
 	UOPT_HELP,
+	UOPT_USER_ONLY,
+	/*
+	 * Code specific options, cannot be set by the user
+	 */
+	UOPT_SPEC_FORCE_ONE,
+	UOPT_SPEC_FORCE_ARRAY,
+	UOPT_SPEC_ASSEMBLE,
+	UOPT_SPEC_LINEAR_GROW_NEW,
+	UOPT_SPEC_LINEAR_GROW_UPDATE,
+	UOPT_SPEC__RESHAPE_PROGRESS,
+	UOPT_SPEC_WRITEMOSTLY,
+	UOPT_SPEC_READWRITE,
+	UOPT_SPEC_FAILFAST,
+	UOPT_SPEC_NOFAILFAST,
+	UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
 	UOPT_UNDEFINED
 };
 extern void fprint_update_options(FILE *outf, enum update_opt update_mode);
-- 
2.26.2

