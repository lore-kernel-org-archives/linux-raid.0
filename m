Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32094C433E0
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B4C6501D
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCEMCY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:02:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:41384 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhCEMBs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Mar 2021 07:01:48 -0500
IronPort-SDR: f3Mq7fzXfEETfZ5pSLWOCphS/ikCf0qNihqOV1jH4rHAw1gB5lQrmoahZbHfLhZLTjJaP4MLRk
 lx/IKLoPgfiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="207371014"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="207371014"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:01:45 -0800
IronPort-SDR: MWMuoVkZnKV57CGv2SMxMRoBMf2L84mnV3UoudpRXnkSd+nvDDJrav5OXfAsy59yCtmDtbDtI1
 igBTD80V2/Sw==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401656569"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:01:44 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/8] Modify mdstat parsing for volumes with the bitmap
Date:   Thu, 24 Sep 2020 20:02:57 -0400
Message-Id: <20200925000304.169728-2-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
References: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

Current mdstat read functionality is not working correctly
for the volumes with the write-intent bitmap.
It affects rebuild and reshape use cases.

Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
Change-Id: I5288fbfb7d6a85b2aa8452675a6e3559bf4fe934
---
 mdstat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mdstat.c b/mdstat.c
index dd96cca7..2fd792c5 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -191,6 +191,12 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 			else if (strcmp(w, "inactive") == 0) {
 				ent->active = 0;
 				in_devs = 1;
+			} else if (strcmp(w, "bitmap:") == 0) {
+				/* We need to stop parsing here;
+				 * otherwise, ent->raid_disks will be
+				 * overwritten by the wrong value.
+				 */
+				break;
 			} else if (ent->active > 0 &&
 				 ent->level == NULL &&
 				 w[0] != '(' /*readonly*/) {
-- 
2.26.2

