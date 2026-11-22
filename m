Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318190;
	b=oUZ+S90eNtaGKIxDrohHWdNlrzFSEdyaRTJu8w+3mXsguG3Ytl3ezidoZL8le3pYmmiA
	 WrE8Y/enJr4KTHArCyUXXVDuF+rMm54/qe+57DjXu6vFAHTmPx2kSp4A40RVYYPdwqoHd
	 QJckyv9LI8zxdO62AtBMKo5AabsvdkWFVXYPHzI3NTJmdjAdZ0k+f0swgut8/l0Glc60f
	 PUbQ074/psTs4JwwoHAfv/IJuDzmEBEFmZORc9M33QHrPIXu8mRT/m4lWDNNIgga1JnNC
	 38W6wbLQmI3PpR374MwrJa/ICU8PdUBp3GzThSDXq0mBxWT/PqIMqJd1I5gvQwSKrYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318190;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+gvvGKiXnM6uaroJfNk8CnYzm/dXCNho3UzC5dDTiU4=;
	b=FICictLPFfWzI8ubw5rHBy+QN+1vyQJ+qcdzWGLLd5RoWKLardHWJd7XnsqPwowRzvmU
	 enIPraBw1m3vP66ltkoA8F8+q6kFMI2uaeGCzZpfFx3Tg4fnrO0RXjk8KPsmA2U8TnQGs
	 1vMr8jh12JwzHgqg9kSFeqk6dFNAPvPBLD+P6vroWdWkrhxCxsB0YUrE4i0KocV1tpnec
	 efzkywifzv5QPk4DyR9B+XTFwqcEX/LglF1OwOSCvHhTMz6uLYxDe3R3yQyuTP4nHJOfw
	 qML2NmH/t3tNoyCOSodam0IBBqy8XxTrE39aHbgJ2Q6MeinYoJolmSjAmfkp4HeAYiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=t48ShEHf;
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C628606A696
	for <linux-raid@vger.kernel.org>; Sun, 22 Nov 2026 03:29:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C628606A696
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=t48ShEHf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795318187; x=1795577387;
	bh=+gvvGKiXnM6uaroJfNk8CnYzm/dXCNho3UzC5dDTiU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=t48ShEHf+3/ljZDRqT4q2pYCgCmFl/PFhHKNIGPxvDj2kArMeZS9MnIH6p8LU+R0/
	 uwy44bBEFTdx7mrG7xWQtZf/3JcQ6M0CyUjlFtswgZ9DN/vLddRI+B2qaDPl30yq19
	 MwNrJEebsfE8Bzudrk6bN1Gl8QIO765lkDsY6+AXacG2/m2AKtIO5MEvUxBnuucGI5
	 qzgsC5EflXh1KGZKAY1xm17WSTPJuvPR6JWJ4zC5j9U9qJ3/At2r4fb0RA7VyupiyX
	 QrtZQwB18o2+voDvINC8o1QI46VLnqQuMOa4bNbrymlOzz2IBcSVDpFkrgpfsLo3JO
	 1a1ANTxHV+Gag==
X-Pm-Submission-Id: 4jXF1k0spSz1DDrS
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] raid6: prefetch Q with prefetcht0 in the x86 x4 xor_syndrome functions
Date: Sun, 22 Nov 2026 03:29:33 +0000
Message-ID: <20261122032933.2306875-4-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122032933.2306875-1-mc@raidlab.org>
References: <20261122032933.2306875-1-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x4 xor_syndrome() functions for SSE2, AVX2 and AVX-512 prefetch Q
with prefetchnta. That hint is meant for data that is used once. Q is
read, updated and written back with normal stores, and md calls
xor_syndrome() twice on the same P/Q page for each write.

Prefetch Q with prefetcht0, which keeps it in all cache levels. The data
blocks are read once and keep prefetchnta.

Time per write measured in a userspace harness in md's read-modify-write
pattern (two xor_syndrome() calls on the same P/Q page), avx512x4 on a
Xeon Gold 6130, 2-24 data disks, write to the first, middle and last
data disk, median of 10 passes:

  P and Q in DRAM:      -2.2% (geometric mean), up to -5.7%
  P and Q in L3:        +0.2%
  P and Q in L1/L2:     +0.3%

The gain comes with 2-8 data disks, where Q is a larger part of the
work. The SSE2 and AVX2 versions were not measured.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 lib/raid/raid6/x86/avx2.c   | 4 ++--
 lib/raid/raid6/x86/avx512.c | 4 ++--
 lib/raid/raid6/x86/sse2.c   | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index d3f488a9c1a5..5a49079ace68 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -408,8 +408,8 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 		}
-		asm volatile("prefetchnta %0" :: "m" (q[d]));
-		asm volatile("prefetchnta %0" :: "m" (q[d+64]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d+64]));
 		/* P/Q left side optimization */
 		for (z = start-1 ; z >= 0 ; z--) {
 			asm volatile("vpxor %ymm5,%ymm5,%ymm5");
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 33d7639da5b3..38077109ab0f 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -476,8 +476,8 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 				       "m" (dptr[z][d+128]),
 				       "m" (dptr[z][d+192]));
 		}
-		asm volatile("prefetchnta %0\n\t"
-			     "prefetchnta %1\n\t"
+		asm volatile("prefetcht0 %0\n\t"
+			     "prefetcht0 %1\n\t"
 			     :
 			     : "m" (q[d]), "m" (q[d+128]));
 		/* P/Q left side optimization */
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index a0709916289c..c27a4c8254ba 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -405,8 +405,8 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 		}
-		asm volatile("prefetchnta %0" :: "m" (q[d]));
-		asm volatile("prefetchnta %0" :: "m" (q[d+32]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d]));
+		asm volatile("prefetcht0 %0" :: "m" (q[d+32]));
 		/* P/Q left side optimization */
 		for ( z = start-1 ; z >= 0 ; z-- ) {
 			asm volatile("pxor %xmm5,%xmm5");
-- 
2.53.0

