Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D0604A9
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426822; cv=none; b=fRdTgiW/tONpXlZCRtvsk0gx8Ia+x32zt/GGHm3jhCiyuPPc97cPsyS0aEhlHnsuMavNKtbWFysPuZVs7vg9eXFHrbsubYzsF9seC13bcVLcet4HkxACmpr/X0mgs3eJtwoYWmrHriJETDKsYw7+M3nCnThqAL0dHe4/PiBYA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426822; c=relaxed/simple;
	bh=VLHAm3B8oDXNldh/BoehL9lUhriSMItyFiQV7EYEbe0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R/RYcRePuZsOEDgNTyv7a5twKtuCb5NOGX0gdsql7xwVTnIQ5i0N4+kayyPpxb7/66uE3ZsZ8v2z/MgmTsFNUPluZyn07TmBRDO0TkpFA/fGSNIdFeqCb4Fw19BapMmfiJl5S9ZwNlSyPGdbWsE9SL2vDZZuoSPvJ3P6k249Y34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b6iiPVUx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b6iiPVUx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426821; x=1739962821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VLHAm3B8oDXNldh/BoehL9lUhriSMItyFiQV7EYEbe0=;
  b=b6iiPVUxNdVS94iucVs4NqSOhBGMkfAemOpTCdcQoknROGXAMGwYuayb
   I4axKCQlgsRnMo/Bda5tYhw2M7g10FYkMRHViLweclVfmW06Xhvv+x8ED
   rBpm8cB0TdAwcgD+1GRt86okdjzdzlx9UyB3OCQoQo3GHn8tslTyskrMz
   fjuRaadm5b+7WImz5VPV4FoEsWjGJRM7rpP27fudOqR4aUblYTYUh49E6
   NZ4rhKG3CcPv1P/wQrCeo5yHsxgdaXbL7PaPUe16+Pw5IXVBnSyhusAdU
   qGZauG7kcQ6A2HBv5xW3obyvIyAwEr3knnpZgiAaZaTAt4P1ub2ee09AQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934376"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934376"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735204"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:19 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 4/6] Grow: remove dead condition in Grow_reshape()
Date: Tue, 20 Feb 2024 11:56:10 +0100
Message-Id: <20240220105612.31058-5-mateusz.kusiak@intel.com>
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

Remove dead "if" condition from Grow_reshape(). Sysfs read check is
performed earlier in the code.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Grow.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index f95dae82ef0d..dad7294dac32 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2097,11 +2097,7 @@ int Grow_reshape(char *devname, int fd,
 			/* got truncated to 32bit, write to
 			 * component_size instead
 			 */
-			if (sra)
-				rv = sysfs_set_num(sra, NULL,
-						   "component_size", s->size);
-			else
-				rv = -1;
+			rv = sysfs_set_num(sra, NULL, "component_size", s->size);
 		} else {
 			rv = md_set_array_info(fd, &array);
 
-- 
2.35.3

