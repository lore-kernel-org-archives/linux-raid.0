Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80610C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Apr 2022 14:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiDGOao (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Apr 2022 10:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiDGOah (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Apr 2022 10:30:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D51959C2
        for <linux-raid@vger.kernel.org>; Thu,  7 Apr 2022 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649341704; x=1680877704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YlepH2cXqH2l3b8yV47Fx6TAf5k51fKfGZ3QpS59gKU=;
  b=g5cOtEJMhJDP8xytxCkOg8I5v0DuOioghmXLjfkSX6f7Ab5i44wiQrCA
   sJK4qFBqsGTRdG/vcjlcTzZmmPb1T0TvYfJ50mTHdGaZ5DwU4+YYupP/l
   jsBN9lZrYTFHJVqURt8Ge8fZke6Sv0HfeYg3e2jQqZECIHcX31lfGqkEU
   jyhnR0Q2Hz//ICZV5pg3KuegCaa6v4UjaMGybyNIlTNdjWjRau54Y+S6L
   KMlQl3FT7f0/ESwa43m2rX6x8YXzn19ZFsE9NYkVmZZYewM0sy+z+HOyg
   Amk9qgSepOMnHaJbuFm7qsZaoC8gAWXXCiWePyQYG7rXHcINlmrjpqZgI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10309"; a="261513381"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="261513381"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 07:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="659077549"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2022 07:28:22 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de, pmenzel@molgen.mpg.de
Subject: [PATCH 2/2] mdadm: Remove dead code in imsm_fix_size_mismatch
Date:   Thu,  7 Apr 2022 16:27:39 +0200
Message-Id: <20220407142739.60198-3-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

imsm_create_metadata_update_for_size_change() that returns u_size value
could return 0 in the past. As its behavior changed, and returned value
is always the size of imsm_update_size_change structure, check for
u_size is no longer needed.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 super-intel.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 102689bc..cb5292e1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11772,10 +11772,6 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		geo.size = d_size;
 		u_size = imsm_create_metadata_update_for_size_change(st, &geo,
 								     &update);
-		if (u_size < 1) {
-			dprintf("imsm: Cannot prepare size change update\n");
-			goto exit;
-		}
 		imsm_update_metadata_locally(st, update, u_size);
 		if (st->update_tail) {
 			append_metadata_update(st, update, u_size);
-- 
2.27.0

