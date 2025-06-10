Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934028BA8E;
	Tue, 10 Jun 2025 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749550871; cv=none; b=qvRfdc9Xzh9ixNFLPrYRSHGzFEpu/uds0in/L5kSEZdXIcK85ejwHxVT/0SXNez7rvNTjyJYaj0pVUvlououXrM60lZ8XOkn4G4yQL+HAAz70cPU2vPXvIFELzL+pdoAQRioGkOfpPhwfAhF7p6pulAfLgpEfgr7aY9kemcLrbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749550871; c=relaxed/simple;
	bh=hqWQJI8onacjvRQEHq0SbLndXC4pMKKuCP3ZO9UJkJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3VPRlfo6bQ4f1QK93TR5d6OKSgDS7z1it059ibtlxNM3xTS41AcHyhrao5q/pWjDHISL8rHKATPumadHCdy2Dct+eTfXpRnctvBXSkf8qefHFxWBcu29KUP5O+1lsLOfvmoxyxnFZzWc2EWiGemHip3/d+jx9tWTCRMdxA9VsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-05 (Coremail) with SMTP id zQCowADXJRQjBUhoCfqKBQ--.1934S6;
	Tue, 10 Jun 2025 18:12:52 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH 4/4] raid6: test: Add support for RISC-V
Date: Tue, 10 Jun 2025 18:12:34 +0800
Message-Id: <20250610101234.1100660-5-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
References: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXJRQjBUhoCfqKBQ--.1934S6
X-Coremail-Antispam: 1UD129KBjvdXoWrurW8tr17GryUAF1kXF48tFb_yoWkCrc_Ca
	4Ikr92qr4xXay09anrZr9ayrs5Ar43tr1rC34rXr13JF17Kw1aga1UX3W3CFWYva15WayS
	9FWrZF18Z34jqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbB8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r126s0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0
	c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2
	IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_AcC_ZcWlOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjxU7FksDUUUU
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAcJB2hH3zHDsgAAs1

From: Chunyan Zhang <zhang.lyra@gmail.com>

Add RISC-V code to be compiled to allow the userspace raid6test program
to be built and run on RISC-V.

Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
---
 lib/raid6/test/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 8f2dd2210ba8..09bbe2b14cce 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -35,6 +35,11 @@ ifeq ($(ARCH),aarch64)
         HAS_NEON = yes
 endif
 
+ifeq ($(findstring riscv,$(ARCH)),riscv)
+        CFLAGS += -I../../../arch/riscv/include -DCONFIG_RISCV=1
+        HAS_RVV = yes
+endif
+
 ifeq ($(findstring ppc,$(ARCH)),ppc)
         CFLAGS += -I../../../arch/powerpc/include
         HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
@@ -63,6 +68,9 @@ else ifeq ($(HAS_ALTIVEC),yes)
                 vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
 else ifeq ($(ARCH),loongarch64)
         OBJS += loongarch_simd.o recov_loongarch_simd.o
+else ifeq ($(HAS_RVV),yes)
+        OBJS   += rvv.o recov_rvv.o
+        CFLAGS += -DCONFIG_RISCV_ISA_V=1
 endif
 
 .c.o:
-- 
2.34.1

