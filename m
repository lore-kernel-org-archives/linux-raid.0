Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DA9C43381
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E073A23382
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732745AbhAON1z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:27:55 -0500
Received: from mga18.intel.com ([134.134.136.126]:10827 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbhAON1z (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:27:55 -0500
IronPort-SDR: Aoo3IGqXRORwJRDXNWuqfqn1pEg+yp70G79YnKqx/Qdyj5T8ObYsZA4rbv8XOsgUDQpQ1Zw/2Q
 Gq3NZFP55gQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216187"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216187"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:32 -0800
IronPort-SDR: Qywmzk3OJNoraLLSB9+/WYCrfoFU/42J0v8w5ONUC5JhREQ7ODLSD5ewYDFUggrCpr48M0EvwS
 4vNLsWur0RbQ==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312422"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:31 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 5/8] Add "bitmap" to allowed command-line values
Date:   Fri, 15 Jan 2021 00:46:58 -0500
Message-Id: <20210115054701.92064-6-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
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

