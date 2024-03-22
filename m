Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E293F9C0
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108311; cv=none; b=TAteYpwR9ELiAzDjXFLjMbAg/mCUzvEgqCAsEmBwPBj+NwSEVuzIoqnbTfpUH7SUH9wr8RUpnDQ6HTLCpzEKxf9mg/dbXIUC9dL45+UHDXgdpka0p5Nv5qOv+laSn2YfhaZ1PYw9wr0txZ7pV9pVggu8hzQ6tS6YLkvdkqyWJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108311; c=relaxed/simple;
	bh=0V1Ho/wA7BnhZr/EM+OYxDgjeqa6nimIDoRlnbDCwuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=azZIPZuSFIHjcs8q9rT0BwF5P1ZvnDPpKkuU+SD+LVp3Wl0QH8czZQPTX/PfoS4dR3Lw3Eb7/KF2vuNW3GVmKkRmGB40nJDOvFcbbHMmmVpPpIU+Hq9X0S6ZBaFfDuzBDvEc0iQj8qBcHs6VTktKKO+rUVz4hADUi53F4mrDaDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kYAo8VLd; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kYAo8VLd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711108310; x=1742644310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0V1Ho/wA7BnhZr/EM+OYxDgjeqa6nimIDoRlnbDCwuQ=;
  b=kYAo8VLdB0UlegMDdK2cauFfY2OJO7db7kGwwzd90cRL/ot5SA3z+qYi
   YRgCtPcbVeJQp5krmjfd1jQHXwXMfKhn1xhB876iuTFD//b+F0miBpr35
   9P6Ssekyx776IWI26cX9bG1asz7fpBoN+C9YgzhwawCJEPQHhyA3iFdOR
   5yg0xXS4ALQbRe17KMi4/Lthi0yCGYYvpIjTeI2K1leVVThj1XEfOtfTt
   T0k4/3L1rl1iefsvQkPBF787XskOUUvo5aNn4H9B8m8BKFslHPrxUYijv
   7Kb7gvHv8+hzchSSvQS6XuN8L4lVDu0/DLYNVxqhQ894XXBrdRcrN7u+i
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6006790"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6006790"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:51:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="46001007"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmviesa001.fm.intel.com with ESMTP; 22 Mar 2024 04:51:48 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 1/6] mdadm: Move pr_vrb define to mdadm.h
Date: Fri, 22 Mar 2024 12:51:15 +0100
Message-Id: <20240322115120.12325-2-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240322115120.12325-1-blazej.kucman@intel.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move pr_vrb define from super-intel.c to mdadm.h to make it widely
available. This change will be used in the next patches.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 mdadm.h       | 2 ++
 super-intel.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 3fedca48..141adbd7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1912,6 +1912,8 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 
 #define pr_info(fmt, args...) printf("%s: "fmt, Name, ##args)
 
+#define pr_vrb(fmt, arg...) ((void)(verbose && pr_err(fmt, ##arg)))
+
 void *xmalloc(size_t len);
 void *xrealloc(void *ptr, size_t len);
 void *xcalloc(size_t num, size_t size);
diff --git a/super-intel.c b/super-intel.c
index 77140455..806b6248 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -393,8 +393,6 @@ struct md_list {
 	struct md_list *next;
 };
 
-#define pr_vrb(fmt, arg...) (void) (verbose && pr_err(fmt, ##arg))
-
 static __u8 migr_type(struct imsm_dev *dev)
 {
 	if (dev->vol.migr_type == MIGR_VERIFY &&
-- 
2.35.3

