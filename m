Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5C9535A9
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779338; cv=none; b=sSO1gYN9LtZcHnGpyvfXpbCkYOCHt++q89XeWGrGW4tJ/gBLTsAwDetoi4Ijh+a7XBh+SKIvzc/7Zt8J27QwF7HHmadd9RgBm+f2PDD0Bd80g9DqyG3ZIG4eMBDSOwXt69YNbP3FgzjAB45iv8fVPuG7r4/JFH5u9fyHtPAj8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779338; c=relaxed/simple;
	bh=NEuesXWZzsrVAyuEsysFTO6Pr2y/6pdA3cvWmAK5lbU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fl3ohpVBrJlkbx5LUY7kKzTxa8t7XDZICK/J+nNVvzlhyG3c8VFnwF5cx18OmM5gpzAmUEevY3gR45S9RUzQJI/vVwMwXFgcIpvhvtEC5PCbGx6lecm6/t0Km4fQ686gKSfmzHzA7vguN8DUb0AhPx7aTo6TLlyjRB8sPopGvzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CG6Axkqs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CG6Axkqs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779336; x=1742315336;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NEuesXWZzsrVAyuEsysFTO6Pr2y/6pdA3cvWmAK5lbU=;
  b=CG6Axkqss007+eNVE3OChnT62CrQ4z0AAbidPZgJ1+WBHMHMMHBNw0R8
   EowFR1foihKNtCNLMZLy9c/bfksjnsP1FCc+ieAVdPcKn5NygAeFcsZ55
   lg8+GgRrQmNddITfb/JTVdpWD3KZcGIdSSci/zSjLsdqrTWJRHjDg+lgP
   VJG95z49xWfINv7bjCFw/rFm/zR5XwrcoHFiYYqlsuwQtU/RgXVvEU21U
   P0Dk9NZcOpHb3n9dgH2b7KC8g7hqku2P8whMRhJiohn2VEDW3h/jO/Y/j
   W5f7q9THAputbTWP0CNQGAqwaTqnTofkQZOD79eNI0NbFLVS1oW9H1gs3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="23058757"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="23058757"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:28:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18133073"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:28:54 -0700
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH] mdadm: fix grow segfault for IMSM
Date: Mon, 18 Mar 2024 17:28:42 +0100
Message-Id: <20240318162842.9651-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If sc is not initialized, there is possibility that sc.pols is not zeroed
and it causes segfault.

Add missing initialization.
Add missing dev_policy_free() in two places.

Fixes: f656201188d7 ("mdadm: drop get_required_spare_criteria()")
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c | 1 +
 super-intel.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 958ba9ba7851..83db071214ee 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -874,6 +874,7 @@ mdadm_status_t incremental_external_test_spare_criteria(struct supertype *st, ch
 	rv = MDADM_STATUS_SUCCESS;
 
 out:
+	dev_policy_free(sc.pols);
 	dup->ss->free_super(dup);
 	free(dup);
 
diff --git a/super-intel.c b/super-intel.c
index 7714045575b2..32eceb155886 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11518,10 +11518,15 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
  */
 static struct mdinfo *get_spares_for_grow(struct supertype *st)
 {
-	struct spare_criteria sc;
+	struct spare_criteria sc = {0};
+	struct mdinfo *spares;
 
 	get_spare_criteria_imsm(st, NULL, &sc);
-	return container_choose_spares(st, &sc, NULL, NULL, NULL, 0);
+	spares = container_choose_spares(st, &sc, NULL, NULL, NULL, 0);
+
+	dev_policy_free(sc.pols);
+
+	return spares;
 }
 
 /******************************************************************************
-- 
2.35.3

