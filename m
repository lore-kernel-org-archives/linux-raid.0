Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5312E54B6
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356679; cv=none; b=RHSZCPxmKJsta43RVYACVzcZYPbyd7jYh6YmmfedAz/+sCfo1BeTG3tFa+b1r2NkyrkTZlhSnwnh6dCtbHFIKHRrcTZkToVZQhRfhru349qvMwwF35wwbtztfT4OfMjss4Epj9fWXBSi6CRKKilO+bUucwB/LR2eUA59+y+Exrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356679; c=relaxed/simple;
	bh=wJwGNsCKVG/f8Ss3efnLIwS2SBUPVu5rqVJ/WyiG00o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CBTJmZvQv61VJFYWgt4cXGuWlxLArNE7bAdX2oNaOI+x+IVL+4s0q26lnQIqqsp/HdKZGB25LTKP/ZOBYKAVjcHjWLpzu02baj5X3GTT6HwUizwrt/hZfYhpRcIScMWmf092Xqk+Tc9N4tykbvq4Sy3H9CnnUpkF5gz7ltTLmIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=clD5x+iq; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="clD5x+iq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770356676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r5DB+bJFXpLxn+0lXCDrTPtAQL5wBGUVvKrZ4+SRa9k=;
	b=clD5x+iqnCujn1BxrSm3emM18wo+Lf9rFLcjKUJO/xtsPm7v7cMTZxPOQBRWv369NiSclh
	Tx0VJ/9Gk7vj3/EF56g95NZWKIQ1ZZZ1w99wNS2yA1oIJ4x0x67L3DGvknbyg/Xys+Hj5H
	ERAwwSJjHeh36R203Kc50YvjJSBnZoY=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH v2 0/3] lib/raid6: Optimize raid6_select_algo while ensuring
Date: Fri,  6 Feb 2026 13:43:38 +0800
Message-Id: <20260206054341.106878-1-sunliming@linux.dev>
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
Changes in v2:
  Select the highest-priority algorithm instead of the first one. 
  Add the cancel_work_sync function in the exit function to handle the 
work queue cleanup.
instead of the first one. 
--- 
sunliming (3):
  lib/raid6: Divide the raid6 algorithm selection process into two parts
  lib/raid6: Optimizing the raid6_select_algo time through asynchronous
    processing
  lib/raid6: Delete the RAID6_PQ_BENCHMARK config

 include/linux/raid/pq.h |  3 --
 lib/Kconfig             |  8 ----
 lib/raid6/algos.c       | 97 +++++++++++++++++++++++++++++------------
 3 files changed, 68 insertions(+), 40 deletions(-)

-- 
2.25.1

