Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C9EC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 07:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbiDGHF3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239641AbiDGHF2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 03:05:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C648F235876
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 00:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649315008; x=1680851008;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=miRsj0P/PU0hPz99JesMByEQMGu0SrLNzSaOaWjlbgU=;
  b=a/In0GCpSs8kX8/YjTvv2lQVC25lQW/d2JcylKtODucOCQhCWKZz8nsJ
   UxG/Oa4gfntYIqEBzqR7N6mIIT7NWgSsUwXO/P9qEm0Q+e7c7cMmHNLqW
   VarvWUCt2rpuuT8fLRV4FnEj1o6olX2p4D9k1I1s2YHNr7ZZ8YmzaaIdI
   6CNhJJdID3D5jrxp3+20Vaw+uMihofyEMSkhAN65UJEIcLOUDeRFuU4MG
   D9nrCw0qMqdnjnZ1A/Ad4Q7Q1jeUrSQMy4mriloXbf75wWS+0jaOAhf1A
   R2eATDTxqqhVfCkrd5CATdoV0MVVXoAXFrvrRyE2qHg4n5c9/hKX2TGf1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261424592"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="261424592"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 00:03:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="524805507"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga006.jf.intel.com with ESMTP; 07 Apr 2022 00:03:06 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] mdadm: Fix array size mismatch after grow
Date:   Thu,  7 Apr 2022 09:02:02 +0200
Message-Id: <20220407070202.50421-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

imsm_fix_size_mismatch() is invoked to fix the problem, but it couldn't proceed due to migration check.
This patch allows for intended behavior.

Additionally remove some dead code.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 super-intel.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d5fad102..be6aec90 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11757,7 +11757,7 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		unsigned long long d_size = imsm_dev_size(dev);
 		int u_size;
 
-		if (calc_size == d_size || dev->vol.migr_type == MIGR_GEN_MIGR)
+		if (calc_size == d_size)
 			continue;
 
 		/* There is a difference, confirm that imsm_dev_size is
@@ -11772,10 +11772,7 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		geo.size = d_size;
 		u_size = imsm_create_metadata_update_for_size_change(st, &geo,
 								     &update);
-		if (u_size < 1) {
-			dprintf("imsm: Cannot prepare size change update\n");
-			goto exit;
-		}
+
 		imsm_update_metadata_locally(st, update, u_size);
 		if (st->update_tail) {
 			append_metadata_update(st, update, u_size);
-- 
2.27.0

