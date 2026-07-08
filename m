Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB617409632;
	Wed,  8 Jul 2026 09:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501698; cv=none; b=HW6PcJv4jTTuUxyFl9mifneWk4hZAhsXKs7OAL4zhb0RD9ZBl4Wz7wwJFzIQnTsNbCBRA2QPqfNxGB+kQYlVqYgDtDyUULOam1ixG9VSi49UMBwoIZTnfmI14GuXt/CPJ/I/0Ud+BCFFaxm2HzNYt7lo3EJb14Xk8p+w9wL3yYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501698; c=relaxed/simple;
	bh=h6yQFL7tQrFurxLBEdp4Vhtf9ZjVOnD+Mgm1j1UjBjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrCOh3sRPZi6/VUYOATS56qzJx03FGC1vUfG1NeTVyjQXqyN1hG0oTakMu7/7FGAEMu7usycCVtzzTi2x3bVHNrfIHCRVKIiebNMSW4Azau1rLLDO6N3QYrXD4nav8NP9bHlMPU5cVPCsLerxYXSsyZtLF4Nwxda049VEiWUstI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=utg3Aeni; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="utg3Aeni"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MZOGgGcuTAvwQiL1KSDktMMtEUmrXhEx3ZcdviMnCvU=; b=utg3AeniF052svjtU3qD04MIcz
	VQtvNPyvX6QGsb/L3z3FPkiw/U8ejkjfue5yk/77jBpdcH9CbMOxOM7t3qTD63zgyi1rUnqIN19Ok
	Tn1GSaAj6Iguy44wR8ZVekK9zp4QtLhdQui2sIdEJ/4JssocPSM6bH0PIoyWwp8nhWlbY7zUxw7VL
	BWGRIi4Irm3eyoXdsR74PhLeNWa6m7KwOUYXZWRfYNlPLgHs5D/hyPFQ8bZjROv6QtW1E5zj/KYeY
	mY8OjPfc0pn8u5eTk19kDt85qVzdrAL/m3pmtnyVLgydMDxRxMFM90HC+t4MFUjpFqTqc256Co3Aw
	8XeE3QgQ==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOGO-0000000GiAN-0A4q;
	Wed, 08 Jul 2026 09:08:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] raid6: improve the runtime selection benchmark
Date: Wed,  8 Jul 2026 11:07:36 +0200
Message-ID: <20260708090740.1433685-8-hch@lst.de>
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

Use plain ktime_get_ns for the timing, use 8 + 2 disks for a realistic
load, and report the throughput on the data disks as that is what
storage systems are measured on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/algos.c | 75 +++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index e7984bde5157..c44b986e319e 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -152,40 +152,39 @@ void raid6_recov_datap(int disks, size_t bytes, int faila, void **ptrs)
 }
 EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
-#define RAID6_TIME_JIFFIES_LG2	4
-#define RAID6_TEST_DISKS	8
+#define BENCH_SIZE	SZ_4K
+#define NR_SRCS		8
+#define NR_DISKS	(NR_SRCS + 2)
+#define REPS		800U
 
-static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
-		const int disks)
+static int raid6_choose_gen(void *dptrs[NR_DISKS], const int disks)
 {
 	/* work on the second half of the disks */
-	int start = (disks >> 1) - 1, stop = disks - 3;
+	int start = (disks / 2) - 1, stop = disks - 3;
 	const struct raid6_calls *best = NULL;
 	unsigned long bestgenperf = 0;
 	unsigned int i;
 
 	for (i = 0; i < raid6_nr_algos; i++) {
 		const struct raid6_calls *algo = raid6_algos[i];
-		unsigned long perf = 0, j0, j1;
+		unsigned long perf = 0;
+		u64 t;
+		int i;
 
 		preempt_disable();
-		j0 = jiffies;
-		while ((j1 = jiffies) == j0)
-			cpu_relax();
-		while (time_before(jiffies,
-				    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
-			algo->gen_syndrome(disks, PAGE_SIZE, *dptrs);
-			perf++;
-		}
+		t = ktime_get_ns();
+		for (i = 0; i < REPS; i++)
+			algo->gen_syndrome(disks, BENCH_SIZE, dptrs);
+		t = ktime_get_ns() - t;
 		preempt_enable();
 
+		/* bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s] */
+		perf = div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t);
 		if (perf > bestgenperf) {
 			bestgenperf = perf;
 			best = algo;
 		}
-		pr_info("raid6: %-8s gen() %5ld MB/s\n", algo->name,
-			(perf * HZ * (disks-2)) >>
-			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		pr_info("raid6: %-8s gen() %5lu MB/s\n", algo->name, perf);
 	}
 
 	if (!best) {
@@ -197,28 +196,22 @@ static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
 	static_call_update(raid6_xor_syndrome_impl, best->xor_syndrome);
 
 	pr_info("raid6: using algorithm %s gen() %ld MB/s\n",
-		best->name,
-		(bestgenperf * HZ * (disks - 2)) >>
-		(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2));
+		best->name, bestgenperf);
 
 	if (best->xor_syndrome) {
-		unsigned long perf = 0, j0, j1;
+		u64 t;
+		int i;
 
 		preempt_disable();
-		j0 = jiffies;
-		while ((j1 = jiffies) == j0)
-			cpu_relax();
-		while (time_before(jiffies,
-				   j1 + (1 << RAID6_TIME_JIFFIES_LG2))) {
-			best->xor_syndrome(disks, start, stop,
-					   PAGE_SIZE, *dptrs);
-			perf++;
-		}
+		t = ktime_get_ns();
+		for (i = 0; i < REPS; i++)
+			best->xor_syndrome(disks, start, stop, BENCH_SIZE,
+				dptrs);
+		t = ktime_get_ns() - t;
 		preempt_enable();
 
-		pr_info("raid6: .... xor() %ld MB/s, rmw enabled\n",
-			(perf * HZ * (disks - 2)) >>
-			(20 - PAGE_SHIFT + RAID6_TIME_JIFFIES_LG2 + 1));
+		pr_info("raid6: .... xor() %llu MB/s, rmw enabled\n",
+			div64_u64((u64)BENCH_SIZE * REPS * NR_SRCS * 1000, t));
 	}
 
 	return 0;
@@ -230,14 +223,14 @@ static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
 
 static int __init raid6_select_algo(void)
 {
-	const int disks = RAID6_TEST_DISKS;
+	const int disks = NR_DISKS;
+	void *dptrs[NR_DISKS];
 	char *disk_ptr, *p;
-	void *dptrs[RAID6_TEST_DISKS];
 	int i, cycle;
 	int error;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
+	disk_ptr = kmalloc_array(NR_DISKS, BENCH_SIZE, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -245,19 +238,19 @@ static int __init raid6_select_algo(void)
 
 	p = disk_ptr;
 	for (i = 0; i < disks; i++)
-		dptrs[i] = p + PAGE_SIZE * i;
+		dptrs[i] = p + BENCH_SIZE * i;
 
-	cycle = ((disks - 2) * PAGE_SIZE) / 65536;
+	cycle = ((disks - 2) * BENCH_SIZE) / 65536;
 	for (i = 0; i < cycle; i++) {
 		memcpy(p, raid6_gfmul, 65536);
 		p += 65536;
 	}
 
-	if ((disks - 2) * PAGE_SIZE % 65536)
-		memcpy(p, raid6_gfmul, (disks - 2) * PAGE_SIZE % 65536);
+	if ((disks - 2) * BENCH_SIZE % 65536)
+		memcpy(p, raid6_gfmul, (disks - 2) * BENCH_SIZE % 65536);
 
 	/* select raid gen_syndrome function */
-	error = raid6_choose_gen(&dptrs, disks);
+	error = raid6_choose_gen(dptrs, disks);
 
 	kfree(disk_ptr);
 
-- 
2.53.0

