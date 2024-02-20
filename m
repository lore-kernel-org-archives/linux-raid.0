Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BF164CF5
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708426828; cv=none; b=mj/L8pUABDfWdZ8Inir0y3JgUwKpaLk7bmkV10AsR4MyhsvEouUTGgqAPhMiIExEEjnt9R2ta/tBGbiYhu1vsW+v5Wqjrx5xsuf3LA4EsKNnC1zr0sS401dh3vs+pQPuzGAQUAEE+7qVNAm2eB0d1PibZCSkSyQXBq3p6DIm3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708426828; c=relaxed/simple;
	bh=vUFdPLdyi1OERlX10UiyC7l5o+OfqCTO3hq3rWuCthU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MX4v6D15Ef5T30/+qrnP40tk75OYOmJnTP0YDGBfx5azU69xyalJ+vvt31wO16R8CfuGK9ftnlWpsxz3aK28HvMZurwHEBGE8w/IBo1BF06eQruB7rBZLrDfOfn7oaHaJ1KaY4w3s9ZMXs0JeJRjEJzL37Hp7mz0gdprfUu/kZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tg7ReYkP; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tg7ReYkP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708426827; x=1739962827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vUFdPLdyi1OERlX10UiyC7l5o+OfqCTO3hq3rWuCthU=;
  b=Tg7ReYkPp3p2WUcUUUnjqyQQhRvleluUugCW+kc3NQjCRjdkNep0LMbU
   aiYPJUU2eH/tDfX2dMUU9xOBZJ5IABaMN6pCZXCtnA+1zW1dnyUDd8J6Z
   jFt4hD3lKJ918MwKpUfBaoKYi1VZPmtHReh87KmBDyhv0su88DQ3xYX+G
   k44bv8OCu1rKu//zwaHSRDR5g2SAjDMAeUYULMZ44StUs05XteZbd2Hi2
   dikXOt0zkAY1pqDOlV70AQ17KZEpb5I9iYd3eytvFGHNB4TYUkXobRuaD
   d8u/0VSXefjn/Trp7i/EWuZ1zQYIqqhToGfh74zaF8a7n8zXEyJd90+z3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13934381"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13934381"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 03:00:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="4735214"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmviesa010.fm.intel.com with ESMTP; 20 Feb 2024 03:00:25 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 5/6] super1: check fd before passing to get_dev_size() in add_to_super1()
Date: Tue, 20 Feb 2024 11:56:11 +0100
Message-Id: <20240220105612.31058-6-mateusz.kusiak@intel.com>
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

Check if file descriptor is valid before passing it to get_dev_size() in
add_to_super().

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 871d19f0398c..5439b7bb1240 100644
--- a/super1.c
+++ b/super1.c
@@ -1752,7 +1752,10 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	di->devname = devname;
 	di->disk = *dk;
 	di->data_offset = data_offset;
-	get_dev_size(fd, NULL, &di->dev_size);
+
+	if (is_fd_valid(fd))
+		get_dev_size(fd, NULL, &di->dev_size);
+
 	di->next = NULL;
 	*dip = di;
 
-- 
2.35.3

