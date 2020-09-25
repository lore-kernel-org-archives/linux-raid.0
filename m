Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B9DC4332B
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D5F6502E
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCEMC2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:02:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:35709 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229682AbhCEMCB (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Mar 2021 07:02:01 -0500
IronPort-SDR: udy74EOTCC1TWwPrIO0yc4b58pCBNoJxO1CstqB2ATzefhCCius7H4QJAvhXk+qpgU9XNITYzo
 YS2ZPL9KV3hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="185230257"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="185230257"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:01 -0800
IronPort-SDR: wjaQWHOvGDelOVrN+teMK1rDcDTfKBNAAnlB04chUWl2YQDCbMGx6wbDyO9RUz4gcYwGzN4kiC
 FDOh0MEIshLw==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401656617"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:00 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 5/8] Add "bitmap" to allowed command-line values
Date:   Thu, 24 Sep 2020 20:03:01 -0400
Message-Id: <20200925000304.169728-6-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
References: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

Currently, the sysfs interface allows bitmap setup only when volume
is in an inactive state.
For external metadata to add bitmap to existing volume instead of
GROW, the UPDATE operation can be done.
The patch adds a "bitmap" argument to the allowed values for UPDATE.

Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
Change-Id: Ic46fdc6cc39eba2097a7e4956c44f4a9970e7b05
---
 mdadm.8.in | 13 +++++++++++--
 mdadm.c    |  4 +++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 34a93a8f..c89d901e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2408,9 +2408,11 @@ or
 .B \-\-update=
 option. The supported options are
 .BR name ,
-.B ppl
+.BR ppl ,
+.BR no\-ppl ,
+.BR bitmap
 and
-.BR no\-ppl .
+.BR no\-bitmap .
 
 The
 .B name
@@ -2428,6 +2430,13 @@ and
 options enable and disable PPL in the metadata. Currently supported only for
 IMSM subarrays.
 
+The
+.B bitmap
+and
+.B no\-bitmap
+options enable and disable write-intent bitmap in the metadata. Currently supported only for
+IMSM subarrays.
+
 .TP
 .B \-\-examine
 The device should be a component of an md array.
diff --git a/mdadm.c b/mdadm.c
index 493d70e4..9a4317d5 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -779,6 +779,8 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(c.update, "devicesize") == 0)
 				continue;
+			if (strcmp(c.update, "bitmap") == 0)
+				continue;
 			if (strcmp(c.update, "no-bitmap") == 0)
 				continue;
 			if (strcmp(c.update, "bbl") == 0)
@@ -827,7 +829,7 @@ int main(int argc, char *argv[])
 			fprintf(outf, "Valid --update options are:\n"
 		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'nodes', 'resync',\n"
 		"     'summaries', 'homehost', 'home-cluster', 'byteorder', 'devicesize',\n"
-		"     'no-bitmap', 'metadata', 'revert-reshape'\n"
+		"     'bitmap', 'no-bitmap', 'metadata', 'revert-reshape'\n"
 		"     'bbl', 'no-bbl', 'force-no-bbl', 'ppl', 'no-ppl'\n"
 		"     'layout-original', 'layout-alternate', 'layout-unspecified'\n"
 				);
-- 
2.26.2

