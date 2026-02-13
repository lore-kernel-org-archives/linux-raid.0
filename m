Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7583225775
	for <linux-raid@vger.kernel.org>; Fri, 13 Feb 2026 03:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952517; cv=none; b=KdXTknHC3JCs38c2ix6R/RiQdLnZmkZP2o/y3fjGFrQ6LlWWl1J/tgcd39CWuCi6vC7jIvdIoO81EAvLDZWQVe2ATkBRAtdOHz6GwWxrddxTdHOewspEJ+cOLTP3hsepMXghh/b1A8fLZrPMvDeqPpbECF6XZDNugKO5wUT4YeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952517; c=relaxed/simple;
	bh=42tZm+Vt/9yPVj3eILSJ0zGwQaxLTdOwcQFBTMY4SGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g2ViABL+nafEJikyHhIqSKPBWAaWMO89AudIAe+Y18M3r0sWjluXyfLJyzBh/LExigfGm9zO6AQ2T4hLu+lK5e5SgHLzAj/aGWPOt6hY0+1jqY0oPAXR30FPndsGPyNT6hTCq4iw56u4r2fDGh/Szvrc/8ZFu4GZRUu5uVo/zTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ie6EXXQT; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ie6EXXQT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770952503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IrxB7+ySBZi8/xCXVrmxFtJQAYKTfVYGUULZH/QAZpg=;
	b=Ie6EXXQTrD41SBiCNtJWtxmUgV+j0OAkUm/TKkNdG2b/XOmub00nnD/LbM7rUJjcEt8Gx7
	1qVh/+C7TPJAmnvhXj1M+h9m6oKvrwh10AmXCfcRweJoMbK1e22Pbtl9eEsBfEA1saXJGc
	zOGyBhnbnGgCSrwTXk7PnvndfJ18cog=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH v3 0/3] lib/raid6: Optimize raid6_select_algo to ensure 
Date: Fri, 13 Feb 2026 11:14:16 +0800
Message-Id: <20260213031419.125069-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

The selection of RAID6 PQ functions involves a dual-strategy approach:
prioritizing startup speed leads to quickly choosing a usable algorithm,
while prioritizing performance leads to selecting an optimal algorithm
via benchmarking. This choice is determined by the RAID6_PQ_BENCHMARK
configuration. This patch series achieves both fast startup and optimal
algorithm selection by initially choosing an algorithm quickly at startup,
then asynchronously determining the optimal algorithm through benchmarking.
Since all RAID6 PQ function algorithms are functionally equivalent despite
performance differences, this approach should be effective.

---
Changes in v3:
  Remove the __init annotation from raid6_benchmark_work and benchmark_work_func,
as they are still referenced during initialization.
Changes in v2:
  Select the highest-priority algorithm instead of the first one. 
  Add the cancel_work_sync function in the exit function to handle the 
work queue cleanup.
--- 
sunliming (3):
  ib/raid6: Divide the raid6 algorithm selection process into two parts
  lib/raid6: Optimizing the raid6_select_algo time through asynchronous
    processing
  lib/raid6: Delete the RAID6_PQ_BENCHMARK config

 include/linux/raid/pq.h |  3 --
 lib/Kconfig             |  8 ----
 lib/raid6/algos.c       | 88 ++++++++++++++++++++++++++++++-----------
 3 files changed, 65 insertions(+), 34 deletions(-)

-- 
2.25.1

