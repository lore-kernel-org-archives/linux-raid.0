Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1BF28CF6F
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 10:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769597438; cv=none; b=nOVBWTDlrpQ3efiVdSFaqFamabPkZSlXZgrVZAIXEn2IVUV3SRCrAVZOhPDe+t4X+dzQ1pQmvJD2LnK1XKTMTiBBwVGgWEdTpZZ4tqh/egZko3oqpsUDSGqWc7/aEF6ZnJEbUjY4MJOEWXky6z23Ry3wxohi/LlMl5hfci8SOAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769597438; c=relaxed/simple;
	bh=3c88eq/vkiBBFg8G5Y5ix6d10eMfgWtdOtSCSCj6MUU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f7ZjvRcfve90ZaYE3QreOYpauyOqAyWd7Ib57gML3Kd8k8ar43GMFaJLA0ZDj7N9JYhv9FDLeUZ7czkxqGBB3kKIXHg/Uxx0n91GzzyExqlVatIaNEArCBcfYb305AHK141pl9TmRn753n8aEbOx2uG8nqh50tl/NTSq0qBPhyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JzRQek63; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JzRQek63"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769597425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4wLwicyTPgku+Hi0uh/8UAR6eAZoCvd8gcFp7qpoZoc=;
	b=JzRQek63mMf76cocJLFSQ2xgObdhPIb6o/gvpyiiiB81zaA4uMTLfEEHYdOvSeNNadb5eI
	cxUsHbChf1+u0Z5GnkYFxjnvkRWOcKMr2RjUAD+TYFjijfkw5Ovz2Snb5CG48o3KXR9DaD
	TXHMiHkY1i4u1X6MDVazkaRJzibN5wU=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH 0/3] lib/raid6: Optimize raid6_select_algo while ensuring
Date: Wed, 28 Jan 2026 18:49:20 +0800
Message-Id: <20260128104923.338443-1-sunliming@linux.dev>
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

sunliming (3):
  lib/raid6: Divide the raid6 algorithm selection process into two parts
  lib/raid6: Optimizing the raid6_select_algo time through asynchronous
    processing
  lib/raid6: Delete the RAID6_PQ_BENCHMARK config

 lib/Kconfig       |  8 -----
 lib/raid6/algos.c | 92 +++++++++++++++++++++++++++++++----------------
 2 files changed, 61 insertions(+), 39 deletions(-)

-- 
2.25.1

