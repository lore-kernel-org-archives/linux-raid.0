Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8D1B7FD
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y7X1qw3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404323; x=1736940323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csuLvsnMRaK5rqT5TrLVKLW2Bi7D4Nq9Nw4I8bFmqV4=;
  b=Y7X1qw3RJJaPBrEePvbfogHzv9Au4hnpnypes13bEpjLsRV/CL7KvFM/
   eiXJwRiQ2QCXs8//cUxNa1lnkD7EpnNrwBMY1q1X+t8eL/I3dSVjqDa0x
   P7TAQC89+fGUe3b0H9xC7wxlEpFDZi6eMdR8ouQiKHgqhRoc2cUETJXbt
   LYoQFPlVBXxHijZIj03wRRnbgRl89NW3u30XaWeLJowJKgWHF/eCF75kE
   Nn9+uq6R0VFtBuShl1vciSrOY6wC+1NVu9+j5DHFgh/40ksDmx/N8nGHd
   AWKEmPX9ctNCNYz66iYsgE5dVjmJsXDMPa+35FqobsxFz+OYwr1jO4R0e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307155"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307155"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:25:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26111542"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:25:21 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/8] Remove hardcoded checkpoint interval checking
Date: Tue, 16 Jan 2024 12:24:27 +0100
Message-Id: <20240116112434.30705-2-mateusz.kusiak@intel.com>
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
index 820a93d0ceaf..e0e65f3786d5 100644
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

