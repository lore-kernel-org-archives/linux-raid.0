Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D91B7F3
	for <linux-raid@vger.kernel.org>; Tue, 16 Jan 2024 11:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkgfpF2U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705404425; x=1736940425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4YvIB23pE5Y+Im/dLTsi/yzbQXtu1VxBAtZNBJaSx3I=;
  b=fkgfpF2UN7jM7KUKmP7CsCKaqgDr0TitDEfZZe8QC5JCmOJ+viAaZKzB
   hBmT2h6jAYYD2yf5z4Oq7kroSOscRoogrdQsl03jhY741R7uiSgTTgOoq
   5zTJHgxWYhZCPil07KyawyXTY4q0pwYzBhzmoSiiWfW5WBk8g4KDGEBZ3
   lQ2bK6DUNIZlJk6UnCRoUqqj7ZbA+9TUuI3ZL3FZhAqlg37M9QMwr+wMl
   M0oYQjhkZnWIh0nHEB54jHigocf6A+G7xFWMU0tdtmlZMlmYQ8fey8WLQ
   gd6M/+wqWNzazFMRbtgdu0TTKUJkXmKF7n/FWPU275DKE1d6c6A8Jvjwp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="21307444"
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="21307444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 03:27:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,199,1701158400"; 
   d="scan'208";a="26112020"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa001.fm.intel.com with ESMTP; 16 Jan 2024 03:27:00 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 8/8] Add understanding output section in man
Date: Tue, 16 Jan 2024 12:24:34 +0100
Message-Id: <20240116112434.30705-9-mateusz.kusiak@intel.com>
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

Add new section in man for explaining mdadm outputs.
Describe checkpoint entry.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 mdadm.8.in | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index b7159509f74d..7c8959be8810 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -3197,7 +3197,7 @@ environment.  This can be useful for testing or for disaster
 recovery.  You should be aware that interoperability may be
 compromised by setting this value.
 
-These change can also be suppressed by adding 
+These change can also be suppressed by adding
 .B mdadm.imsm.test=1
 to the kernel command line. This makes it easy to test IMSM
 code in a virtual machine that doesn't have IMSM virtual hardware.
@@ -3464,6 +3464,25 @@ is any string.  These names are supported by
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

