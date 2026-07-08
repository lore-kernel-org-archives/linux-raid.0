Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF203E9F8E;
	Wed,  8 Jul 2026 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501685; cv=none; b=dyqgtbR/WzwN/5cTLviahCzpguBT7k5tAj0wm0eC4GC8S2s1J8+P5+MpN6PzbTj1j/0ollXBa//k24qOiOzzDCqkI0sO4xpqzAQa8VZBVAENshAyCOK7vh+PDiwmjpKn6+SQ48W5iLayjVqTBB0KqeaM2YD6m6HfeHhrV/5NUsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501685; c=relaxed/simple;
	bh=bAi4GFsCtXMCa2fv7gvlCsYjksw9Ojnjw6ktqDlfffk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWQV4BaeefIeNyE61sRhQCQ6cSB4k00j07WVfq101CSoZqU2KbbJlhvnyXtVyqc+zD88Tu4WI9UYJ8hlalwValqKe9aZFBdp8joxh5bHYEfSTKG7+UIKhnjyskw5sgpbJ8+oiUq0mNx+5b+weoutKZxSXFNXGHI4dexJqqRIuE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V24lmPR+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V24lmPR+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xIp4AFNsOEkFu3HfIJO+aQ4ejZi7hMMaLL5cHK+pPTM=; b=V24lmPR+Lj/F3jaP5Kphs4ViOW
	PohpGCFC+c5+N8+D3y0h0senxN1I496qgMduhjrRU1scwj9QB60yJT2zJWWQMMzeSmqNikMQkKV2X
	nBUc5+ysEO+sCDLnLggl3gO+3EOIpSTC6kJVJj12p2gQ9mI6xMCp4wrycn0AMyO20VhPAR7IfKsHx
	4EDGcQWC4FT/cdbzrH2b5iLud4F3vUZBRMAjTVdh9AdByZGPTu8+LgLOZRMHTYWKpoq8iJAyFRM4w
	4IHohHDYR+Q00IaRdU/j09iD50bcw8l2lG2XK4NoC8/h111maijL6vBBWKiVkgItF3R3g3P36NfwS
	kvBBAPDg==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOGB-0000000Gi95-0ZoM;
	Wed, 08 Jul 2026 09:08:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] xor/kunit: add a benchmark
Date: Wed,  8 Jul 2026 11:07:33 +0200
Message-ID: <20260708090740.1433685-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708090740.1433685-1-hch@lst.de>
References: <20260708090740.1433685-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a benchmark to test the XOR functions for more representative block
sizes and numbers of disks.  Including 64k would be useful here, but
increasing the test buffer size increases the runtime of the functional
kunit test too much unfortunately.

The runtime numbers are reported in GB/s as the numbers of modern
implementations are basically unreadable as MB/s.  This means
retro-architectures could report 0, but that is an easy tradeoff.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/Kconfig               |  6 ++++
 lib/raid/xor/tests/xor_kunit.c | 62 ++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index 978cd6ba08ac..c4eeb7c716c8 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -29,6 +29,12 @@ config XOR_KUNIT_TEST
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config XOR_BENCHMARK
+	bool "Benchmark for xor_gen"
+	depends on XOR_KUNIT_TEST
+	help
+	  Include benchmarks in the KUnit test suite for xor_gen.
+
 config RAID6_PQ
 	tristate
 
diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kunit.c
index 659ae3edbc25..648c6da9464c 100644
--- a/lib/raid/xor/tests/xor_kunit.c
+++ b/lib/raid/xor/tests/xor_kunit.c
@@ -125,8 +125,70 @@ static void xor_test(struct kunit *test)
 	}
 }
 
+static void xor_benchmark(struct kunit *test)
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
+	if (!IS_ENABLED(CONFIG_XOR_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* warm-up */
+	for (i = 0; i < ARRAY_SIZE(nr_to_test); i++) {
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			for (l = 0; l < 10; l++) {
+				xor_gen(test_dest, test_buffers, nr_to_test[i],
+						len_to_test[j]);
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
+		KUNIT_ASSERT_LE(test, nr, XOR_KUNIT_MAX_BUFFERS);
+
+		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
+			unsigned int len = len_to_test[j];
+			const unsigned long num_iters = 1000;
+
+			KUNIT_ASSERT_GT(test, len, 0);
+			KUNIT_ASSERT_LE(test, len, XOR_KUNIT_MAX_BYTES);
+
+			preempt_disable();
+			t = ktime_get_ns();
+			for (l = 0; l < num_iters; l++)
+				xor_gen(test_dest, test_buffers, nr, len);
+			t = ktime_get_ns() - t;
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
 static struct kunit_case xor_test_cases[] = {
 	KUNIT_CASE(xor_test),
+	KUNIT_CASE(xor_benchmark),
 	{},
 };
 
-- 
2.53.0

