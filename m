Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193709;
	b=H8+0my5ijmp0rjYEwNw2uVF1eXDPhcuwjt/qFXyCtwr0d2KRg7zG0+bLvGgbIE2gjQ7l
	 UU3p/s97A8vP5JXBtujoSpiqDA3Vb7ULva8SMmmJmj4Z4YeEAeo5IqA5OedaCgUO/sFdI
	 5FBLNnCM7VtA51UJMQJeTb4l+BzJtdjbR4/gsPZtSfNzx1wDMfKoOTe0Xqig19SNXXvIA
	 b5BbCLo952HO30kI2NGZl8m1m9hZZzU254AmXr1u9owES1eAhkKzhWKe+ik241vW7LgL1
	 P5ksYpYy+Xi6nvMbuHDYxeLmzCpfUK5pVwL+ThznQLSZL5EPW7gQmQJgduHqJoJf0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193709;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Y3YZ4XZqcxssxJ/4BRJGkkKL0kCh9N5Lz7PpxuiUZaQ=;
	b=N9TwIUW6FHpFDvK4WQCjt5Rkrs2+f/k7jpDUWhaBwbZF3odeTlndh+uKCA4htABHa7v/
	 jbXiZqBbxRN9s1nW4aYqHYR52OFEuLWHVS84EvfdX5wN5BX7KVVIwfVMLNszMzqucK86F
	 27QlWoIcQWTj5VzHaZLXqaI8wY4TRUbdSDgplRU7qsQtOJoRPauluWXyw0QvQOBgQRZHj
	 jheU+ZmlntpSnWPu9mOZjXjbalmSloamCO0HI6IhscHob75Gs+mtMBb60RFpRzlXabzF8
	 eGwFo3DZfDeUlIFAJEyG6i5CQr5R+IZjoiuDGdux9CEpuV59apcO8poEuYVzlagtLpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AA8606A320
	for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2026 03:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70AA8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794193696; x=1794452896;
	bh=Y3YZ4XZqcxssxJ/4BRJGkkKL0kCh9N5Lz7PpxuiUZaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=GKCmNUHCHWlPsRyDmFodjCEp9YedEhXqBSCM3Vwb6YBA/sQcqXqw2FuA/bE2mwgHg
	 QBrOLxPEhQZ+vx+YgolS7fgfL/CqKHWE0T/yRfYvzx/uAE8Xg8ZTjbZH6KBFHjWmyg
	 PHLlg/wkxGK4QmDODuf+VtsoumXSnZaIXegt+iLxC5ghUbfbC80u+twc0+bLwUPPoU
	 cuhiA58tB9HPUBrxvHlBe6oJceUKkt/xQtdjhTwVLzfUeZ1w6veLhdxff/Dj81CCZi
	 GlHUcDhrnsWLOnfaZmKjKm+6QM0Ko3Mepqt4xaYttrz50cWBJshVqEgUaBzbLFNNUe
	 wl1V0HHzHbMBw==
X-Pm-Submission-Id: 4jNF8s2rbLz1DDXR
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome functions
Date: Mon,  9 Nov 2026 03:08:05 +0000
Message-ID: <20261109030805.25709-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
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

xor_syndrome() updates P and Q in place for a read-modify-write. md
calls it twice on the same P/Q page per write, to remove the old data
and to add the new data. The x1 and x2 unrolled versions write P and Q
with normal stores since commit a582564b24be ("md/raid6 algorithms:
xor_syndrome() for SSE2"), which argued that non-temporal stores of
less than a cache line are slow, but kept non-temporal stores in the
x4 version, as it writes whole cache lines. The AVX2 and AVX-512
versions followed the same pattern.

The non-temporal stores evict P and Q from the cache and the sfence
waits until they are written to memory, just before the second call
reads the same P and Q again, now from memory.

Use normal aligned stores in the x4 unrolled versions too, like the x1
and x2 versions and the other architectures.

md RAID-6, 4 KiB random writes, md thread on one core, Xeon E5-2699 v3:

  8+2 on null_blk (dm-raid):     85.6k -> 98.1k IOPS (+15%)
  6+2 on 8 Intel Optane M10:     57.3k -> 62.1k IOPS (+8%)

Change in time per write in md's pattern (both calls and the 4 KiB copy
between them), kernel code built in userspace, one core, geometric
mean over 2-24 data disks, data in cache / DRAM:

  avx2x4 (Xeon E5-2699 v3):  -66% / -38%
  avx512x4 (Xeon Gold 6130): -78% / -48%
  sse2x4 (Core i5-2520M):    -37% / -19%

Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Notes:
- The IOPS were measured on 2651f6deb332 (between 7.4-rc1 and -rc2) with
  and without this patch, with avx2x4 forced by a test-only change in
  raid6_choose_gen().
- The raid6 benchmark picks the implementation by gen_syndrome() speed
  alone. On Haswell-EP, AVX2 x2 and x4 differ only by noise, so either
  can be picked. With x2 picked, xor_syndrome() already uses normal
  stores, so this patch makes no difference in that case.
- The sfence at the end of the xor_syndrome() functions (x1, x2 versions
  since 2014, x4 with this patch) is no longer needed, as it no longer
  orders any non-temporal stores. Removing it made no measurable
  difference. I am happy to send a follow-up patch that removes it from
  all xor_syndrome() variants.
- Tested: raid6 KUnit on SSE2 and AVX2, AVX-512 was checked in userspace
  against a scalar reference on a Xeon Gold 6130.

 lib/raid/raid6/x86/avx2.c   | 16 ++++++++--------
 lib/raid/raid6/x86/avx512.c | 16 ++++++++--------
 lib/raid/raid6/x86/sse2.c   | 16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index 3cc2fe7ac42c..fbc1328574e1 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -435,18 +435,18 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("vpxor %ymm13,%ymm12,%ymm12");
 			asm volatile("vpxor %ymm15,%ymm14,%ymm14");
 		}
-		asm volatile("vmovntdq %%ymm2,%0" : "=m" (p[d]));
-		asm volatile("vmovntdq %%ymm3,%0" : "=m" (p[d+32]));
-		asm volatile("vmovntdq %%ymm10,%0" : "=m" (p[d+64]));
-		asm volatile("vmovntdq %%ymm11,%0" : "=m" (p[d+96]));
+		asm volatile("vmovdqa %%ymm2,%0" : "=m" (p[d]));
+		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d+32]));
+		asm volatile("vmovdqa %%ymm10,%0" : "=m" (p[d+64]));
+		asm volatile("vmovdqa %%ymm11,%0" : "=m" (p[d+96]));
 		asm volatile("vpxor %0,%%ymm4,%%ymm4" : : "m" (q[d]));
 		asm volatile("vpxor %0,%%ymm6,%%ymm6" : : "m" (q[d+32]));
 		asm volatile("vpxor %0,%%ymm12,%%ymm12" : : "m" (q[d+64]));
 		asm volatile("vpxor %0,%%ymm14,%%ymm14" : : "m" (q[d+96]));
-		asm volatile("vmovntdq %%ymm4,%0" : "=m" (q[d]));
-		asm volatile("vmovntdq %%ymm6,%0" : "=m" (q[d+32]));
-		asm volatile("vmovntdq %%ymm12,%0" : "=m" (q[d+64]));
-		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
+		asm volatile("vmovdqa %%ymm4,%0" : "=m" (q[d]));
+		asm volatile("vmovdqa %%ymm6,%0" : "=m" (q[d+32]));
+		asm volatile("vmovdqa %%ymm12,%0" : "=m" (q[d+64]));
+		asm volatile("vmovdqa %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 772bfc4af6df..520094efbb71 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -516,18 +516,18 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 				     :
 				     : );
 		}
-		asm volatile("vmovntdq %%zmm2,%0\n\t"
-			     "vmovntdq %%zmm3,%1\n\t"
-			     "vmovntdq %%zmm10,%2\n\t"
-			     "vmovntdq %%zmm11,%3\n\t"
+		asm volatile("vmovdqa64 %%zmm2,%0\n\t"
+			     "vmovdqa64 %%zmm3,%1\n\t"
+			     "vmovdqa64 %%zmm10,%2\n\t"
+			     "vmovdqa64 %%zmm11,%3\n\t"
 			     "vpxorq %4,%%zmm4,%%zmm4\n\t"
 			     "vpxorq %5,%%zmm6,%%zmm6\n\t"
 			     "vpxorq %6,%%zmm12,%%zmm12\n\t"
 			     "vpxorq %7,%%zmm14,%%zmm14\n\t"
-			     "vmovntdq %%zmm4,%4\n\t"
-			     "vmovntdq %%zmm6,%5\n\t"
-			     "vmovntdq %%zmm12,%6\n\t"
-			     "vmovntdq %%zmm14,%7"
+			     "vmovdqa64 %%zmm4,%4\n\t"
+			     "vmovdqa64 %%zmm6,%5\n\t"
+			     "vmovdqa64 %%zmm12,%6\n\t"
+			     "vmovdqa64 %%zmm14,%7"
 			     :
 			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
 			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index 43b09ce58270..da8374e506b6 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -432,18 +432,18 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 			asm volatile("pxor %xmm13,%xmm12");
 			asm volatile("pxor %xmm15,%xmm14");
 		}
-		asm volatile("movntdq %%xmm2,%0" : "=m" (p[d]));
-		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d+16]));
-		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d+32]));
-		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d+48]));
+		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
+		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
+		asm volatile("movdqa %%xmm10,%0" : "=m" (p[d+32]));
+		asm volatile("movdqa %%xmm11,%0" : "=m" (p[d+48]));
 		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
 		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
 		asm volatile("pxor %0,%%xmm12" : : "m" (q[d+32]));
 		asm volatile("pxor %0,%%xmm14" : : "m" (q[d+48]));
-		asm volatile("movntdq %%xmm4,%0" : "=m" (q[d]));
-		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d+16]));
-		asm volatile("movntdq %%xmm12,%0" : "=m" (q[d+32]));
-		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d+48]));
+		asm volatile("movdqa %%xmm4,%0" : "=m" (q[d]));
+		asm volatile("movdqa %%xmm6,%0" : "=m" (q[d+16]));
+		asm volatile("movdqa %%xmm12,%0" : "=m" (q[d+32]));
+		asm volatile("movdqa %%xmm14,%0" : "=m" (q[d+48]));
 	}
 	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.53.0

