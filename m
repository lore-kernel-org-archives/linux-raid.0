Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA029D517
	for <linux-raid@vger.kernel.org>; Tue, 27 Aug 2024 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772946; cv=none; b=P0DOl+BnEVTKAlZdiE9Np6KucC0HwnDNgitX76QGrJrjXlxsA3MbD8uCLZuWd95ndbOPHjednCHXe1zpKaSAespqY78UQP6kZQy02N1HuROEmVBXg7Qc18iK3nqECffhTKn0ry2NSnGMcby0VkQxVibVxDQjUmMPtTHL2fi/0M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772946; c=relaxed/simple;
	bh=ZJPIwHFxitdf/WC1HAY5wFpY6qQWIvX3sWCp4kbnDIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FhMoklHnPK2edrGYjMuWcptHVFz/R2hdjoTGvYoTjhKuEQtQc9ktVQtZ38AzX40TTxjbvXBSi4PeUdK3qT62hnJBVjOcNPf3ww4jMMDz/OUelH8j2wAivu8dUYoi7S5F8xdj6ESmSOfzh0lH9DzkT7PkeV9YqWpu29vHm5qhXoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jqMbrbE1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jqMbrbE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724772946; x=1756308946;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZJPIwHFxitdf/WC1HAY5wFpY6qQWIvX3sWCp4kbnDIQ=;
  b=jqMbrbE1M4UJTHiJ/fnMj1oxmCrMY1U0jeXw9Bxv2JCw4N/eTuieTeQj
   PIFSZV6fhuGlN/VVGvSPRvjGw2vtivKfGE+5yU9sFynUi5/vukqRns6Yx
   z7k2e9o45LWKM3Jro46dgOUhKofYidoU38ZHgJcA9broiqainoIo0J2iq
   UzKxoBDOhNovAUMHzcbPxi085GCztS32CmdXFXmuW78k8DW7uZiwZyk2K
   r3nQNkyf7N19z/xTz+NPykPEzdI1wCUSbWfG4IHfQvlCZ28+/kDs7HdV0
   yomYwZ6we+gD9QRGbuoUuVXjAH2811aj5F8nEcClahkJrK5cvfgpIx5Yq
   g==;
X-CSE-ConnectionGUID: mFHKOTs4R1+DFUUwo+gp0Q==
X-CSE-MsgGUID: CyWKG3acQBy4ybk0xMsGkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="34634183"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="34634183"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:45 -0700
X-CSE-ConnectionGUID: 9UmOfZ5/RdSao3jaYpKLKA==
X-CSE-MsgGUID: j2tyKejQR2m62C0sDb30Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="62628228"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO apaszkie-mobl2.intel.com) ([10.245.244.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:43 -0700
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com
Subject: [PATCH 0/3] Optimize wait_for_overlap
Date: Tue, 27 Aug 2024 17:35:33 +0200
Message-ID: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wait_for_overlap wait queue is currently used in two cases, which
are not really related:
 - waiting for actual overlapping bios, which uses R5_Overlap bit,
 - waiting for events related to reshape.

Handling every write request in raid5_make_request() involves adding to
and removing from this wait queue, which uses a spinlock. With fast
storage and multiple submitting threads the contention on this lock is
noticeable.

This patch series aims to resolve this by separating the two cases
mentioned above and using this wait queue only when reshape is in
progress. 

The results when testing 4k random writes on raid5 with null_blk
(8 jobs, qd=64, group_thread_cnt=8):
before: 463k IOPS
after:  523k IOPS

The improvement is not huge with this series alone but it is just one of
the bottlenecks. When applied onto some other changes I'm working on, it
allowed to go from 845k IOPS to 975k IOPS on the same test.

Artur Paszkiewicz (3):
  md/raid5: use wait_on_bit() for R5_Overlap
  md/raid5: only add to wait queue if reshape is in progress
  md/raid5: rename wait_for_overlap to wait_for_reshape

 drivers/md/raid5-cache.c |  6 +--
 drivers/md/raid5.c       | 95 +++++++++++++++++++++-------------------
 drivers/md/raid5.h       |  2 +-
 3 files changed, 52 insertions(+), 51 deletions(-)

-- 
2.43.0

