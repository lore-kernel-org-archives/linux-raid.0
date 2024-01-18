Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E60EA5
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573839; cv=none; b=QmzQuArxxh9IzreeA9bGsjAUjVGCcbgHb2fi43H5zJK+hxQGcyeBUd8DMJTUfU+Vr0warX5OIj+rZJlrubQqNNAkCDq6oyNgcNj+QNfcUjCzUoO55cczyXgvZnMJKTqBsJ4xZERDh7oMFr4iKe1x72cVo5NyJM7PINbVRCpMWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573839; c=relaxed/simple;
	bh=DKnwUS+L9eXjPzconwL6Yc+EhI/8wQ1SrQSU9hTCXS0=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=cF0UM9JiPbFIZg22Fc4M2NmWJTlfYw1a/VZbF0af6kHtXxjj1VVu67LUvR2Wjk3rlt+53xLmY8gZWV5oMV9PNba/fO1X7TiSDsCPS3oBcSYNmG8ko5ARktMnMLUf8rqS+ZuqOwEZQg0Hpt661RZ9NWvr3FGumbrAkWG+Pb8pZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NkwJoii7; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NkwJoii7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573837; x=1737109837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DKnwUS+L9eXjPzconwL6Yc+EhI/8wQ1SrQSU9hTCXS0=;
  b=NkwJoii7rf1Sr67UnwJ+rtJC2+hNPWtGOckkFn1kiuSO1+xebcvy7WFx
   065dFxbe+EAtd65jBjRtK5W6j8fWhuv91SKHPLZ1QgR51K65MAUlf41ts
   EIaR3bHgI9z5zox1WWRt2d/vywB8RsTWiEVXHRzAsCCqzY2om8IomzEar
   EcpZwmtG03vtqE/5suoh3aQcC5Ixu9umvXUSVQcaysHMxPy1qBlHOi2EW
   /WKtzY/VaCvOaCVqDjZNIc06rflqdOvYUWGFwR/TNxWgAY3u9HC1IGtmV
   VBPcO8jZIImKBXic9S2fjCp/EMT/wEPTyNry5inz92jozQlFBUHwDtoNI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858535"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858535"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:30:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115926965"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115926965"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:30:35 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 1/5] Remove hardcoded checkpoint interval checking
Date: Thu, 18 Jan 2024 11:30:15 +0100
Message-Id: <20240118103019.12385-2-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240118103019.12385-1-mateusz.kusiak@intel.com>
References: <20240118103019.12385-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mdmon assumes that kernel marks checkpoint every 1/16 of the volume size
and that the checkpoints are equal in size. This is not true, kernel may
mark checkpoints more frequently depending on several factors, including
sync speed. This results in checkpoints reported by mdadm --examine
falling behind the one reported by kernel.

Remove hardcoded checkpoint interval checking.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 monitor.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/monitor.c b/monitor.c
index 4acec6783e6e..b8d9e8810b17 100644
--- a/monitor.c
+++ b/monitor.c
@@ -564,22 +564,10 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 		}
 	}
 
-	/* Check for recovery checkpoint notifications.  We need to be a
-	 * minimum distance away from the last checkpoint to prevent
-	 * over checkpointing.  Note reshape checkpointing is handled
-	 * in the second branch.
+	/* Handle reshape checkpointing
 	 */
-	if (sync_completed > a->last_checkpoint &&
-	    sync_completed - a->last_checkpoint > a->info.component_size >> 4 &&
-	    a->curr_action > reshape) {
-		/* A (non-reshape) sync_action has reached a checkpoint.
-		 * Record the updated position in the metadata
-		 */
-		a->last_checkpoint = sync_completed;
-		a->container->ss->set_array_state(a, a->curr_state <= clean);
-	} else if ((a->curr_action == idle && a->prev_action == reshape) ||
-		   (a->curr_action == reshape &&
-		    sync_completed > a->last_checkpoint)) {
+	if ((a->curr_action == idle && a->prev_action == reshape) ||
+	    (a->curr_action == reshape && sync_completed > a->last_checkpoint)) {
 		/* Reshape has progressed or completed so we need to
 		 * update the array state - and possibly the array size
 		 */
@@ -607,8 +595,10 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 		a->last_checkpoint = sync_completed;
 	}
 
-	if (sync_completed > a->last_checkpoint)
+	if (sync_completed > a->last_checkpoint) {
 		a->last_checkpoint = sync_completed;
+		a->container->ss->set_array_state(a, a->curr_state <= clean);
+	}
 
 	if (sync_completed >= a->info.component_size)
 		a->last_checkpoint = 0;
-- 
2.35.3

