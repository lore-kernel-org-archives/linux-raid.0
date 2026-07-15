Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9740EBBF;
	Wed, 15 Jul 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126938; cv=none; b=XpSAzpo4GNjr8V/TAfrOoLbPE4r+HApELgOg+euiGiMuYphif8mFF+SiDFSen+TRQB5nSYG5fvBk0M2lTdbLx45kXtUEGIl1s49mqCN0QGNvKpuW2UQHnvXniAZmpgE+rIH+moaP828CK7lYEIAvxtJeeXwxpeZrrImc1XHd3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126938; c=relaxed/simple;
	bh=8W+Ss+2PANi2BfQ01B0yUtVzQ5aRwp7cXYnHuJxJ1iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYdwKbvsOt71S6tKwXfspW/+6+Kgq9yymWpp/L8aFdQtX8Wmrm/aIkxcvj/TFkufwVUiVNYeY6/VhFUWwDSO7UhMTlnfETnAN8t4JFx/H/CeC0uVTmMLgYkUr04XkFc16UaJPLnFS9wvPHzO5QDa6gDnS5XizQXfN41lB7/aZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dboMkrB9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dboMkrB9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mtH4r8jn19iSEHcKpjue13axJM6zZbL6f+5rzSR7b7Q=; b=dboMkrB9rH2oiHU5A+GthQBOqs
	URg8Qukh4II5tPqs7CgLOugWQU/ivt5gGdHBgE3qOU8MGOxET8oziW2lxwFbrEqgK7461MHYA68h3
	cM+NjB4v1ZqzmqvGhOw32mcLWce343zbfGdiCI4rAJ8+HG6OWt9Vxxd9RNXaRVgIyp5qSJrePWb47
	j/gP7cyr9912SAV9WpHbBXe1i5QXN0kxqqAC7ryzUBIiUgSrmgnPntAa4GDste8nE4hXo4Fcss63Y
	nTjuhK1TZVJbyC87e7wJegWuKXncjJULC1EZQKtUdfinT1D+WjoD2eTw1nVLRpmrnSwoRdWDLJSCr
	800F7I0Q==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0uu-0000000FDC8-0ex7;
	Wed, 15 Jul 2026 14:48:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] raid6/kunit: add a benchmark
Date: Wed, 15 Jul 2026 16:47:39 +0200
Message-ID: <20260715144825.95432-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144825.95432-1-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a benchmark to test the RAID 6 P/Q functions for more representative
block sizes and numbers of disks.  This splits the maximum alloc size
used for the benchmark from the max size for the kunit test because
recovery is currently limited to a single page at a time.  Hopefully this
will be fixed soon.

The runtime numbers are reported in GB/s as the numbers of modern
implementations are basically unreadable as MB/s.  This means
retro-architectures could report 0, but that is an easy tradeoff.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/Kconfig                   |  6 +++
 lib/raid/raid6/tests/raid6_kunit.c | 66 +++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index c4eeb7c716c8..01f007b2522c 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -60,6 +60,12 @@ config RAID6_PQ_KUNIT_TEST
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config RAID6_PQ_KUNIT_BENCHMARK
+	bool "Benchmark for RAID6 PQ"
+	depends on RAID6_PQ_KUNIT_TEST
+	help
+	  Include benchmarks in the KUnit test suite for raid P/Q generation.
+
 config RAID6_PQ_BENCHMARK
 	bool "Automatically choose fastest RAID6 PQ functions"
 	depends on RAID6_PQ
diff --git a/lib/raid/raid6/tests/raid6_kunit.c b/lib/raid/raid6/tests/raid6_kunit.c
index 9f3e671a1224..7d0a1ec98001 100644
--- a/lib/raid/raid6/tests/raid6_kunit.c
+++ b/lib/raid/raid6/tests/raid6_kunit.c
@@ -18,6 +18,7 @@ MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 #define RAID6_KUNIT_MAX_BUFFERS		64 /* Including P and Q */
 #define RAID6_KUNIT_MAX_FAILURES	2
 #define RAID6_KUNIT_MAX_BYTES		PAGE_SIZE
+#define RAID6_KUNIT_ALLOC_BYTES		SZ_16K
 
 static struct rnd_state rng;
 static void *test_buffers[RAID6_KUNIT_MAX_BUFFERS];
@@ -229,6 +230,68 @@ static void raid6_test(struct kunit *test)
 		raid6_test_one(test);
 }
 
+static void raid6_benchmark(struct kunit *test)
+{
+	static const unsigned int nr_to_test[] = {
+		4, 5, 6, 7, 8, 10, 12, 15, 16, 32,
+	};
+	static const unsigned int len_to_test[] = {
+		SZ_4K, SZ_16K,
+	};
+	unsigned int i, j, l;
+	u64 t;
+
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_KUNIT_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* warm-up */
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			for (l = 0; l < 10; l++) {
+				raid6_gen_syndrome(nr_to_test[i],
+						len_to_test[j], test_buffers);
+			}
+		}
+	}
+
+	/*
+	 * Preferably this would be a loop over len_to_test, but the kunit
+	 * logging always adds a newline to each logged format string.
+	 */
+	static_assert(ARRAY_SIZE(len_to_test) == 2);
+	kunit_info(test, "          \t%5u bytes\t%5u bytes\n",
+			len_to_test[0], len_to_test[1]);
+
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		unsigned int nr = nr_to_test[i];
+		u64 speed[ARRAY_SIZE(len_to_test)];
+
+		KUNIT_ASSERT_LE(test, nr, RAID6_KUNIT_MAX_BUFFERS);
+
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			unsigned int len = len_to_test[j];
+			const unsigned long num_iters = 1000;
+
+			KUNIT_ASSERT_GT(test, len, 0);
+			KUNIT_ASSERT_LE(test, len, RAID6_KUNIT_ALLOC_BYTES);
+
+			preempt_disable();
+			t = ktime_get_ns();
+			for (l = 0; l < num_iters; l++)
+				raid6_gen_syndrome(nr_to_test[i],
+						len_to_test[j], test_buffers);
+			t = max(ktime_get_ns() - t, 1);
+			preempt_enable();
+
+			speed[j] = div64_u64((u64)len * num_iters * nr, t);
+		}
+
+		static_assert(ARRAY_SIZE(len_to_test) == 2);
+		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
+				nr, speed[0], speed[1]);
+	}
+}
+
 static const void *raid6_gen_params(struct kunit *test, const void *prev,
 		char *desc)
 {
@@ -256,6 +319,7 @@ static const void *raid6_gen_params(struct kunit *test, const void *prev,
 
 static struct kunit_case raid6_test_cases[] = {
 	KUNIT_CASE_PARAM(raid6_test, raid6_gen_params),
+	KUNIT_CASE(raid6_benchmark),
 	{},
 };
 
@@ -270,7 +334,7 @@ static int raid6_suite_init(struct kunit_suite *suite)
 	 * so that it is immediately followed by a guard page.  This allows
 	 * buffer overreads to be detected, even in assembly code.
 	 */
-	test_buflen = round_up(RAID6_KUNIT_MAX_BYTES, PAGE_SIZE);
+	test_buflen = round_up(RAID6_KUNIT_ALLOC_BYTES, PAGE_SIZE);
 	for (i = 0; i < RAID6_KUNIT_MAX_FAILURES; i++) {
 		test_recov_buffers[i] = vmalloc(test_buflen);
 		if (!test_recov_buffers[i])
-- 
2.53.0

