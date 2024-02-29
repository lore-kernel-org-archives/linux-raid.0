Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66307D093
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207575; cv=none; b=VxYE2DO1UBE36l/tYJEdU7agE2BCOK5fHJCtHscOpERLEJ8oYzCGai48WuhTTXDvDGRWBpkRu2y6cXo4OaXkoDodZmrL2CnBNdPJAWaWc24PImWht0Vs/T5hZxALo5cWLNwFkQkzpZVggEBtJelAs6BabAbd7466c4x4ZdLv4FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207575; c=relaxed/simple;
	bh=mAMFMw8rXgKuO7ZbZez3AOmLjP2ZXkEkrYTjahx/Kw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MWJl7Ry14/ol1GYfFIb5WQVYXL+XXGOVdgc7Rbh36hXmwaJKeMAYtpF0HyVGoCM+9/pV9gIEP/g2FfYQSk2BJ/vUJpPowBCa0ei8fGrMFRlfnIE59X/ajKlUYgpXmIXCJ3BlvpuXxyTEAm5xIPbL78VUY3QHm2aO9ZwHCUIqBkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Af8MPdES; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Af8MPdES"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207575; x=1740743575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mAMFMw8rXgKuO7ZbZez3AOmLjP2ZXkEkrYTjahx/Kw0=;
  b=Af8MPdESlf/Z4Y+4XbZ3qoMMTGi8HLR81l8p1WeMnb4McbZ5T8/xAkHj
   2dZXFQn3kDoeO2R0NpKNriwtt/H4AGBmylmlfLgpeQmnyLmB6Md0VQQTm
   EAnC35MYkrM1a49O4jgXnACmSflCyjSFlgMaJIEb3ZgMIhmKo1zuCekYX
   kpTOFa1RTiRYzAV683DJtlI/G2LcbxbHN0oEcifPOyxTjhTRNDgmh8keI
   E5OM3BBOqkJ0x3IogVbw2VwtPj8Kek68bLzwmald/cPf+Jg2P4DG69H0Y
   BOA4z+NXSOCFzphQRm0HGOEFzEihx+ci9KLQUfNwwyuoqOorMqS1R4zCm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499494"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499494"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754885"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:54 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 13/13] Revert "policy.c: Avoid to take spare without defined domain by imsm"
Date: Thu, 29 Feb 2024 12:52:17 +0100
Message-Id: <20240229115217.26543-14-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 3bf9495270d7 ("policy.c: Avoid to take spare without
defined domain by imsm").

IMSM does not require to be special now because it doesn't create disk
controller domain.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 policy.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/policy.c b/policy.c
index 404f9b5dd347..dfaafdc07cdc 100644
--- a/policy.c
+++ b/policy.c
@@ -759,7 +759,6 @@ int domain_test(struct domainlist *dom, struct dev_policy *pol,
 	 *  1:  has domains, all match
 	 */
 	int found_any = -1;
-	int has_one_domain = 1;
 	struct dev_policy *p;
 
 	pol = pol_find(pol, pol_domain);
@@ -769,9 +768,6 @@ int domain_test(struct domainlist *dom, struct dev_policy *pol,
 			dom = dom->next;
 		if (!dom || strcmp(dom->dom, p->value) != 0)
 			return 0;
-		if (has_one_domain && metadata && strcmp(metadata, "imsm") == 0)
-			found_any = -1;
-		has_one_domain = 0;
 	}
 	return found_any;
 }
-- 
2.35.3

