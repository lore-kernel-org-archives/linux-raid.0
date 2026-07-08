Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60A3F823C;
	Wed,  8 Jul 2026 09:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501602; cv=none; b=MGJXqYVh1bV6alFxvarQZA5c2phiz+q8wJ12VgRQEV+in7Ke19wyNxm9B14f/cDPUX/fqqxajoO5oVuyPrGQV8oznF9/1yuGf9pSwOMOx+6gxTwWaHDfiJvntufnA+ahbJDxWWlvtL0h09Yh4EFykeiuCagdW1L70LNCyYflnKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501602; c=relaxed/simple;
	bh=NmIqwbSwTpB5DAYZsyHpyJq6B5woSevVMVnLWHQQYE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhL0cJmHjR9liZwA8LJCKiwxrRBwIdVlGAK0w6w7DJKCFMN2pm/5DNz8YxmY0q3sRbf60ph1769dlXBuE03yquuw3B8xQWUUax+helHmcvYNtI4sg5sr2XcOGtaJfMUHzAwXvJG+yoFcaXQhkxI/yx/ZAlM+2lZ58HMqZBDvGaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qq8qqhhe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qq8qqhhe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x1zj+g8oFCvReKwlDRL92FlooeEtsGPAF0K/QyY6e18=; b=Qq8qqhheAJI4fcRdFaTMT6oQ9c
	l8K6QnvNqUDFBD4w+IHVnzu3EywhbEMp/3j3EwsozyAilkgTYGJ7yjteuG7fSTnUYp0w0zPBZ3yab
	9hI4y4bAkFKERZC8HH6GXpnOZRuySVBJKHcKiXT+I2LtkjEAm1Z5suTsFc5aMD0Ui6QYSR1STxY37
	O0cvoGF6G3EhXoDt0n2NL7SCs9dRp+jjNTbhwAeblLCyQ9KEsRDlM+W4P0N902W2WVvbwTiFOsC8N
	G7NzU5ccFQhMnrtr3n82dwXJt0SrReRi6u/f0fAa13HM67xsX6nTh5BH52NJlODTbdzgbO1Bjyb2F
	F0nvzxQg==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOEp-0000000Ghwf-2fWk;
	Wed, 08 Jul 2026 09:06:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] xor: improve the runtime selection benchmark
Date: Wed,  8 Jul 2026 11:05:16 +0200
Message-ID: <20260708090614.1431014-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708090614.1431014-1-hch@lst.de>
References: <20260708090614.1431014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use plain ktime_get_ns for the timing, use 4 + 1 disks for a realistic
load, and report the throughput on the data disks instead of the that
on the parity disk, which isn't all that useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/xor/xor-core.c | 55 +++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index 50931fbf0324..a890cec21bbc 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -10,7 +10,6 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/raid/xor.h>
-#include <linux/jiffies.h>
 #include <linux/preempt.h>
 #include <linux/static_call.h>
 #include "xor_impl.h"
@@ -73,59 +72,56 @@ void __init xor_force(struct xor_block_template *tmpl)
 	forced_template = tmpl;
 }
 
-#define BENCH_SIZE	4096
+#define BENCH_SIZE	SZ_4K
+#define NR_SRCS		4
 #define REPS		800U
 
-static void __init
-do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
+static void __init do_xor_speed(struct xor_block_template *tmpl, void *dest,
+		void *srcs[NR_SRCS])
 {
-	int speed;
-	unsigned long reps;
-	ktime_t min, start, t0;
-	void *srcs[1] = { b2 };
+	u64 t;
+	int i;
 
 	preempt_disable();
-
-	reps = 0;
-	t0 = ktime_get();
-	/* delay start until time has advanced */
-	while ((start = ktime_get()) == t0)
-		cpu_relax();
-	do {
+	t = ktime_get_ns();
+	for (i = 0; i < REPS; i++) {
 		mb(); /* prevent loop optimization */
-		tmpl->xor_gen(b1, srcs, 1, BENCH_SIZE);
+		tmpl->xor_gen(dest, srcs, NR_SRCS, BENCH_SIZE);
 		mb();
-	} while (reps++ < REPS || (t0 = ktime_get()) == start);
-	min = ktime_sub(t0, start);
-
+	}
+	t = ktime_get_ns() - t;
 	preempt_enable();
 
-	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
-	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
-	tmpl->speed = speed;
+	/* bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s] */
+	tmpl->speed = div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);
 
-	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
+	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, tmpl->speed);
 }
 
 static int __init calibrate_xor_blocks(void)
 {
-	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
+	void *srcs[NR_SRCS];
+	void *buf, *dest;
+	int i;
 
 	if (forced_template)
 		return 0;
 
-	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
-	if (!b1) {
+	buf = kmalloc(BENCH_SIZE * (NR_SRCS + 1), GFP_KERNEL);
+	if (!buf) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
-	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+	get_random_bytes(buf, BENCH_SIZE * (NR_SRCS + 1));
+	dest = buf;
+	for (i = 0; i < NR_SRCS; i++)
+		srcs[i] = buf + (i + 1) * BENCH_SIZE;
 
 	pr_info("xor: measuring software checksum speed\n");
 	fastest = template_list;
 	for (f = template_list; f; f = f->next) {
-		do_xor_speed(f, b1, b2);
+		do_xor_speed(f, dest, srcs);
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}
@@ -133,9 +129,10 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	kfree(b1);
+	kfree(buf);
 	return 0;
 }
+#undef NR_SRCS
 
 #ifdef CONFIG_XOR_BLOCKS_ARCH
 #include "xor_arch.h" /* $SRCARCH/xor_arch.h */
-- 
2.53.0

