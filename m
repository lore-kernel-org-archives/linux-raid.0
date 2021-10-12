Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06889C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 10:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E10D26101D
	for <linux-raid@archiver.kernel.org>; Tue, 12 Oct 2021 10:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhJLKRd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Oct 2021 06:17:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:41819 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235832AbhJLKRc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Oct 2021 06:17:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="207217243"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="207217243"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 03:15:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="480291684"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.97])
  by orsmga007.jf.intel.com with ESMTP; 12 Oct 2021 03:15:30 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] Assemble: apply sysfs rules
Date:   Tue, 12 Oct 2021 12:16:16 +0200
Message-Id: <20211012101616.14794-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

During assemblation container with quiet flag, sysfs rules are not applied.
This commit makes sysfs_rules_apply() independent from verbose condition.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 0df46244..20fd97b5 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1125,6 +1125,7 @@ static int start_array(int mdfd,
 	}
 
 	if (content->array.level == LEVEL_CONTAINER) {
+		sysfs_rules_apply(mddev, content);
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
 			       mddev, okcnt + sparecnt + journalcnt,
@@ -1132,10 +1133,8 @@ static int start_array(int mdfd,
 			if (okcnt < (unsigned)content->array.raid_disks)
 				fprintf(stderr, " (out of %d)\n",
 					content->array.raid_disks);
-			else {
+			else
 				fprintf(stderr, "\n");
-				sysfs_rules_apply(mddev, content);
-			}
 		}
 
 		if (st->ss->validate_container) {
-- 
2.26.2

