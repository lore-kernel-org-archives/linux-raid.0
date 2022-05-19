Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AC8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 19 May 2022 07:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiESHQj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 May 2022 03:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiESHQe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 May 2022 03:16:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB05562F9
        for <linux-raid@vger.kernel.org>; Thu, 19 May 2022 00:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652944590; x=1684480590;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WxTjhBRwe9IbBIvn5KcLAXYIhrVqkGckW7tnDB+7K5I=;
  b=KYfvwZMdwPIwgyzQlzkgnNsqNWLU0jhKoy35jmaUk7rmGUzXZm7GOSU+
   NxZ4aCr/L/UYiVEsrzDc6WeyJIDOnIYzZipV4g0LKll8qF/pxoRu/dbdo
   DhKREw+QMqn0MA7uWAoie8vlQxKh/0rlCY5PZrmgVJwuJ8g7LORZdRLv6
   ujH1GrGFl41q9XMbus8iLLa0OHggoRhm8t+ybcH4xJSyfIQJtnjVg3Kvc
   IDySlsllaVLuPeHO2nYGKi0SaNqMqGzR/WYMc4G2OojdX2i6nEGDLun4+
   wL647C9QCdlvqH4h/P7NAco4IXJyNX69UP/XoWAHsevvBgUOB1IbKRu5q
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="254110643"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="254110643"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 00:16:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="545939796"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by orsmga006.jf.intel.com with ESMTP; 19 May 2022 00:16:28 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Grow: block -n on external volumes.
Date:   Thu, 19 May 2022 09:16:08 +0200
Message-Id: <20220519071608.26259-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Performing --raid-devices on external metadata volume should be blocked
as it causes unwanted behaviour.

Eg. Performing
mdadm -G /dev/md/volume -l10 -n4
on r0_d2 inside 4 disk container, returns
mdadm: Need 2 spares to avoid degraded array, only have 0.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Grow.c b/Grow.c
index 8a242b0f..f6efbc48 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1892,6 +1892,14 @@ int Grow_reshape(char *devname, int fd,
 
 		if (retval) {
 			pr_err("Cannot read superblock for %s\n", devname);
+			close(cfd);
+			free(subarray);
+			return 1;
+		}
+
+		if (s->raiddisks && subarray) {
+			pr_err("--raid-devices operation can be performed on a container only\n");
+			close(cfd);
 			free(subarray);
 			return 1;
 		}
-- 
2.26.2

