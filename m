Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347FE2EA75E
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769597540; cv=none; b=GF5tT0sHoumA8HLwHJ/Sfpq0+kGjxz0NrxYFRtB4cZTc4AjsqlQOCGtN7dnfXEkt3qkvWKkaOW8KsEDIYOoDq/6255ekwnG9idicL48b/2o0w06Pj6mzMcNjBHUB6IUKkgYzUog4CnhHGcmj9v0FkoK0WuNibusqdnm3nmToIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769597540; c=relaxed/simple;
	bh=gBeVuT3VkniRDP8qDVe8Xy9ZcsJrltqWGbR6zsxuiqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FrTI4o1/hnBNH2H9krsXvtnKa2LQJhRTF3sFTbznXtvtOo4e/itLkbYNdYMj50HYHxMT17tQ/tLDRvpX7jn4FzVx8PTze8vQ/mfw+qPDvM0GT6qDljNCqHK7qpgENIFGaX/421Ayh59VjVwDZI1jUVgb+SF0q/TxmyGfdfi2rFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qR3Xr4KN; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qR3Xr4KN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769597537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LJbMSFFwXhx6/TbD1D2DmUClH5yrpPgPHreXTYz5qjE=;
	b=qR3Xr4KN94ITTe9K7IwpSIOvRRD2GW5B76jT7ZyiWsZZ3+JCXZzW3mVy0XEHIWTdds+ygl
	Q1Rf/7nGuOOlpmqSt9/6x/xatJi6D34Vj9gJ7BjlWROjLdObWp5W2CDsMG0GPFFr+0Ui+m
	JzZMtqP8EW0p78zKoJ82OgjVovyjd8I=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH 3/3] lib/raid6: Delete the RAID6_PQ_BENCHMARK config
Date: Wed, 28 Jan 2026 18:49:23 +0800
Message-Id: <20260128104923.338443-4-sunliming@linux.dev>
In-Reply-To: <20260128104923.338443-1-sunliming@linux.dev>
References: <20260128104923.338443-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

Now RAID6 PQ functions is automatically choosed and the
RAID6_PQ_BENCHMARK is not needed.

Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 lib/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 2923924bea78..841a0245a2c4 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -11,14 +11,6 @@ menu "Library routines"
 config RAID6_PQ
 	tristate
 
-config RAID6_PQ_BENCHMARK
-	bool "Automatically choose fastest RAID6 PQ functions"
-	depends on RAID6_PQ
-	default y
-	help
-	  Benchmark all available RAID6 PQ functions on init and choose the
-	  fastest one.
-
 config LINEAR_RANGES
 	tristate
 
-- 
2.25.1

