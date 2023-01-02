Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D7CC3DA7A
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjABIhd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjABIhX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82372C19
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648642; x=1704184642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lIhFgT/pHZsAr6Hnv+a5xCy2NlbV5Jpy2PnZxU0IY+M=;
  b=k1XQzo8u//uXrBVwVqYoFmQ/dFdf7tTxxZcQzqs+eSw2BuBCh+bpXokZ
   eATEIEwjpj7b2/Yp9VQsbA4SfN/TEMvHGZJPlkMQzruc/Zb9srBGFnpYB
   MGdfr/atWiCw2oJ5TV3OAiwqaMolDu+GSP/Frlgsm8oYMYU4x4Gg2YdJc
   a9npNTtGdI8Ng8lWreiOAY2I0LfjhImrQQe2LXOEdzm9pbhV7pQNTs9t9
   Hv8FkRiXdWnz1068iyJAX9nMYvz3VP4L/ay4hCsOt/oU0dkwSZ9xXIdYZ
   nJE2G90OK1ouYk9Me+2mRg1OpDO+2WZpjDS1usNpbYDQqKXCp2MT+O+Fj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685323"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685323"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864628"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864628"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:37:19 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 03/10] Add code specific update options to enum.
Date:   Mon,  2 Jan 2023 09:35:17 +0100
Message-Id: <20230102083524.28893-4-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
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
index 51f1db2d..31db25f5 100644
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

