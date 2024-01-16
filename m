Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEC21B7F3
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRB4vGkg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404392; x=1736940392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCbKk0/5VH+9HxNyYjQyHY92hllY9OFiDQ9w8dW4n48=;
  b=dRB4vGkgwqnZUzz+mTZyrshCKCCCqKABtBWJKPWvaLlEqpuClFV5x/R8
   OspJOMGGd6LWtEZSXitsW2IkvD7SWjarKZ933oRmUy1s1kI7KrBtwXLsO
   3uQDUNRy3CHqpM8wLaFotVpSlmRxnIBGKeCAMMCtePDUsMjTcEKHaPn/v
   0sLXnso2Kb6IY9bYNgrdFPIXHrPzdBSu8+EqMdDnXEfXJeqKxTJqJsyRx
   gsiNi4tecMfnHesOin/UkngISHSzInMEh8U90InKCo3zihx4p6ikzK8J+
   rhmHR5thUaweEMmF6nU/eUWKyzc6K7+GSBmyMcWh4/cG7LjrlZTgxiIQo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307388"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307388"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:26:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26111896"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:26:30 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 6/8] super-intel: Remove inaccessible code
Date: Tue, 16 Jan 2024 12:24:32 +0100
Message-Id: <20240116112434.30705-7-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240116112434.30705-1-mateusz.kusiak@intel.com>
References: <20240116112434.30705-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove inaccessible "if" statement from imsm_set_array_state().

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super-intel.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b4cea60f060a..a3588f2ed4c1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8738,23 +8738,6 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			/* still reshaping, maybe update vol_curr_migr_unit */
 			goto mark_checkpoint;
 		} else {
-			if (a->last_checkpoint == 0 && a->prev_action == reshape) {
-				/* for some reason we aborted the reshape.
-				 *
-				 * disable automatic metadata rollback
-				 * user action is required to recover process
-				 */
-				if (0) {
-					struct imsm_map *map2 =
-						get_imsm_map(dev, MAP_1);
-					dev->vol.migr_state = 0;
-					set_migr_type(dev, 0);
-					set_vol_curr_migr_unit(dev, 0);
-					memcpy(map, map2,
-					       sizeof_imsm_map(map2));
-					super->updates_pending++;
-				}
-			}
 			if (a->last_checkpoint >= a->info.component_size) {
 				unsigned long long array_blocks;
 				int used_disks;
-- 
2.35.3

