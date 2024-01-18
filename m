Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077728F2
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573847; cv=none; b=Bt+57GHJkP8685Ar4R66wIrZdB998alagFhYyNLx7rY+bxO+XE5jrwkRM5qrcXUd9KdmFXAmZvRDlujCxneyXyhAGdbZWDQLdaiA1bAHKGCmL3M7rKtTCf/lwxU2t0A2ygbdIpsFjg2xmq4OLtEWh6Ws13wT11PP/6JaXe/0Omc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573847; c=relaxed/simple;
	bh=+TXPfOz+kf8ZbFh9gmhB/Q6LaX3NqxfvCBcjwy5ZBZc=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=lVWINP11s2vUnFP/M9ZOUvLPiUa8TZtZGdBXqaKhxHHuo9weyEI9rY5oq1K5ldHZN1Rt1/ET8Z0CL8s66qcIRGsWVclKvyUvb34aOrLZKqbneyIKxgKYJvygzNRxRY8iJwA5GiasF5hAqhJixNux7eQlCDldXSMX3INB1tiSrUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHKcNfAr; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHKcNfAr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573845; x=1737109845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+TXPfOz+kf8ZbFh9gmhB/Q6LaX3NqxfvCBcjwy5ZBZc=;
  b=LHKcNfArSHytARqBIX+CN6W/IVLf1VAl4F+SEINFZ28pk/SGjLbQwlky
   8GQXqhD3imC0Xz03rAdUsX9Y/r0vrOUNpS2GDA8JAH4YLNr28OJ5UFUCH
   ATRPlrR0pSLpyzpHZM18xFRnd+FDNqYsKg4TmaYpxPiOKrvfGXFqPZRVP
   krKm6RKko7+53Wj3fr2/ACO3R8GU0vji55vdSHUsIwYORZspeAFLePQu1
   2M85fwxzP+N0RB10l+siM+jsOKpp4/YY6lx+1WsX73oPriUjzQXGxvSu0
   l1v9dcA4J7A2+hOll8MwPQ65WDASTVOrv5db3+NYXrXEG7x+Lj46L2VBQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858558"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858558"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:30:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115926993"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115926993"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:30:43 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 2/5] monitor: refactor checkpoint update
Date: Thu, 18 Jan 2024 11:30:16 +0100
Message-Id: <20240118103019.12385-3-mateusz.kusiak@intel.com>
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

"if" statements of checkpoint updates have too many responsibilties.
This results in unclear code flow and duplicated code.

Refactor checkpoint update code and simplify "if" statements.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 monitor.c | 51 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/monitor.c b/monitor.c
index b8d9e8810b17..be0bec785080 100644
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
+		char buf[SYSFS_MAX_BUF_SIZE];
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
-			char buf[SYSFS_MAX_BUF_SIZE];
-			if ((sysfs_get_str(&a->info, NULL,
-					  "reshape_position",
-					  buf,
-					  sizeof(buf)) >= 0) &&
-			     str_is_none(buf) == true)
+		if (sysfs_get_str(&a->info, NULL, "reshape_position", buf, sizeof(buf)) >= 0)
+			if (str_is_none(buf) == true)
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

