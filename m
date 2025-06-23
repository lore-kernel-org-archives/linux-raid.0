Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63A219A91;
	Mon, 23 Jun 2025 08:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750668460; cv=none; b=m6a8AiHZq5p/2KhevjEoc87x0sfd0Z9ceZDVSsYwdIdjKE8qbFTMvJC3Cvt5s80i9/YoAw7VToXepl2/oktjO3OJ0KYepe5ariKHxEADlyadzVv16cJct01th7pgCVilQLQ4M8sc22PpUqa0AdwiL9bBZcUNUrNdkUc9JmOMsdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750668460; c=relaxed/simple;
	bh=hNq4rkHqQ51UkHrC9U41OXCHAhCtKb1Q3dXk8ivWjuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fv5oyuGdatxTZcht8KZyUJVLA53kVOdHCpYoWJymaBRWPksnT09QdW2/7A7mhInbBWvShqFy08rP2ClKiMNsyiWJoYU6v0OJJB17yXSU7KAzUe67hdpOpe7AvbuBEtgYkJQRrUIHtUryOsZ7M9Mzmpj3d2xyNMoGTO3PKZq0t9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lOa5Tfze; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lOa5Tfze"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EPoZSArN2kgtXJzaLg/XSoUgUso/YZ0pGXH57AfX9WI=; b=lOa5TfzeTdW3MDYbj5HP0nHBrz
	A3uhN4oapCA4E7oxD7OvXaH61r4t1VfnROg0e9Q0k/p4P1wr6PQIdOh3TJySKyKyL41gjrxKLNUFz
	SodRSxwyRlWAN1LWBMfUJPLR5l5At5SouSBlRcnxtxxpm6T6XqrHwJTKAoTx59nHQirBlbVwXvyTE
	+CErUbQDFNhmEKY+IDqvuObR6Ew6eKShkUbiKA4OYudD0r/XizQYR22DkUkPsk+dW2YTQsyouJFJB
	Y8QmOvY0KLegQcrwyIlZG3YumYdErewV2q1kNeJXCdnmXIfW4LsWtjvBOawnFa0SWIBUsqmaVUSnx
	XHROU5MA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTcaP-000F0U-0V;
	Mon, 23 Jun 2025 16:47:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 16:47:25 +0800
Date: Mon, 23 Jun 2025 16:47:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: [v3 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <aFkUnXWtxcgOTVkw@gondor.apana.org.au>
References: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
 <g7ymicehyrtnmepvpupzpds7yv3v53h3oui4sbcb5njcwsmigq@x5gtxzyw5tc6>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g7ymicehyrtnmepvpupzpds7yv3v53h3oui4sbcb5njcwsmigq@x5gtxzyw5tc6>

On Fri, Jun 20, 2025 at 06:49:51PM +0200, Klara Modin wrote:
>
> Note that an RISC-V vector syndrome implementation was added in commit
> 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
> which this patch does not change.

Thank you.  Here is a v3 that includes this:

---8<---
Use the system-wide zero page instead of a custom zero page.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 5e2b2680d7db..9e4bb7fbde25 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -119,7 +119,7 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	for (i = 0; i < disks; i++) {
 		if (blocks[i] == NULL) {
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
-			srcs[i] = (void*)raid6_empty_zero_page;
+			srcs[i] = raid6_get_zero_page();
 		} else {
 			srcs[i] = page_address(blocks[i]) + offsets[i];
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 354b8cd5537f..539ea5b378dc 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -414,7 +414,7 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = (void *) raid6_empty_zero_page;
+				ptrs[i] = raid6_get_zero_page();
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
@@ -497,7 +497,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 		async_tx_quiesce(&submit->depend_tx);
 		for (i = 0; i < disks; i++)
 			if (blocks[i] == NULL)
-				ptrs[i] = (void*)raid6_empty_zero_page;
+				ptrs[i] = raid6_get_zero_page();
 			else
 				ptrs[i] = page_address(blocks[i]) + offs[i];
 
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 72ff44cca864..2467b3be15c9 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -11,8 +11,13 @@
 #ifdef __KERNEL__
 
 #include <linux/blkdev.h>
+#include <linux/mm.h>
 
-extern const char raid6_empty_zero_page[PAGE_SIZE];
+/* This should be const but the raid6 code is too convoluted for that. */
+static inline void *raid6_get_zero_page(void)
+{
+	return page_address(ZERO_PAGE(0));
+}
 
 #else /* ! __KERNEL__ */
 /* Used for testing in user space */
@@ -191,6 +196,11 @@ static inline uint32_t raid6_jiffies(void)
 	return tv.tv_sec*1000 + tv.tv_usec/1000;
 }
 
+static inline void *raid6_get_zero_page(void)
+{
+	return raid6_empty_zero_page;
+}
+
 #endif /* ! __KERNEL__ */
 
 #endif /* LINUX_RAID_RAID6_H */
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 75ce3e134b7c..799e0e5eac26 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -18,9 +18,6 @@
 #else
 #include <linux/module.h>
 #include <linux/gfp.h>
-/* In .bss so it's zeroed */
-const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
-EXPORT_SYMBOL(raid6_empty_zero_page);
 #endif
 
 struct raid6_calls raid6_call;
diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
index a7c1b2bbe40d..b5e47c008b41 100644
--- a/lib/raid6/recov.c
+++ b/lib/raid6/recov.c
@@ -31,10 +31,10 @@ static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -72,7 +72,7 @@ static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
index 4e8095403ee2..97d598d2535c 100644
--- a/lib/raid6/recov_avx2.c
+++ b/lib/raid6/recov_avx2.c
@@ -28,10 +28,10 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -196,7 +196,7 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index 310c715db313..7986120ca444 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -37,10 +37,10 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 	 */
 
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -238,7 +238,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 	 */
 
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_loongarch_simd.c b/lib/raid6/recov_loongarch_simd.c
index 94aeac85e6f7..93dc515997a1 100644
--- a/lib/raid6/recov_loongarch_simd.c
+++ b/lib/raid6/recov_loongarch_simd.c
@@ -42,10 +42,10 @@ static void raid6_2data_recov_lsx(int disks, size_t bytes, int faila,
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -197,7 +197,7 @@ static void raid6_datap_recov_lsx(int disks, size_t bytes, int faila,
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -316,10 +316,10 @@ static void raid6_2data_recov_lasx(int disks, size_t bytes, int faila,
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -436,7 +436,7 @@ static void raid6_datap_recov_lasx(int disks, size_t bytes, int faila,
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_neon.c b/lib/raid6/recov_neon.c
index 1bfc14174d4d..70e1404c1512 100644
--- a/lib/raid6/recov_neon.c
+++ b/lib/raid6/recov_neon.c
@@ -36,10 +36,10 @@ static void raid6_2data_recov_neon(int disks, size_t bytes, int faila,
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -74,7 +74,7 @@ static void raid6_datap_recov_neon(int disks, size_t bytes, int faila,
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index f29303795ccf..5d54c4b437df 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -165,10 +165,10 @@ static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
 	 * delta p and delta q
 	 */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks - 1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_s390xc.c b/lib/raid6/recov_s390xc.c
index 179eec900cea..1d32c01261be 100644
--- a/lib/raid6/recov_s390xc.c
+++ b/lib/raid6/recov_s390xc.c
@@ -35,10 +35,10 @@ static void raid6_2data_recov_s390xc(int disks, size_t bytes, int faila,
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -82,7 +82,7 @@ static void raid6_datap_recov_s390xc(int disks, size_t bytes, int faila,
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index 4bfa3c6b60de..2e849185c32b 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -30,10 +30,10 @@ static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
 	   Use the dead data pages as temporary storage for
 	   delta p and delta q */
 	dp = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-2] = dp;
 	dq = (u8 *)ptrs[failb];
-	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[failb] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
 	/* Compute syndrome with zero for the missing data page
 	   Use the dead data page as temporary storage for delta q */
 	dq = (u8 *)ptrs[faila];
-	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[faila] = raid6_get_zero_page();
 	ptrs[disks-1] = dq;
 
 	raid6_call.gen_syndrome(disks, bytes, ptrs);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
