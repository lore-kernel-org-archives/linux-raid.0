Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C673F604A9
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426809; cv=none; b=YQmpteSurw0szUNUpQZmOadOtr0OahBL0aiLDWZQFV/9UvWh5+FEnEXBVCj7/Hu8rRwZ13+OHLoz/9ZeXd2xGKYKDjElygHQxRoTMJW+y1q+IUkXySskRahmbi8BTNsOh4QgaEb6uM9cjrcR73O8ABgamL/obuZRZZDDZThZTBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426809; c=relaxed/simple;
	bh=DbGNHeRxTgEqgUfwmC1IQ8ODWiln5LFjufasgHVt1aU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Se5UcPlpIDNNog0zGeR1aLHsXHZZ1xSC0qh4bVU2hHM6tQcHTPtfkRzZ+daV2kHncaJbIOqdGNO3FATE77uBKIhteqUUYgmbfdIh6K1X9LPGZxzEqL9e8Ss2jcr49xn6/ueggGWBx3o9nylXMz4Q8L3h4T5uq01og7iATL0LaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AgFn+AuP; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AgFn+AuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426808; x=1739962808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DbGNHeRxTgEqgUfwmC1IQ8ODWiln5LFjufasgHVt1aU=;
  b=AgFn+AuPGcPaZBJP+RPlQ1vg2492K3NYv0yaRLAxV+A5/dYsNSzOI1vq
   t2U7+m+nKWbIRr+EhyTCIKtOqWUA4D9mgGIgd6GzVk4W5a6PJ1b8hPBDw
   yUkS7olVe8ZgBzAJNTSlMr3apNeSbI30wt4ils74tsOZn1fqAX7izWihz
   qMr58EvRtOs9Z11njq73ifvsonluIala1aRqPOepPV1ZgadiJiaE5lc/x
   MgiUNC/OSFe16XPJvP+EJhWujVyQ76rTp300HtBdQTKtks3CPVx79qbAZ
   SIpJqW4U4ZcQf9slUaYP127nwZQ0XbYi2BeGIMcyUEDiBS2SRGnbsGEVC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934369"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934369"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735147"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:06 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 2/6] mdadm: signal_s() init variables
Date: Tue, 20 Feb 2024 11:56:08 +0100
Message-Id: <20240220105612.31058-3-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240220105612.31058-1-mateusz.kusiak@intel.com>
References: <20240220105612.31058-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Init sigaction structs in signal_s().
This approach might throw warnings for GCC 4.x and lower.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 mdadm.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 1f28b3e754be..75c887e4c64c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1856,11 +1856,10 @@ static inline char *to_subarray(struct mdstat_ent *ent, char *container)
  */
 static inline sighandler_t signal_s(int sig, sighandler_t handler)
 {
-	struct sigaction new_act;
-	struct sigaction old_act;
+	struct sigaction new_act = {0};
+	struct sigaction old_act = {0};
 
 	new_act.sa_handler = handler;
-	new_act.sa_flags = 0;
 
 	if (sigaction(sig, &new_act, &old_act) == 0)
 		return old_act.sa_handler;
-- 
2.35.3

