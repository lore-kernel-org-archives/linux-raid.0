Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDC6134404
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736680; cv=none; b=fZHvFoeDnsh4dmNmKQf31BBi1WTkqvNObJhmbUrbMIEwjfOFk3PRctwhksrJqzuEH5zdmCOztV+5V7yRiTxrEuVuxTDmy60VXxhhQhhMzAdtGOTlP2q6dMc6eZIdvydYlXAc86klW0IM6S+1rxhaP4dMC1wUFsrKcex6mtOWgPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736680; c=relaxed/simple;
	bh=eUr/K579fQgj/GQHgtstn7Ac20DD4KQeIIujnHlS6hg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tbB7X7/SS/rYTgeZuVmHhOV9lBX8vZXhSIsnB1r+DyyYdQWLpEuHv8z619lBAcDnvoviowv2FBgP8jDerOh4O0RVHAcqdsqiI0fxD3+WikLSW76Aizy2KSC4tklm4tUOqDeqnWwxkPcOfL1dgiisO++g1p6MCdvzSaazrKNrxpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jcZe7QYs; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jcZe7QYs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709736675; x=1741272675;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eUr/K579fQgj/GQHgtstn7Ac20DD4KQeIIujnHlS6hg=;
  b=jcZe7QYs/zQbNfs5pX13t184RS7i0ok/tPiY7hO812JeUYBXw2GgwR5+
   nVj8cmvbFv7J/I1CbB7tF5GQ9INSnssPRBZBEFYM6lPpLzan2kFHTg06L
   WFr1GsTojKZZzbTrBGMdEQmueSbprlG03UimvsxEXodjYSOvDhmejHMTp
   y5kkwCM1iPjoI19/PBPyY/Haysk274YzhcSwjlA3UDmHLvCCFrMnEkC3l
   JBVeK+Ca4ack/G8MnFQCLTQEGERMjQcb3yQEJoPjHOD73Qej6VUA3Ss9W
   N2GvfvK7W9hx1Mcx1IeYdowQrXDUV87XHZzlniRmdDMDOBzsXw7ueXurz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4281660"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="4281660"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="32926469"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:51:13 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Boian Bonev <bbonev@ipacct.com>
Subject: [PATCH] udev.c: Do not require libudev.h if DNO_LIBUDEV
Date: Wed,  6 Mar 2024 15:50:55 +0100
Message-Id: <20240306145055.31744-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libudev may not be presented at all, do not require it.

Reported-by: Boian Bonev <bbonev@ipacct.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 udev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/udev.c b/udev.c
index bc4722b0ef94..066e6ab1c292 100644
--- a/udev.c
+++ b/udev.c
@@ -26,7 +26,10 @@
 #include	<signal.h>
 #include	<limits.h>
 #include	<syslog.h>
+
+#ifndef NO_LIBUDEV
 #include	<libudev.h>
+#endif
 
 static char *unblock_path;
 
-- 
2.35.3

