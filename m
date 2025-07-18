Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35AC220F4C;
	Fri, 18 Jul 2025 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752823660; cv=none; b=lJinRzti7NAsQ0GBmbiik0Hjyh1I3NmwfhIQvuX0TxeIQHHUZ/Rr08ymjUTbNA3N+LdXlXyZ1D+p7dTY8Lkfwn1f+aomcBXpCFimm1YQdXS9MqNFyweMeUBrUwrFljPa+F0MqQMPk9ME0WwWSv6iZ9AdBYDlhEfP0fK+3eF64vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752823660; c=relaxed/simple;
	bh=wHi4lNuoxK6HfihfPz2k2Ue6ziftnatAt/8z8dM8des=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H7NjmdD5tA+okBtEyMFR8cnev9+gVCStdKIrjiKKmtUTzm8vcL3Jx/+MLQbTbUEE9/qcq5yAIX2WUEmmGoNWT0k1FZdhB+baR9laQtFnK+VqZeEXzeqqzl5RcuUa0EIL8jMgZuSDpaBEgEfcp1S9nh8DwYdTD7HTBGPD4bP/yNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-01 (Coremail) with SMTP id qwCowADnD6RT93loK4wdBQ--.27021S3;
	Fri, 18 Jul 2025 15:27:26 +0800 (CST)
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
Subject: [PATCH V3 1/5] raid6: riscv: Clean up unused header file inclusion
Date: Fri, 18 Jul 2025 15:27:07 +0800
Message-Id: <20250718072711.3865118-2-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnD6RT93loK4wdBQ--.27021S3
X-Coremail-Antispam: 1UD129KBjvJXoWrKr45GF4UZr4DArWxtw4Dtwb_yoW8JrW7pF
	1DCr47Jr9xKr1fJF9ruF10kFs5Ja4q9ryUGFyUu34DXw13tF95X39YvayjyFy8Z3yjqFWx
	uFWUXr1rZ3yjq3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmSb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY
	1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4
	xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCa
	FVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I
	0En4kS14v26r1q6r43MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
	7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jV7KxUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwoHB2h50QGLTwAAsI

These two C files don't reference things defined in simd.h or types.h
so remove these redundant #inclusions.

Fixes: 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 lib/raid6/recov_rvv.c | 2 --
 lib/raid6/rvv.c       | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index f29303795ccf..500da521a806 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -4,9 +4,7 @@
  * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
  */
 
-#include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
 #include <linux/raid/pq.h>
 
 static int rvv_has_vector(void)
diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 7d82efa5b14f..b193ea176d5d 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -9,11 +9,8 @@
  *	Copyright 2002-2004 H. Peter Anvin
  */
 
-#include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
 #include <linux/raid/pq.h>
-#include <linux/types.h>
 #include "rvv.h"
 
 #define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
-- 
2.34.1

