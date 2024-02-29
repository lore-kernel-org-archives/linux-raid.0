Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CA7D093
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207573; cv=none; b=I9odgMPtyT7sUC+Fn1oMztVMeS4vfClDnvbG+1rYN8n/OlEFlsmq3IaOKFzMOWhBk0FHCTOIdh0Ckis3/BnSgJi70mJWaDKOLdEl6iX0XdU5D7jEFo0Q3C7GOO9WCkuBajn64t5Y2gd9dxbFsWYt40EqJy9doEC3nToAPBLXaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207573; c=relaxed/simple;
	bh=EZEN09rFJYy/TvLBviO/Ly+H1g1QzuOkYJs6vXGLNf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gEN8iF6gwqs+2Ca8TBQLxG8I6NvNJvnZtvNIhQdwanuLZeFqtKt1ZhAEzdACfy+r52M+lYDSkTY6fYTacsw1bO08eb/6/ReF2aWcyePWAeRwLw1A2nF/YkckYT4YU5cvrOyfOFMPKC3TiHTphtvbHvw7jDXNuOBoYrgd9wT1qk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gRfgWE+U; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gRfgWE+U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207572; x=1740743572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EZEN09rFJYy/TvLBviO/Ly+H1g1QzuOkYJs6vXGLNf8=;
  b=gRfgWE+U/tVaGygGj91+ea+yyqxt19a6wfe7X2QChcTqudI52IFyWzQZ
   817AOy7dm4/BK6ysGY6HIaBNcNOzkDFcfJIOPi/a/zw2yjJYOwdvJLkSN
   /mWzSlTpfs6r2Q8oxEqgZgUhkA28sUu5FgGmTTp2PvJxyJvJrZLq25fLD
   4JhPZ8jL5ajbZ8Rqpc97a5AHSTaE3ienJeTFV8ag1pSSom3y6wWu71ItJ
   gmq0ZakVQ2wEAT5YUxHN94gAD51tdAy7FvWbP7O+x4Ll6jm3M+eI5bMJ6
   gM/tfZjPul+3vQtYTJnZVzNYpYyLXN7Q9AB8QtJLxHpFwjTOkQcLc6Mni
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499488"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499488"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754853"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:51 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 12/13] mdadm: drop get_disk_controller_domain()
Date: Thu, 29 Feb 2024 12:52:16 +0100
Message-Id: <20240229115217.26543-13-mariusz.tkaczyk@linux.intel.com>
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

This function is unused now. Drop it.
Controller for IMSM is a device policy and is separated from user defined
domains.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.h  | 15 ---------------
 policy.c | 13 -------------
 2 files changed, 28 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index cfa11391415a..3fedca484bdd 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1286,21 +1286,6 @@ extern struct superswitch {
 	 */
 	struct mdinfo *(*activate_spare)(struct active_array *a,
 					 struct metadata_update **updates);
-	/*
-	 * Return statically allocated string that represents metadata specific
-	 * controller domain of the disk. The domain is used in disk domain
-	 * matching functions. Disks belong to the same domain if the they have
-	 * the same domain from mdadm.conf and belong the same metadata domain.
-	 * Returning NULL or not providing this handler means that metadata
-	 * does not distinguish the differences between disks that belong to
-	 * different controllers. They are in the domain specified by
-	 * configuration file (mdadm.conf).
-	 * In case when the metadata has the notion of domains based on disk
-	 * it shall return NULL for disks that do not belong to the controller
-	 * the supported domains. Such disks will form another domain and won't
-	 * be mixed with supported ones.
-	 */
-	const char *(*get_disk_controller_domain)(const char *path);
 
 	/* for external backup area */
 	int (*recover_backup)(struct supertype *st, struct mdinfo *info);
diff --git a/policy.c b/policy.c
index 4b85f62d9675..404f9b5dd347 100644
--- a/policy.c
+++ b/policy.c
@@ -365,7 +365,6 @@ struct dev_policy *path_policy(char **paths, char *type)
 {
 	struct pol_rule *rules;
 	struct dev_policy *pol = NULL;
-	int i;
 
 	rules = config_rules;
 
@@ -380,18 +379,6 @@ struct dev_policy *path_policy(char **paths, char *type)
 		rules = rules->next;
 	}
 
-	/* Now add any metadata-specific internal knowledge
-	 * about this path
-	 */
-	for (i=0; paths && paths[0] && superlist[i]; i++)
-		if (superlist[i]->get_disk_controller_domain) {
-			const char *d =
-				superlist[i]->get_disk_controller_domain(
-					paths[0]);
-			if (d)
-				pol_new(&pol, pol_domain, d, superlist[i]->name);
-		}
-
 	pol_sort(&pol);
 	pol_dedup(pol);
 	return pol;
-- 
2.35.3

