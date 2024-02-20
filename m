Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018EF6519D
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426804; cv=none; b=MyVczHgDAR92CIcEgICGIZzRiaEzCSxWvaHRrL8OlrQRt72oCTtr1PhCDAsBPqZCO2PqQvMQnt21vbTy4kDqrXkzMJUUgqCC0wAnBLyxwoYJUukZgILKGGdfVGOwqux22mEAnUH0LdNsi3nTMV9XVSOqyu2JL+ku0ooilkRPeWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426804; c=relaxed/simple;
	bh=x2KoYftDEHz0lbufDPCeiEQgtXN1BoQ0ClVX3Sq4w30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GaoMBwiPxLx0y4w3yzUuizqr5pTaDg7e6fE/WqRTLuB4pvFYLPElkntyjWS0LAyQNWg+O6Tba7HEY4Hb3nIXOflbv3xdt/QB+gQOSUQtyjwUggyyMuFRPLmfFAYGuerwK1YmG1Qrir3/Lzhw2PkcrzkOTWBSdwYnLcriHzS6vHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZI/LDdv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZI/LDdv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426802; x=1739962802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x2KoYftDEHz0lbufDPCeiEQgtXN1BoQ0ClVX3Sq4w30=;
  b=bZI/LDdvCLLgvlCGLuMLLsVqiXY6E2RCeKcPr673ljKBGQPj8xfAFYyJ
   jJ5/h9ELejhUmJLNPRB7gBHPvn91LEgqFCxyJmrSIefQw2Ai0MuItnXvC
   +NIYssiw4gAaj2A3jEMlxJJubn4+NyxlnPU3gpvaJuZNMGzL8K1ePjsiD
   BCaF/8FGtTVyxa4+CGguNM/ED4yGue7l3l5faw1q6adRSwq5uEnUoBvg5
   ZRI74qr+5eL+mxAPdAC3F3bSzTAFqmlgyc7291+iOQORWOM3yfNZdw8Aj
   g8b0djSjzDAc/dFO6HW6CtcbRwGKNj6T05UxgCJc5c2pqfjeTVDm76cde
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934349"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934349"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735117"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:00 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/6] Create: add_disk_to_super() fix resource leak
Date: Tue, 20 Feb 2024 11:56:07 +0100
Message-Id: <20240220105612.31058-2-mateusz.kusiak@intel.com>
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

Fixes resource leak in add_disk_to_super().

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Create.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 8082f54a8fdc..7e9170b6a1ac 100644
--- a/Create.c
+++ b/Create.c
@@ -279,8 +279,10 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 			       dv->devname);
 			return 1;
 		}
-		if (!fstat_is_blkdev(fd, dv->devname, &rdev))
+		if (!fstat_is_blkdev(fd, dv->devname, &rdev)) {
+			close(fd);
 			return 1;
+		}
 		info->disk.major = major(rdev);
 		info->disk.minor = minor(rdev);
 	}
@@ -289,6 +291,7 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 	if (st->ss->add_to_super(st, &info->disk, fd, dv->devname,
 				 dv->data_offset)) {
 		ioctl(mdfd, STOP_ARRAY, NULL);
+		close(fd);
 		return 1;
 	}
 	st->ss->getinfo_super(st, info, NULL);
@@ -297,6 +300,7 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 		*zero_pid = write_zeroes_fork(fd, s, st, dv);
 		if (*zero_pid <= 0) {
 			ioctl(mdfd, STOP_ARRAY, NULL);
+			close(fd);
 			return 1;
 		}
 	}
-- 
2.35.3

