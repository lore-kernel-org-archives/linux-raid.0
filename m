Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AC821B9E2;
	Mon, 17 Mar 2025 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742202161; cv=none; b=lHcOH/bNUO8+9U9vy4ve+S/Xl63vh7sBWx46ZJRd7RGNMeEZ0xIaDoRxXM91Wlgv0JHIxoRexb2McvbS4EKtEsmnN+BPMyhD8aZInIwtsJIBlzgNQGELAIkn4TzryqlrDm5WJCIY95C3VjmOzMWlxX1TB2MsmUY/2puCqoXNCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742202161; c=relaxed/simple;
	bh=SwpGFi8IOFbqLpsi6T9dluj+NHf7wKla/Trxz5udWnM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QH5oekffgyZQWDza2bEljefcEn9TGzEQc5D2n3sjBLiMXc4Y7FfywBR9h+18WoOKvBxNzFqnZ9f/NbT3gjj18IFLKJRf6r7nF/bC3jTSc8oVx7LN5gwh+QAxE3TgY+dKyhNGXIxSKSh1Vr74V1B/dSbh6/iGdI8v9/Nu3s9yKvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dkYQJuk1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dkYQJuk1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OEpIMyI5pPLiyjU8Li2P5nUN2p1ZSWijQa6tGF2W0SE=; b=dkYQJuk1jsXCoAl/sWPCV7ntYw
	cdKn0BngzF/Aq1qylGfXk4rit5XmINTAUtgJz5hYB6szw5tNvRC9Ss+7r9Z9n1EHENZnoajvGSQ8X
	cpWU+9bVN9cEpG2F9/rHaiZqlDpYZE6nSJAbmFMWZ6Z5Yd691D0T/oV5EA3PkkvP24oey0xv4vPPL
	ZoMmr+VnFeem/nCC5du3JKXhdpRVH+9NXpi/60s55jl564QLYM4ewruerchD/ajThsrt5apFwIG/S
	sdG9Hb3g1NxhYfK7JcuMxnn6tHmwPqHR+q5etzDIpiwFCc5RmM7dxNEwM1EdrZrfck3aJSqeseEQk
	/8QYiKFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu6Me-007Uro-0Z;
	Mon, 17 Mar 2025 17:02:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 17:02:28 +0800
Date: Mon, 17 Mar 2025 17:02:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: [v2 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

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
index 98030accf641..428ca76e4deb 100644
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
@@ -186,6 +191,11 @@ static inline uint32_t raid6_jiffies(void)
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
index cd2e88ee1f14..03f1a8c179f7 100644
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
index fd9e15bf3f30..d3752491842a 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -39,10 +39,10 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
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
@@ -240,7 +240,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
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
