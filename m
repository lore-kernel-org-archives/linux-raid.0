Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FF315A4BA
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709134680; cv=none; b=seqXfYMdqktY0e3PU+deS62V8u7cfC7lM/KGmduV9/XKZsb9vXgFJe68aW1va606N01DLxN2ZnPIDGBMnHsxdsXWHT0XwPYi/ZlkrGs129kp/rezArwJl+MW4hZ61AcWt6ac2g3pg69amDaJr2DmIUk15YLcWTj2fUPcX3eZfTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709134680; c=relaxed/simple;
	bh=UnLa0UFOJRGd8FNcQOHmScuKJtUuGGkAaX8iepHnLsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYvmw3lMZNQSxWjnlPgSvzj5q8ajJsI3BK+LC9kLaUvJSlgu2wrJ6yh01LKmJcj2fjBeVQXxIEFP0Zxpdp7nskRcsA24a74wSFugQgRmacM858s3OQ9Nu6ouFFL2pHPbmrz9R6VFvLQb1V5pcKzCEfdPOXnJIB90QF3wx0rDGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecjpZQc3; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecjpZQc3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709134678; x=1740670678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UnLa0UFOJRGd8FNcQOHmScuKJtUuGGkAaX8iepHnLsY=;
  b=ecjpZQc3IC8/cXBiwhwH+TdzRxNB8/Tfh3HbqV9n16xFvz0ZcJ6XhdUm
   Z9t7C10hdZ3+GtUL7PvL5OSkIMzat1TNqzr0CbpRkSoBbZhjaqBtr69AC
   3Fwd9Fkk/Y/HyLOtNL9CQz8M6w8Hsq0rOPjVHOOvJ6VsaOJ8aLQomeU1h
   s8wV3n+CPPKyTLqWgxQrhb0/TeBowaw2KUnWebuy5RteVajUasPdDk8jH
   4g8w4MpSMqPuVavXecghpUv686DkUajrbBR7vP5nueDOBxf/pvhA048QP
   1/kLLWORu3leRksI06RBZykZfb5Hv66ByBKukTJUQx9Mh3VyAO7oHjNVF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="26004844"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="26004844"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 07:37:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7584388"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa008.fm.intel.com with ESMTP; 28 Feb 2024 07:37:56 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/1] Monitor: Allow no PID in check_one_sharer()
Date: Wed, 28 Feb 2024 16:37:20 +0100
Message-Id: <20240228153720.12685-2-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240228153720.12685-1-mateusz.kusiak@intel.com>
References: <20240228153720.12685-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5fb5479ad100 ("Monitor: open file before check in
check_one_sharer()") introduced a regression that prohibits monitor
from starting if PID file does not exist.

Add check for no PID file.
Add missing fclose().

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Monitor.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Monitor.c b/Monitor.c
index 7cee95d4487a..9be2b5287a1a 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -453,12 +453,17 @@ static int check_one_sharer(int scan)
 
 	fp = fopen(AUTOREBUILD_PID_PATH, "r");
 	if (!fp) {
+		/* PID file does not exist */
+		if (errno == ENOENT)
+			return 0;
+
 		pr_err("Cannot open %s file.\n", AUTOREBUILD_PID_PATH);
 		return 2;
 	}
 
 	if (!is_file(AUTOREBUILD_PID_PATH)) {
 		pr_err("%s is not a regular file.\n", AUTOREBUILD_PID_PATH);
+		fclose(fp);
 		return 2;
 	}
 
-- 
2.35.3

