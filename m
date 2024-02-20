Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2948F64CF5
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426816; cv=none; b=UmX2I2psM8iRNj7mQtm80FqSMy1TUC0ap+5ZWLkCrkfVc9DOmjih+B3Tuw/RlXZ7FoL/WGWDCQNfBqVwMoRS1p8X310mpAMrFvq4i2oFw6T3HsdzRKz+j7TLLTpcSHHGqQq3JlGShQb/Kqq0cpX3N7AGoytJQW6cvCY1IHN71Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426816; c=relaxed/simple;
	bh=TVIiAVMXFZ8QR3UltfsNMHwwwGfke4LeHTL9T2TmJGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B1JNzLxDYR34VLkCCaiSHkO7dZW5yjZjXtbN7jU7y3ZHQTXUPhTP514W26b2QbIxC0CZS/UeZ8f5P2nIjxwuSF47LJGHyllA3JTtI0FnuW5Z0vSJhj1uPrUAF37r0kLqNM2TDeQFoPQm6MWFH5K1Un1I9vui79yw8GU3PRbcBko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ArQTQG0k; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ArQTQG0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426815; x=1739962815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVIiAVMXFZ8QR3UltfsNMHwwwGfke4LeHTL9T2TmJGw=;
  b=ArQTQG0kIQxEMqP2v9QMEfFczX0h2JhQ00X4uZdsz/vWe8tJzXJRTc0t
   VCpPO0K4Vrr3C/QkGjcJN0ew7trpp3YclYXfI+tlKvsXykbln8E3HkVB+
   mLf5A/03jIFEZuPRVAQCJlc+v8AViehkB/Vl4EmP+uyluviqoAf2/6ncm
   kD1NEu424g1FKEkLeQpi8NfvHEMw7BHvEmRU9kVeVowVC9y7dk2gBlxde
   vTfgspIBioEtoyFKoV7WrjjBFjw6Inu2Ppt+6+hXLIkoAWrlyjMMV9f7b
   Y08Yz0cjgrqywrChRf9a4IOsx4fOaIyki4GX57YS7g/pOnP794emsDYWJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934373"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934373"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735165"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:13 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 3/6] Monitor: open file before check in check_one_sharer()
Date: Tue, 20 Feb 2024 11:56:09 +0100
Message-Id: <20240220105612.31058-4-mateusz.kusiak@intel.com>
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

Open file before performing checks in check_one_sharer() to avoid
file tampering.
Remove redundant access check.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Monitor.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 824a69fc6b79..7cee95d4487a 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -451,20 +451,17 @@ static int check_one_sharer(int scan)
 		return 2;
 	}
 
-	if (access(AUTOREBUILD_PID_PATH, F_OK) != 0)
-		return 0;
-
-	if (!is_file(AUTOREBUILD_PID_PATH)) {
-		pr_err("%s is not a regular file.\n", AUTOREBUILD_PID_PATH);
-		return 2;
-	}
-
 	fp = fopen(AUTOREBUILD_PID_PATH, "r");
 	if (!fp) {
 		pr_err("Cannot open %s file.\n", AUTOREBUILD_PID_PATH);
 		return 2;
 	}
 
+	if (!is_file(AUTOREBUILD_PID_PATH)) {
+		pr_err("%s is not a regular file.\n", AUTOREBUILD_PID_PATH);
+		return 2;
+	}
+
 	if (fscanf(fp, "%d", &pid) != 1) {
 		pr_err("Cannot read pid from %s file.\n", AUTOREBUILD_PID_PATH);
 		fclose(fp);
-- 
2.35.3

