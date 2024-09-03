Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A838DC8
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725373793; cv=none; b=Y1XNkLiE7b3awAq+ObCj/CBYd0HkgLPauLUOQ/YSaYoVun1XoZecMp5crRY8/vYi/IY8TyZo6DVshXjOwZ760V4IJs3VFu2PdOl8fZxKPYKgGRBe5Q4Wo4RnzabGo3y3QEmIAy9HVuU+au2raZ6rhk7CQck9HvZnYturwFlCbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725373793; c=relaxed/simple;
	bh=Nx/psTWAL8BFSyqG56oyDy5FyEg0eWvlGPYa6DZZamQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FfM40917Y9hcwuqANNtOBGlkaT6apO0mQ9fhtml+KPxbTZdvTGCDityNbRSCfy8mye8y5W6lIXWY10Ot2jZBRMxzB0UmjVgfBcD1yqTWDSfiDC7ucbz9vJs0yRZSB944tRfgD7kBeGaPC0c39LHxiQVPxzVO9wivSH5XdQmo68M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sq2y8MfZ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sq2y8MfZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725373791; x=1756909791;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nx/psTWAL8BFSyqG56oyDy5FyEg0eWvlGPYa6DZZamQ=;
  b=Sq2y8MfZUFiRKZOoEVxaLjPE3vRK9FNhAxvZmuByNdPsPTstJ6GkkXbt
   Zc4mgFdXpYAC5+B88EMbcFSCc8u392mTstSc5jqixzw7d/KRGyeTkbUaG
   5M/e1y+wWEv1YpAp0LLE9OVKFR1vVfc2uI7OrtC8h9zJhaBmghxm4VjJD
   yp2qtRm5OhuAnSBroAaq8P6ldidfCsodz5bjcFGu79fW02NyCYuYq7W+N
   GvnIAxcLvzbosWSTUYhrQgCCgEnwSsCOPP/upS8LXkpJyoDQjLYWWUsiL
   g50FtLeZ0n2e3v/CDdRkQXYAJvP0JKYd95z2Twda5uKjBFX2QeSd9sv4a
   g==;
X-CSE-ConnectionGUID: du3Fn4gyTpCC6/NRZewyxA==
X-CSE-MsgGUID: 9vy+8WWXRcqi5nosFpVqjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23541821"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="23541821"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 07:29:50 -0700
X-CSE-ConnectionGUID: xhdf98q3RYyg+afSo+Mrtg==
X-CSE-MsgGUID: 1HTB9hUfQqeRs2kjAbvdvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="65661017"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa008.jf.intel.com with ESMTP; 03 Sep 2024 07:29:49 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
Subject: [PATCH] md: report failed arrays as broken in mdstat
Date: Tue,  3 Sep 2024 16:29:49 +0200
Message-Id: <20240903142949.53628-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Depening if array has personality, it is either reported as active or
inactive. This patch adds third status "broken" for arrays with
personality that became inoperative. The reason is end users tend to
assume that "active" indicates array is operational.

Add "broken" state for inoperative arrays with personality and refactor
the code.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..28d9898e9173 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8390,14 +8390,19 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	spin_unlock(&all_mddevs_lock);
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
-		seq_printf(seq, "%s : %sactive", mdname(mddev),
-						mddev->pers ? "" : "in");
+		seq_printf(seq, "%s : ", mdname(mddev));
 		if (mddev->pers) {
+			if (test_bit(MD_BROKEN, &mddev->flags))
+				seq_printf(seq, "broken");
+			else
+				seq_printf(seq, "active");
 			if (mddev->ro == MD_RDONLY)
 				seq_printf(seq, " (read-only)");
 			if (mddev->ro == MD_AUTO_READ)
 				seq_printf(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
+		} else {
+			seq_printf(seq, "inactive");
 		}
 
 		sectors = 0;
-- 
2.39.2

