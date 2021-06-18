Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C64C48BDF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1D6611B0
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 13:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhFRN4E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:56:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:64183 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhFRN4E (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 18 Jun 2021 09:56:04 -0400
IronPort-SDR: 9vfMOKkvy/ywHQWgglSzgYv1kk1T8ZtrOtMR+7bLrszjwQE4WSu9nZGveA1HScpyjqpJKNX7Gz
 yxevFHYBkeVA==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="228083613"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="228083613"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:53:55 -0700
IronPort-SDR: u+khXD7UyjdIEcoyOadoWHk7f6NtueafbaSxWeWbjpu2WZ0Ov9pSTOO3n1kc9K4EhqH6Brsg0X
 i9QQqfW7htPw==
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="451401742"
Received: from unknown (HELO gklab-108-126.igk.intel.com) ([10.102.108.126])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 06:53:53 -0700
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Subject: [PATCH 2/3] Remove Spare drives line from details for external metadata
Date:   Fri, 18 Jun 2021 15:53:31 +0200
Message-Id: <20210618135332.11293-2-oleksandr.shchirskyi@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
References: <20210618135332.11293-1-oleksandr.shchirskyi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Arrays with external metadata do not have spare disks directly
assigned to volumes; spare disks belong to containers and are
moved to arrays when the array is degraded/reshaping.
Thus, the display of zero spare disks in volume details is
incorrect and can be confusing.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
---
 Detail.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index cd26fb0f..ad56344f 100644
--- a/Detail.c
+++ b/Detail.c
@@ -548,7 +548,8 @@ int Detail(char *dev, struct context *c)
 			       array.working_disks);
 		if (array.raid_disks) {
 			printf("    Failed Devices : %d\n", array.failed_disks);
-			printf("     Spare Devices : %d\n", array.spare_disks);
+			if (!external)
+				printf("     Spare Devices : %d\n", array.spare_disks);
 		}
 		printf("\n");
 		if (array.level == 5) {
-- 
2.27.0

