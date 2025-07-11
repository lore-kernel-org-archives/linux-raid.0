Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78C16BFCE;
	Fri, 11 Jul 2025 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228932; cv=none; b=C5xMiLZPCJS8vHAr2SmEpKATBao5ZyGW9Kz9ahHpAEIu6Lg2tZOtM00RAjXFaZ7P55647dV5e8Nfpi7ctxRN3+ZHNN3hG+VX1yPO9p9nc4QQOXDODfLCAFVOJpgIv3+rALa9v/xY717eyQrQ5k8qMrHu3kQ0sxfN6cXIvWEJ9Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228932; c=relaxed/simple;
	bh=hqWQJI8onacjvRQEHq0SbLndXC4pMKKuCP3ZO9UJkJg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JH0tR4IYAmZ9445iG5CadjF8e1wxlG5M4AxfYuUaKNzXh7PPJmWRteTx3vQWuX5RVonJMT8qQbzueQYVuO6ymsEcpNKWQBV69sgeOhcrpgsFSrmx+g9eMbcJyvBSxMJ28u9tF29VSe92LdQooR2aNliAOIzvm+q/tUQzQckyLgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-03 (Coremail) with SMTP id rQCowACXJ3nj4nBo8xESAw--.40582S7;
	Fri, 11 Jul 2025 18:09:40 +0800 (CST)
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
Subject: [PATCH V2 5/5] raid6: test: Add support for RISC-V
Date: Fri, 11 Jul 2025 18:09:30 +0800
Message-Id: <20250711100930.3398336-6-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXJ3nj4nBo8xESAw--.40582S7
X-Coremail-Antispam: 1UD129KBjvdXoWrurW8tr17GryUAF1kXF48tFb_yoWkCrc_Ca
	4Ikr92qr4xXay09anrZr9ayrs5Ar43tr1rC34rXr13JF17Kw1aga1UX3W3CFWYva15WayS
	9FWrZF18Z34jqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbB8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r126s0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0
	c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2
	IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280
	aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_AcC_ZcWlOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mx
	kF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	CVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjxUzL0eDUUUU
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgoAB2hw3B0YcAAAs6

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

