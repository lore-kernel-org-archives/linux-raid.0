Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CD1C7EE2F
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjE2Nyo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjE2NyF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:54:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950C5189
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685368405; x=1716904405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PfDlo2dEZ18hNOK32FMKOQwfFlYHKWy5MgeR6cfIr3Q=;
  b=el0JzyLFRXtphywyyK2QuHCWSNkN0pZZAXluWgs/RHNOonXg+1FLTWgX
   zIrdq1JKUjs26KcEpO4a2vWAuHLsgiH5sdVE8CSTFLmlg/ZGMPNYu2LME
   A3NqXRLf0f0iNPYAgjQJwGEUkYDmOq+Wf4rGk8R1rJbz/gEBVow4XU75J
   FwKvF/Wx3/zV7RJ+rB+n8SZFfpkXN3aLx65ZiDLByaMBjXI0/MVlDGmkI
   bh6f72Cn4kuiUd6azqXcKp65ZJJUtek82UzYPYbjPAMZ+Pimbr+CYyF3D
   lc4r7g8vAucpCJwpNaPED9DqimVR3q3mspfOH+oJz6oJL62N1Fpsz/tLF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418193854"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418193854"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:52:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706069263"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="706069263"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:52:57 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 2/6] imsm: imsm_get_free_size() refactor.
Date:   Mon, 29 May 2023 15:52:34 +0200
Message-Id: <20230529135238.18602-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
References: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Move minsize calculations up. Add error message if free size is too small.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 81d6ecd9..3cbab545 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7542,7 +7542,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
  * @super: &intel_super pointer, not NULL.
  * @raiddisks: number of raid disks.
  * @size: requested size, could be 0 (means max size).
- * @chunk: requested chunk.
+ * @chunk: requested chunk size in KiB.
  * @freesize: pointer for returned size value.
  *
  * Return: &IMSM_STATUS_OK or &IMSM_STATUS_ERROR.
@@ -7562,14 +7562,15 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 	struct dl *dl;
 	int i;
 	struct extent *e;
+	int cnt = 0;
+	int used = 0;
 	unsigned long long maxsize;
-	unsigned long long minsize;
-	int cnt;
-	int used;
+	unsigned long long minsize = size;
+
+	if (minsize == 0)
+		minsize = chunk * 2;
 
 	/* find the largest common start free region of the possible disks */
-	used = 0;
-	cnt = 0;
 	for (dl = super->disks; dl; dl = dl->next) {
 		dl->raiddisk = -1;
 
@@ -7593,14 +7594,14 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 	}
 
 	maxsize = merge_extents(super);
-	minsize = size;
-	if (size == 0)
-		/* chunk is in K */
-		minsize = chunk * 2;
+	if (maxsize < minsize)  {
+		pr_err("imsm: Free space is %llu but must be equal or larger than %llu.\n",
+		       maxsize, minsize);
+		return IMSM_STATUS_ERROR;
+	}
 
-	if (cnt < raiddisks || (super->orom && used && used != raiddisks) ||
-	    maxsize < minsize || maxsize == 0) {
-		pr_err("not enough devices with space to create array.\n");
+	if (cnt < raiddisks || (super->orom && used && used != raiddisks)) {
+		pr_err("imsm: Not enough devices with space to create array.\n");
 		return IMSM_STATUS_ERROR;
 	}
 
-- 
2.26.2

