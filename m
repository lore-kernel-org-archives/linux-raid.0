Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318188;
	b=YdunML0d8gr0AVe5C14GPf/CAS0wrR1kRwWBIwrqQTmMnjmoGACDmONuIHpaNLktNyEC
	 TDQst2+IeviY7kJSgckOoAq3+VFuOzqdlIlpVV5lUZGm1Xa5HfLktaigPbkXYzWFvyUL9
	 KS4SUkXFa0kyIg4gqF1htw5ERIr4JkEh46bfo68/KgcBggmWj+yNSOmIgTPAakRAOw1eO
	 T/Z4Uab4MtnNmhVubKbhRGGupP7uLhwjtPXlozqHTEA3hhqx3Ee3CB200gb18QGeFgPQl
	 4VdKTuxMHkr3sfgc4ba0FgxvN2XcNQ/0OkBzGEZiqbuzr7CvtUDNrb+GlLJ6v644o6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318188;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p3nqFkme7mg7H/fs+lYWoZopxp7iNJH2hxKNl8bsNRw=;
	b=cCF3l1Mk3AqZtCe9J3x0oFEK5AH+spOZoGF06kbtz6kAidM9pDjQX/yPttJtC2fnOn67
	 7/JVf1UfGDP0LCjmmOh709AS4O/Dz1UxQyifezHTE+ukUjrUPFfTkSBBBKqB03avdXHFP
	 OGD0oGqG+gVmd9Vb/OlQ6xvAyzVu02OHPBT5iiGb1bbITBr1SV6i/poo4jSjDHS88xFKC
	 Fb5pmpXMaSxZtRKzdNG0Vuu3ayRCCaW3/uqqmNCvI+TBD4uhG4OUGW4ETpvync9ryUm19
	 hMjrDxExvooqpxZEQN2di7Pi6YQVYCP6YRwH43ZTuA5Sa5YMuNv/RfuzZ4hqRd1jaPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=dyzICezC;
	arc=none smtp.remote-ip=185.70.43.172
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36179606A680;
	Sun, 22 Nov 2026 03:29:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36179606A680
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=dyzICezC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795318186; x=1795577386;
	bh=p3nqFkme7mg7H/fs+lYWoZopxp7iNJH2hxKNl8bsNRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=dyzICezCY9q2jMs2tJclU8lxNYEQDOcniniqe35bTIiW/D/Kz4oit/hiQT3uK3LYS
	 0Uj8H5mbWFoHXzXxXwxqBBOYTdnMhr2w+6W2jk7QA20M+QN1Glpw6tCQheICUoLMrQ
	 73cNZ73nf2gxaozcUTqWuccNINCvfdxrRHupSrmsQEn4a7/34fpUM6vHoJ16fQKsOT
	 C04I9U4MIF6zer+VZ+B185yHs6p3MWorRZg8B/ECSw0/4UhQ1+o3VYfdk7mBA4ErdD
	 hCjZ1ObuNNDvMfgcZz6asSSTlKL2QvygXblMkCKOw71z31IZfZiXThcy/V7LHc/NBK
	 U0ZhiGpadmfmQ==
X-Pm-Submission-Id: 4jXF1h447Rz1DDqy
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
Subject: [PATCH 2/3] raid6: remove the sfence from the x86 xor_syndrome functions
Date: Sun, 22 Nov 2026 03:29:32 +0000
Message-ID: <20261122032933.2306875-3-mc@raidlab.org>
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

The SSE2, AVX2 and AVX-512 xor_syndrome() functions end with an sfence.
It orders non-temporal stores, but none of these functions uses them
anymore. The x4 versions stopped with "raid6: use normal stores in the
x86 x4 xor_syndrome functions", and the x1 and x2 versions never used
them.

Remove the sfence from all nine functions. The gen_syndrome() functions
still write P and Q with non-temporal stores and keep their sfence.

The asm of the AVX-512 functions relied on the "memory" clobber of the
sfence. "raid6: declare the AVX-512 P/Q stores as asm outputs" declares
their stores as outputs instead.

The memory operands are still declared as single bytes while the asm
accesses 16 to 64 bytes. This is unchanged. No C code in these functions
accesses the buffers.

Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-raid/avqegZd_W0kce0UA@infradead.org/
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 lib/raid/raid6/x86/avx2.c   | 3 ---
 lib/raid/raid6/x86/avx512.c | 3 ---
 lib/raid/raid6/x86/sse2.c   | 3 ---
 3 files changed, 9 deletions(-)

diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index a9e709ce2104..d3f488a9c1a5 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -115,7 +115,6 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 		asm volatile("vmovdqa %%ymm2,%0" : "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -245,7 +244,6 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 		asm volatile("vmovdqa %%ymm3,%0" : "=m" (p[d+32]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -448,7 +446,6 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 		asm volatile("vmovdqa %%ymm12,%0" : "=m" (q[d+64]));
 		asm volatile("vmovdqa %%ymm14,%0" : "=m" (q[d+96]));
 	}
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index 7dc0a45cd2fb..33d7639da5b3 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -135,7 +135,6 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 			     : "+m" (q[d]), "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -290,7 +289,6 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 			       "=m" (p[d+64]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
@@ -527,7 +525,6 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "=m" (p[d+192]), "+m" (q[d]), "+m" (q[d+64]),
 			       "+m" (q[d+128]), "+m" (q[d+192]));
 	}
-	asm volatile("sfence" : : : "memory");
 	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
diff --git a/lib/raid/raid6/x86/sse2.c b/lib/raid/raid6/x86/sse2.c
index 9e8bece51690..a0709916289c 100644
--- a/lib/raid/raid6/x86/sse2.c
+++ b/lib/raid/raid6/x86/sse2.c
@@ -113,7 +113,6 @@ static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
@@ -241,7 +240,6 @@ static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
 	}
 
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
@@ -445,7 +443,6 @@ static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 		asm volatile("movdqa %%xmm12,%0" : "=m" (q[d+32]));
 		asm volatile("movdqa %%xmm14,%0" : "=m" (q[d+48]));
 	}
-	asm volatile("sfence" : : : "memory");
 	kernel_fpu_end();
 }
 
-- 
2.53.0

