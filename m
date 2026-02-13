Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3911E49F
	for <linux-raid@vger.kernel.org>; Fri, 13 Feb 2026 03:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952525; cv=none; b=NGLxOmPC4bDwS1gLWGXcbNlEwNihNhoUYxhMKkHA3ybxqkEfiS8zz3nWpVYOgPmzJm1lRgrf3QutO+4vO2ix2Dy2gUy4YW0Lgbumn26kEDajtnvaE9WzFe7mmYsaNjxm0BcQ5RPYwRoIJjze6wfhySAdde2CYidIDFhm4yioUM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952525; c=relaxed/simple;
	bh=n7LgFgkZ88IJ/hMH3zs0Om6GScBtmFY7Jf38aF0UOq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O8NYqiSeCKiufn4DCzsxkd5HtktZ+lhXU3/mYTNc1TXR8vDxOObwriKOEh0FbdEw9V0dFqfxpXoSw/BMYwTI28NkI9sTCGf47EH4wXDluUaWq60k9oIglGfi1yznY2yTpGeJq6teJsxZ+zENiZxRTS+1YPhqnn1UYo01Rf+Qn0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2uikVt1; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2uikVt1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770952523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXo6H32cr3HG8t0LoC8JWMAyx4PWbzKReGAxpF5HxXc=;
	b=O2uikVt1d9edc9RJi53G8zIXQfLsGYX11m5f4ogipZLR6gsLoDFhRHVPk2G6ZwC3EGyr5h
	EVykxWB+TRaQiG29kyCcODMTw1djQuJMkhaYCzZFT/C2bndBM3Bl+94VnNx9qenRkWkKNL
	YURSiwJJ0cFQL9A13XYOPr7dGg3rNJk=
From: sunliming@linux.dev
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: [PATCH v3 3/3] lib/raid6: Delete the RAID6_PQ_BENCHMARK config
Date: Fri, 13 Feb 2026 11:14:19 +0800
Message-Id: <20260213031419.125069-4-sunliming@linux.dev>
In-Reply-To: <20260213031419.125069-1-sunliming@linux.dev>
References: <20260213031419.125069-1-sunliming@linux.dev>
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

