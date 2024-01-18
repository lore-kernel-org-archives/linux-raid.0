Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5307BA42
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573874; cv=none; b=l7vdECezo+d2ozec1R0Ly6dYPss4d2QZfLzZX1m60gkAFyy6yh69SUjCsp0fJobKiZF8UajCcMz2Y0jjF274Bozbc18F28l1zjuNFWavavjZLgsIfNSB5pSIh1/v87nVIQugmOvlbtG7GN6TIY8fgdo0S1uC8y7iDWNuWRKQolk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573874; c=relaxed/simple;
	bh=TsOnc7GNV0SObV+4PfgwOMJXy/qUy2Pz9QqDtlNX+m8=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=PRhHq0Pgh/QWK0Wh5Lk6NW6RkRzSn1jbTOQcxAW7eVAH3RX/OPTFHkn/Nz0vAIDBISFQDg+EfNAs9VKX7lCvM6ux/k82W5qcaGINxRYr7D4Pe+RhSPfT4K5jdDyPYGC8O+saHr6EB3fvlmy4ksHzIYIRW6WwpFqAhXsiyILPckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HVql9Ky9; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HVql9Ky9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573873; x=1737109873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsOnc7GNV0SObV+4PfgwOMJXy/qUy2Pz9QqDtlNX+m8=;
  b=HVql9Ky9y7VUkdMCBgeWSRegNVfKXRyYt6aN7TFVrvs9SnalRRghuiFN
   ZciBOh+urBHo1Oac5cNSbNEOkh9YY59ZHHbU+A5GPVpv+Jt+D7rCuLI2n
   VR6JKiPiEJoERsF1GMG+I/6GuVPZOoGIblDLLfQJY7zzll6WMepjl4WDF
   heSLr8AF6iD+ZpfjkPFiaLKcgRufKdqpZT11bjkgjducmXC7m4YBJ0s9p
   CHobKHC2IEMu8vj6FhLLbITpg6pznSqEX/q1Nw6U69+BO/AN5xDSZFpSs
   PEsMAiVFtI76l1OMYDgMU+m8XLuPXJKIhy+9JRlUI2MwblZ2pG3vlzFgz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858579"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858579"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:31:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115927105"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115927105"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:31:11 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 5/5] Add understanding output section in man
Date: Thu, 18 Jan 2024 11:30:19 +0100
Message-Id: <20240118103019.12385-6-mateusz.kusiak@intel.com>
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

Add new section in man for explaining mdadm outputs.
Describe checkpoint entry.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 mdadm.8.in | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 3142436f728c..e3033a957bb3 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -3179,7 +3179,7 @@ environment.  This can be useful for testing or for disaster
 recovery.  You should be aware that interoperability may be
 compromised by setting this value.
 
-These change can also be suppressed by adding 
+These change can also be suppressed by adding
 .B mdadm.imsm.test=1
 to the kernel command line. This makes it easy to test IMSM
 code in a virtual machine that doesn't have IMSM virtual hardware.
@@ -3454,6 +3454,25 @@ is any string.  These names are supported by
 since version 3.3 provided they are enabled in
 .IR mdadm.conf .
 
+.SH UNDERSTANDING OUTPUT
+
+.TP
+EXAMINE
+
+.TP
+.B checkpoint
+Checkpoint value is reported when array is performing some action including
+resync, recovery or reshape. Checkpoints allow resuming action from certain
+point if it was interrupted.
+
+Checkpoint is reported as combination of two values: current migration unit
+and number of blocks per unit. By multiplying those values and dividing by
+array size checkpoint progress percentage can be obtained in relation to
+current progress reported in /proc/mdstat. Checkpoint is also related to (and
+sometimes based on) sysfs entry sync_completed but depending on action units
+may differ. Even if units are the same, it should not be expected that
+checkpoint and sync_completed will be exact match nor updated simultaneously.
+
 .SH NOTE
 .I mdadm
 was previously known as
-- 
2.35.3

