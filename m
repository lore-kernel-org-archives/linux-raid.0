Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C193A257F;
	Wed, 17 Jun 2026 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675068; cv=none; b=cDKg9162vSRA6MV11C86SLMr6SuT7rxWzL6mIz97bd+Xi8xK7ksvH7vwLame4x/henzSqOofmLNebhe5Sp3jgsUD2XaPz4oaKr1BYKey0bbLWplComeeA/DhmBbRCXtSFqapELx5iUwTQQFoF4heM02BqRwqYMqhxtpctPMn6qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675068; c=relaxed/simple;
	bh=k1QIDFBbKeMxZZZZ6GkrG5TEug8MsjmP3AKJ0oumzfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWnmI4MOWhb/bUe6uA3flhEeCOImCh9inteFU6t4bee8Q8B/lTXp1KIhWxYtL/sSbOcpHhgFY1trm4QT7OCSWU4kitG5TtklbYQik7iX7hESfeHfPZYkEZE1vbjalor+vDWmokT7NNraAHIhqTKJ4fvu2ZDAT4epnrwwJPCefQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sHkzg3le; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sHkzg3le"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HJnNleC4WzkxgxZq72bNkPiVg6FGtPJth+krSqPAhpQ=; b=sHkzg3le2iB8nKVu9mVv16PTtF
	VPEUsvjI9jYobnzP1HJ8YJNSZ+FfrlxZ9SoSqf2iSh+0Raovo/zfQ5YzwVnfDgNzWYh88POWcTBqf
	gMVBS/G8RYbXrXfqoSinWyZ0pS+FSFeYgTID5hXBwViclQBh5CXECnCq1ppkeB2967hTcwNjDY1dq
	/klcaf2TOhZNrx6+DRxn+IfvPN4ha522NEoYuc2nWJaGeSTu8gj20Ju77IAyK2GGMU6Eb91PZcsRR
	gHpx9gxqC1c9gHFvolhcY8xDpBwVEGY/2Q2CVibPxlKn+PSA3v5BxXTqxAw3POkTFSuJuWLbkWhs8
	y9UBSgQg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZj4c-0000000GfLg-2pq1;
	Wed, 17 Jun 2026 05:44:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] xor/kunit: add a benchmark
Date: Wed, 17 Jun 2026 07:44:04 +0200
Message-ID: <20260617054416.3841334-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260617054416.3841334-1-hch@lst.de>
References: <20260617054416.3841334-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/Kconfig               |  6 ++++
 lib/raid/xor/tests/xor_kunit.c | 63 ++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/lib/raid/Kconfig b/lib/raid/Kconfig
index 5ab2b0a7be4c..034969d240c6 100644
--- a/lib/raid/Kconfig
+++ b/lib/raid/Kconfig
@@ -28,3 +28,9 @@ config XOR_KUNIT_TEST
 
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
+
+config XOR_BENCHMARK
+	bool "Benchmark for xor_gen"
+	depends on XOR_KUNIT_TEST
+	help
+	  Include benchmarks in the KUnit test suite for xor_gen.
diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kunit.c
index 659ae3edbc25..5939b78b3944 100644
--- a/lib/raid/xor/tests/xor_kunit.c
+++ b/lib/raid/xor/tests/xor_kunit.c
@@ -125,8 +125,71 @@ static void xor_test(struct kunit *test)
 	}
 }
 
+#ifdef CONFIG_XOR_BENCHMARK
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
+			t = ktime_get();
+			for (l = 0; l < num_iters; l++)
+				xor_gen(test_dest, test_buffers, nr, len);
+			t = ktime_get_ns() - t;
+			preempt_enable();
+
+			speed[j] = div_u64((u64)len * num_iters * nr, t);
+		}
+
+		static_assert(ARRAY_SIZE(len_to_test) == 2);
+		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
+				nr, speed[0], speed[1]);
+	}
+}
+#endif /* CONFIG_XOR_BENCHMARK */
+
 static struct kunit_case xor_test_cases[] = {
 	KUNIT_CASE(xor_test),
+#ifdef CONFIG_XOR_BENCHMARK
+	KUNIT_CASE(xor_benchmark),
+#endif
 	{},
 };
 
-- 
2.53.0

