Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830A61EB5D
	for <linux-raid@vger.kernel.org>; Wed, 20 Dec 2023 09:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eeKsR56N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703064789; x=1734600789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OPkPny1G70IE4sxZXXjumR7GbHeXt4k+npWd4Puxfa0=;
  b=eeKsR56NkbnW34bzwG7JPjeYvr9iEovHfnlOfEVRiwvIbp2gGzgWqfZz
   FJTAaoBMeWz2zfWYmXwbuww8OPcRuweYlhKbKhcq7uhXvRLVBtFv+xBZO
   N3TYa040Q8vp60bCbBfaiCnmacSsT9weIAPyB3vwSDBYEHb2Om7YA6e8b
   ZwZsuS+54NinKDuk/vJNX/vOdQhAi51TaPZmgYHA2E5o37olBIYfEfIm1
   StqWBK41NQszH87z5TpOo+IGyyVRT5mpn9MbRBbSjSxkyzHZC1NM6Mlzc
   YIzT7Mp60BMCYCxzqEtoh78NQhY5kIYsSgQnt5l2Ab8aVuR3SpOhr2pH7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2615150"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="2615150"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 01:33:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="810538554"
X-IronPort-AV: E=Sophos;i="6.04,291,1695711600"; 
   d="scan'208";a="810538554"
Received: from unknown (HELO dev-ppiatko.ger.corp.intel.com) ([10.102.95.202])
  by orsmga001.jf.intel.com with ESMTP; 20 Dec 2023 01:33:07 -0800
From: Pawel Piatkowski <pawel.piatkowski@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/1] manage: adjust checking subarray state in update_subarray
Date: Wed, 20 Dec 2023 10:32:49 +0100
Message-Id: <20231220093249.2778-2-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20231220093249.2778-1-pawel.piatkowski@intel.com>
References: <20231220093249.2778-1-pawel.piatkowski@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only changing bitmap related consistency_policy requires
subarray to be inactive.
consistency_policy with PPL or NO_PPL value can be changed on
active subarray.
It fixes regression introduced in commit
db10eab68e652f141169 ("Fix --update-subarray on active volume")

Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
---
 Manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index f0d4cb01..91532266 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1749,6 +1749,7 @@ int Update_subarray(char *dev, char *subarray, enum update_opt update,
 	int fd, rv = 2;
 	struct mdinfo *info = NULL;
 	char *update_verb = map_num(update_options, update);
+	bool allow_active = update == UOPT_PPL || update == UOPT_NO_PPL;
 
 	memset(st, 0, sizeof(*st));
 
@@ -1763,7 +1764,7 @@ int Update_subarray(char *dev, char *subarray, enum update_opt update,
 		goto free_super;
 	}
 
-	if (is_subarray_active(subarray, st->devnm)) {
+	if (!allow_active && is_subarray_active(subarray, st->devnm)) {
 		if (verbose >= 0)
 			pr_err("Subarray %s in %s is active, cannot update %s\n",
 				subarray, dev, update_verb);
-- 
2.39.1

