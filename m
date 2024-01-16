Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE681B7FD
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sl+veJpE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404336; x=1736940336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y8VLNa1UAqY/X811BoBVzjvchHXimiTOi+XYqUAhffI=;
  b=Sl+veJpEH0BuD0uiAjAq21yjwLuyHdMhdsArVHcJgTjtiryxG+/aEiHn
   oHqwlOOZ5TFEOQS7LgmRNiUQrACPAguBuJq7tDNzuphDLLTevQGs/8Nm1
   VXuABl0EkSYO15eLoKWY86SAJY2YiuiCi2xQiW8qQkpxYtozpFldtCs/C
   6Y5T3LEs1lV6BfiQmBZp/ADGlW8E2aWA09BgXxzegdFxoTyYX+//aLIl3
   I4Fc2TAcrBbE59I5+pMVAex1nULkxYjo4ARuHVCu6gzF5k3yNDqpnofB/
   t2wyzmIbMrHJEAH5ZNRbW/D3t2zQHflz0AmOhIRALkvqL+7Yt6Kb2TIv3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307229"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307229"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:25:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26111575"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:25:35 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 2/8] monitor: refactor checkpoint update
Date: Tue, 16 Jan 2024 12:24:28 +0100
Message-Id: <20240116112434.30705-3-mateusz.kusiak@intel.com>
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

"if" statements of checkpoint updates have too many responsibilties.
This results in unclear code flow and duplicated code.

Refactor checkpoint update code and simplify "if" statements.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 monitor.c | 51 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/monitor.c b/monitor.c
index e0e65f3786d5..138664b2c6d4 100644
--- a/monitor.c
+++ b/monitor.c
@@ -412,6 +412,7 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 	int ret = 0;
 	int count = 0;
 	struct timeval tv;
+	bool write_checkpoint = false;
 
 	a->next_state = bad_word;
 	a->next_action = bad_action;
@@ -564,40 +565,38 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 		}
 	}
 
-	/* Handle reshape checkpointing
-	 */
-	if ((a->curr_action == idle && a->prev_action == reshape) ||
-	    (a->curr_action == reshape && sync_completed > a->last_checkpoint)) {
-		/* Reshape has progressed or completed so we need to
-		 * update the array state - and possibly the array size
-		 */
+	/* Update reshape checkpoint, depending if it finished or progressed */
+	if (a->curr_action == idle && a->prev_action == reshape) {
+		char buf[40];
+
 		if (sync_completed != 0)
 			a->last_checkpoint = sync_completed;
-		/* We might need to update last_checkpoint depending on
-		 * the reason that reshape finished.
-		 * if array reshape is really finished:
-		 *        set check point to the end, this allows
-		 *        set_array_state() to finalize reshape in metadata
-		 * if reshape if broken: do not set checkpoint to the end
-		 *        this allows for reshape restart from checkpoint
+
+		/*
+		 * If reshape really finished, set checkpoint to the end to finalize it.
+		 * Do not set checkpoint if reshape is broken.
+		 * Reshape will restart from last checkpoint.
 		 */
-		if ((a->curr_action != reshape) &&
-		    (a->prev_action == reshape)) {
-			char buf[40];
-			if ((sysfs_get_str(&a->info, NULL,
-					  "reshape_position",
-					  buf,
-					  sizeof(buf)) >= 0) &&
-			     strncmp(buf, "none", 4) == 0)
+		if (sysfs_get_str(&a->info, NULL, "reshape_position", buf, sizeof(buf)) >= 0)
+			if (strncmp(buf, "none", 4) == 0)
 				a->last_checkpoint = a->info.component_size;
-		}
-		a->container->ss->set_array_state(a, a->curr_state <= clean);
-		a->last_checkpoint = sync_completed;
+
+		write_checkpoint = true;
 	}
 
-	if (sync_completed > a->last_checkpoint) {
+	if (a->curr_action >= reshape && sync_completed > a->last_checkpoint) {
+		/* Update checkpoint if neither reshape nor idle action */
 		a->last_checkpoint = sync_completed;
+
+		write_checkpoint = true;
+	}
+
+	/* Save checkpoint */
+	if (write_checkpoint) {
 		a->container->ss->set_array_state(a, a->curr_state <= clean);
+
+		if (a->curr_action <= reshape)
+			a->last_checkpoint = sync_completed;
 	}
 
 	if (sync_completed >= a->info.component_size)
-- 
2.35.3

