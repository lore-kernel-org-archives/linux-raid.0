Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F00157487
	for <linux-raid@vger.kernel.org>; Fri,  6 Feb 2026 05:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770356781; cv=none; b=SeBtdNJJbHFi/4z9DLch5aZzSUitH9W4na9lEFz77RLD9oFq72y/wJmp87BCTSwutJy7O5Bs8e3DTf64KB5OVpvUxKxWZ9+ZinQGDf1JN3Kj3X1Uq/Xl0oH4EK7U1hOUc2tMhDDJ5+DNz9EE6mIfbCKDM+2P3BuAweoIuVgnQdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770356781; c=relaxed/simple;
	bh=n7LgFgkZ88IJ/hMH3zs0Om6GScBtmFY7Jf38aF0UOq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NVJtKXpS53+eEqxkF76k4+ua6I8BDDedu4GBG0+iKjA7RZxeBScdi3aNF+bU+TXWeCcwW5pXTOboEiPQZMJEG4p2L+9UToyxs7X9rV3NBwdNFQEQuL3CVUaRvhO969r00vPywRvU7078BvwcgTt28SdUF6G1XnriVt+abksu4Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkpzHMpq; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkpzHMpq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770356779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXo6H32cr3HG8t0LoC8JWMAyx4PWbzKReGAxpF5HxXc=;
	b=vkpzHMpq7y33NMIh3gxFClI65rBhs+nce3vOcWsYeSQnr4b8MKX+4/8iOq66ws6SI7KnOP
	WdsIksWHtIEksuWv97G02RL97xX7pFGMflWAt621QCfsAAwF/gM2sKQKW33YZellVjgxAN
	IGjOyJRBTooBY3Wq7mm+OtrZbLAtocQ=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH v2 3/3] lib/raid6: Delete the RAID6_PQ_BENCHMARK config
Date: Fri,  6 Feb 2026 13:43:41 +0800
Message-Id: <20260206054341.106878-4-sunliming@linux.dev>
In-Reply-To: <20260206054341.106878-1-sunliming@linux.dev>
References: <20260206054341.106878-1-sunliming@linux.dev>
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
 include/linux/raid/pq.h | 3 ---
 lib/Kconfig             | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 2467b3be15c9..6378ec4ae4ba 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -67,9 +67,6 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 #define MODULE_DESCRIPTION(desc)
 #define subsys_initcall(x)
 #define module_exit(x)
-
-#define IS_ENABLED(x) (x)
-#define CONFIG_RAID6_PQ_BENCHMARK 1
 #endif /* __KERNEL__ */
 
 /* Routine choices */
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

