Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47820338
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573797; cv=none; b=nFTmEzmxOryforfQo2gXJjPvbTE2US5fTEwwhGgD72OJ0avzC35w3KQB10IyY7W63bduMkZleq5qZdMmM7pGh1RyJ21FTqXC25P+GQsTTQh8GM/htAmw2MWvgG4sm1lD3Dszyf+zTVZl15ENmC4owx2VnL3s7RQD3njwPzX8eUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573797; c=relaxed/simple;
	bh=eZQFuw/im5WJjdB7DbhncZqxTODAosTsMYMGZmucTZs=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding; b=WKKrz/I6x0rbyXeh6qNNy6WbMJzfpiRLGb3JHMLXg4UE8Fx82/632203GknQNZ7d9Nyyx5fEGqGHM1tNw08uGTX5p8ouElD00bW1LOzpZv8dIRIltnfOj5QclFBQ00cUlPmrNNS48loE9VBTosOYVXZwk1bTTKy19F122h9SHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NFTrKg0J; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NFTrKg0J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573795; x=1737109795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eZQFuw/im5WJjdB7DbhncZqxTODAosTsMYMGZmucTZs=;
  b=NFTrKg0JiEpzgfHbw1H67EsW+nBrpHqfNB5qL3A7IkTBdZkbV3rLb5bo
   6foTjp4xiGbWiLRGkjkrmCGdDpyOVwj0E14b3GWxt2QN2sgo9FvM89xWp
   HRRXjAY/rE1YBK+V8cC8NhzqqKXtiW2LSq81yHn6iQJVZm7pLfyF9PmBC
   jwj4bW9FtD0Xj4iA7RukfQ1OXfOxkjikxPb0xPHg3dl9+zIw9cBdKFNml
   mgzUHoVB7ZZuuNE90yzBzulQHu5jHZYWQceB2/mGhQ1CoA68l9hpEvOaM
   QlRNP4LsJPW8fVJNdZSQUrDG7c3g6WCdnmPYNU1dRzyCXLA+adO7Zsx+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="486563804"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="486563804"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:29:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="26735691"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 18 Jan 2024 02:29:54 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 3/3] super-intel: Remove inaccessible code
Date: Thu, 18 Jan 2024 11:28:42 +0100
Message-Id: <20240118102842.12304-4-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240118102842.12304-1-mateusz.kusiak@intel.com>
References: <20240118102842.12304-1-mateusz.kusiak@intel.com>
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
index 01fcc6b3bfb6..6a664a2e58d3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8678,23 +8678,6 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
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

