Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67853248886
	for <linux-raid@vger.kernel.org>; Fri, 20 Mar 2026 06:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773986926; cv=none; b=Lzufp7ViL/5h7htGbSMwJIoTqToe9piF/71yTW32+v9S/jHnZFdnej5fpHWDuKBP0jx+IeXxc5+m9pRxzM+sUJnMlWMhpc0iDFXUIi1VDQH63Hmr5FhBwuWq52yRypDMExBWjectzXQkj8LDWuAYIM8feNimBC+KvmhINkO3xeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773986926; c=relaxed/simple;
	bh=42tZm+Vt/9yPVj3eILSJ0zGwQaxLTdOwcQFBTMY4SGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CrMGS0JRjOZp2BnzdGA7+NeBN0cPrSqOTyl34ygMqoYiXRocUIXl7m4oiGIcXk+3sXGsi22H2wdpk98jbxOiSfzkNp4m17GYO8bxna4W8yzxYJDTmhaw1J2pDxRoq3pGozEJRlrgMMpbJYny5KeS++r+V2jMjXz4q6WU+B5lzj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i1RVsMkc; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i1RVsMkc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773986923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IrxB7+ySBZi8/xCXVrmxFtJQAYKTfVYGUULZH/QAZpg=;
	b=i1RVsMkcBaoh7AoWPfnCwq6PHR6bA0f+9gw3h2Fm8eQ6zWc1YIrcKvZ6V4aGzDPO/gsxla
	DBL1jYGf0WEZPurqy3nYBFJrj7u10qnB0KQctJswddOQxwN2H0XbdISw/5AKACvP0HQIyU
	MNbeZrhF3x/ocRuNGBrTmRdnThrQP6s=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com,
	akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH RESEND v3 0/3] lib/raid6: Optimize raid6_select_algo to ensure 
Date: Fri, 20 Mar 2026 14:07:47 +0800
Message-Id: <20260320060750.31334-1-sunliming@linux.dev>
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

