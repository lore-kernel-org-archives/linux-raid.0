Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318188;
	b=dpTnMpB5CNB16fi/JMWwo1OY92wVJevzzLt41iZQ13gVYVnp9nkbjsLclU8TzISoSKPa
	 FMcKsoLbciqRYjHKv/vgr8V4OGZGfnmlPIWlPM4053hqMYnEK2b06Uspc+UvxKHckSsUS
	 cObc32n199vfn5WJtQkZhqXALszVdj3Z/SwsJLO8AN7Q2P1xvrhP/PEDzR8XLL9pHDEvi
	 v/s34Epha2vLSmoy39B+dVow/epUMwWVZFEQN6YsnsupwfU1KZXI/S8SxYFI1nWwqZJXd
	 5QtO58AXryMLdFB6pmaeVOFhCHpPDjX5SFbYcqYlocvDbet4VqG/8mKivo/N9V4/l5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318188;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rvSal6C0xEQvqWsaNU17OQWrbwoZB9kWfIy4zR9hEIs=;
	b=E30UkULZjvPa64YUw3tHJoAwRpE8ghuXYIgZEyHKZ+RCn2eE+bVmxlUf7rPtOTzLyCrN
	 SzJf1D+waBaMU3oKpmRRBCqkTYwXeVSEZnwphTP0FgcaJm78uWEisJ91wMlwEjaqub1Ic
	 bTiW6ZtX3JP892Y1TYSwztmvG6vOZA4CAKH+yCDDMymQxqDZgb/3UNdXxJd03fDLQZMNf
	 iknjaHA5MEastvK6b8kXVuoYTRJOZx08A+oQXGsHgcjzX1oZpVjHsiWDWrCl+3ZiNTssE
	 w/mLgpStgsGVTMje3OdE8+wZTtTsrSzwa+yDhCz2mPXEfEWGF30BPzWhHbZgRoq+N4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Z2mhT5B8;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC54606A683
	for <linux-raid@vger.kernel.org>; Sun, 22 Nov 2026 03:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AC54606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Z2mhT5B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795318186; x=1795577386;
	bh=rvSal6C0xEQvqWsaNU17OQWrbwoZB9kWfIy4zR9hEIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Z2mhT5B8+c6HOOs3lCpBRfkIpmvRB5H9PFzHKNbf2pwKEkVr4h0lFLpnS1jHuHGv+
	 ySZ2DSVvqeP0Pb0HfmFrdFXhmQpj65M+hwQx9e5iV6Ov/ppo8e3NCwvjpw80ts190L
	 k/toBb24RUcskY0mYfzrxnRCkyKJJS28YuYJDxlzGM++Ae8pZg1bkOqXxLX8y4tc0w
	 qJV3t5vsOkUceKBmTeZUTTpUeht+rp2D3pzBWxPdxg07HTtuEetEUl1sFFNl7AESOd
	 TvQrP82xKf2+qGbp8Yo5Fzv5BNJAVDrXN69jmMR1FYRtOo9o4m54DVJ6zst2dgY5h0
	 NSAIZvz1Neemw==
X-Pm-Submission-Id: 4jXF1f0bQzz1DDXX
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
Subject: [PATCH 1/3] raid6: declare the AVX-512 P/Q stores as asm outputs
Date: Sun, 22 Nov 2026 03:29:31 +0000
Message-ID: <20261122032933.2306875-2-mc@raidlab.org>
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

The AVX-512 gen_syndrome() and xor_syndrome() functions store P and Q in
inline asm that lists these memory operands as inputs only. The compiler
may then assume that the asm does not change P and Q. Each function ends
with an sfence whose asm has a "memory" clobber, and the constraints
technically rely on it.

Declare the stored P and Q as outputs: "=m" where the asm only writes
them, and "+m" for Q in xor_syndrome(), which the same asm reads and
writes back. The SSE2 and AVX2 functions already declare their stores as
outputs.

With clang the generated code does not change: it already loads the data
pointers from ptrs[] inside the loop over the block. gcc 15.2 now does
the same, because a byte store may alias the pointer array. Five of the
six functions get one or two more instructions.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 lib/raid/raid6/x86/avx512.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index dac0edb9189e..7dc0a45cd2fb 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -73,8 +73,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vpxorq %%zmm2,%%zmm2,%%zmm2\n\t"
 			     "vmovntdq %%zmm4,%1\n\t"
 			     "vpxorq %%zmm4,%%zmm4,%%zmm4"
-			     :
-			     : "m" (p[d]), "m" (q[d]));
+			     : "=m" (p[d]), "=m" (q[d]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -133,8 +132,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 		/* Don't use movntdq for r/w memory area < cache line */
 			     "vmovdqa64 %%zmm4,%0\n\t"
 			     "vmovdqa64 %%zmm2,%1"
-			     :
-			     : "m" (q[d]), "m" (p[d]));
+			     : "+m" (q[d]), "=m" (p[d]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -204,9 +202,8 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vmovntdq %%zmm3,%1\n\t"
 			     "vmovntdq %%zmm4,%2\n\t"
 			     "vmovntdq %%zmm6,%3"
-			     :
-			     : "m" (p[d]), "m" (p[d+64]), "m" (q[d]),
-			       "m" (q[d+64]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (q[d]),
+			       "=m" (q[d+64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -289,9 +286,8 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 			     "vmovdqa64 %%zmm6,%1\n\t"
 			     "vmovdqa64 %%zmm2,%2\n\t"
 			     "vmovdqa64 %%zmm3,%3"
-			     :
-			     : "m" (q[d]), "m" (q[d+64]), "m" (p[d]),
-			       "m" (p[d+64]));
+			     : "+m" (q[d]), "+m" (q[d+64]), "=m" (p[d]),
+			       "=m" (p[d+64]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -393,10 +389,9 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 			     "vpxorq %%zmm12,%%zmm12,%%zmm12\n\t"
 			     "vmovntdq %%zmm14,%7\n\t"
 			     "vpxorq %%zmm14,%%zmm14,%%zmm14"
-			     :
-			     : "m" (p[d]), "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]), "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (p[d+128]),
+			       "=m" (p[d+192]), "=m" (q[d]), "=m" (q[d+64]),
+			       "=m" (q[d+128]), "=m" (q[d+192]));
 	}
 
 	asm volatile("sfence" : : : "memory");
@@ -528,10 +523,9 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			     "vmovdqa64 %%zmm6,%5\n\t"
 			     "vmovdqa64 %%zmm12,%6\n\t"
 			     "vmovdqa64 %%zmm14,%7"
-			     :
-			     : "m" (p[d]),  "m" (p[d+64]), "m" (p[d+128]),
-			       "m" (p[d+192]), "m" (q[d]),  "m" (q[d+64]),
-			       "m" (q[d+128]), "m" (q[d+192]));
+			     : "=m" (p[d]), "=m" (p[d+64]), "=m" (p[d+128]),
+			       "=m" (p[d+192]), "+m" (q[d]), "+m" (q[d+64]),
+			       "+m" (q[d+128]), "+m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
-- 
2.53.0

