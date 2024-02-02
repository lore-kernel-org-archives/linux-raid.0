Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15139148315
	for <linux-raid@vger.kernel.org>; Fri,  2 Feb 2024 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891954; cv=none; b=VV12ckRBc5r/kFSYcIbY2RkOkb/kn5kdWG6GAplf5q8kkjrhkQEC23RiioshVk1Dx4Z32rYGiy5jykH6yfUHv8yNo0oSKRDE+Jk47VzneWfjPpSJ1fUxjKrz7O4bv/LQrQEG1GMrRyG1/7+MIZZE4T3rIYLMTdCwnpUeC5Ms08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891954; c=relaxed/simple;
	bh=vuEaeHcOCOc3RSI485IBZwF5cHiYvOoQzII86vWpQDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BdJXB+xCq9Afl3pMFWWd4h2gXuVR6Fm6Axh18J7zcdjq8pkQvwD2wRQ9NgnunLUf55IJGZMnAI8396xujH09RMBn1ZGDxQt1K4RYzPUvCtiqAdRSzqXytBKY7ofLmYR+ArKyYU33NKH8e4j9JYsyqRkbzUJxecIAXhuynMkQh10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GkkEdXqg; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GkkEdXqg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706891954; x=1738427954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vuEaeHcOCOc3RSI485IBZwF5cHiYvOoQzII86vWpQDE=;
  b=GkkEdXqgcbVXYue5u508c2Df53sm4NTLAaNG5iI1VpNYEy6I6I4BSiiU
   lHhzL6RKgyUimHrN73EkSXl1ueLgEX9DAXbof2+xNlLvshxCJHf2UB+Ai
   Juz2DbgLCT7LHunP+KRNKjYa1vV3HoHgVyrvXmV8vrSCidz6493RmzB2F
   BDiOXruujQ29Ukzre/VrC52FeC+wFKvAZ9woFZ5sDEfWkuku8fmo+Ynng
   qO2b0Qh70jFfAd1UIQayY2XY812WIHpE5nGk+pqBqmEQNOv92PpgT2xAS
   z1SQBJdk4s9VLPo+oPRP/oYE1PDwzdYhTMf+jsNmBI3+UvOB+ZiNpoqM3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="376800"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="376800"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="4723287"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:12 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 1/2] Revert "Fix assembling RAID volume by using incremental"
Date: Fri,  2 Feb 2024 17:38:34 +0100
Message-Id: <20240202163835.9652-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
References: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit d8d09c1633b2f06f88633ab960aa02b41a6bdfb6.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Assemble.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 9d042055ad4e..550369ae8403 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1984,10 +1984,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		return 1;
 	}
 
-	/* Fill sysfs properties only if they are not set. Determine it by checking text_version
-	 * and ignoring special character on the first place.
-	 */
-	if (strcmp(sra->text_version + 1, content->text_version + 1) != 0) {
+	if (strcmp(sra->text_version, content->text_version) != 0) {
+		if (content->array.major_version == -1 &&
+		    content->array.minor_version == -2 &&
+		    c->readonly &&
+		    content->text_version[0] == '/')
+			content->text_version[0] = '-';
 		if (sysfs_set_array(content, 9003) != 0) {
 			sysfs_free(sra);
 			return 1;
-- 
2.35.3

