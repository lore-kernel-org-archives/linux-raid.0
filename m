Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8478838F98
	for <linux-raid@vger.kernel.org>; Fri,  9 Feb 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483749; cv=none; b=lkxpQ8X03Ilzmmjh/lhcI02NyKdnK0KF6wJHituQPNkMLcqxa7hfwBjDx+Dg4G3V/uNPxJ/ixLrk/W4//Oa8n4etSU7glsWtUvDH1uQsbOkgHsDOUuFnH+iPg/fsN8KfsjAxCuoFW3ABSdVlHMwwQRVmH47E/87PEHwOYtSQbck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483749; c=relaxed/simple;
	bh=f9SfLbN0LUOIsJIJ5w9+26C18L8+kSqYcR1FatAjKZI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JWV1XtgH36gFiZo+KZLxPCbP+hD4cwOF5RS8A/GS2/G/gdUyaV/qI9VrcBt47zYYs4shrK3CMOqjdMfE9ufFmIHNMBPA8Ks4XXfKBWLbaxWWDkEMCOWvcb4KurtFNwFryrt4C68T0jUBOv2KkHs6nU9FnfosY2g+ESmZGy6VkfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXS9QXva; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXS9QXva"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707483747; x=1739019747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f9SfLbN0LUOIsJIJ5w9+26C18L8+kSqYcR1FatAjKZI=;
  b=iXS9QXva0MZv30ZolfXi7MjAC6Txqs6sA5Gv0Q4mTftCqL8uxDHq9qjR
   Jg3IuWnOWOHl+BheTeQG+22glUF72yfxgLaa1suFjYKpMQUhT/Y3IShRJ
   5nXPPflqMljYZ5DKnZyg6KlZTW3RMcIoAlzHeYgYeAa5PC5TYu788wo3k
   mEBHWIajA2jooizco1zeAZrJ4tJfJ/INflKdxoLbe0dgmR8RjJ6oJb+4W
   imvBti8rIdjLU6jPX5CM0dwcOG/4P0GKCfX4HV3SAIhSB7m+lN1+OS8e4
   RbqDcaKiFsCzQEraNBWAKvQGXWuL57e3/JfKLzSqIgx6Q2hW5q57ELcRc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="1576745"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="1576745"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 05:02:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="934419100"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="934419100"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 05:02:25 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH v2] mdadm: fix update=resync regression
Date: Fri,  9 Feb 2024 14:02:16 +0100
Message-Id: <20240209130216.19055-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mdadm --assemble --update=resync started failing  with the error
"mdadm: --update=resync not understood for 1.x metadata".

It is a regression. Add omitted branch to fix error.

Resubmitted, original author is not responding.
https://lore.kernel.org/linux-raid/ZZqJlCToUS3Qrl4J@bianca.dpss.psy.unipd.it/

Fixes: 7e8daba8b793 ("super1: refactor the code for enum")
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/super1.c b/super1.c
index 5fd2228efbd6..871d19f0398c 100644
--- a/super1.c
+++ b/super1.c
@@ -1348,6 +1348,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			__cpu_to_le16(info->disk.raid_disk);
 		break;
 	}
+	case UOPT_RESYNC:
+		/* make sure resync happens */
+		sb->resync_offset = 0;
+		break;
 	case UOPT_UUID:
 		copy_uuid(sb->set_uuid, info->uuid, super1.swapuuid);
 
-- 
2.35.3

