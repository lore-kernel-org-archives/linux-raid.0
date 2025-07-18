Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2058223ABA1;
	Fri, 18 Jul 2025 07:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752823662; cv=none; b=IqsvXRdtsQxcvcWNG0XsDqyWcWntQKOfVM7Xy1VgF0A+aAQqIrZVYVzlpJ8J29+IUDfyUWPOLOVyMeBmXcm9SFfBBYpCOF+I+c/AQ3ERyKzyqglJXzmHsPIAtNSZqQgerrzRiuX8y8Y/NMiOETQtw8AFR3SStxu+8sualCa6m5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752823662; c=relaxed/simple;
	bh=Uk913nRYxtdWy7tNJm0iREa7rDTujjAsVU7LsKuv6r4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AQhFjAn0fJkUvP4SEP2ED5jjCXH5W7hzXtRDtolyxkHGSYWrnBMDW7nOiIk7B21TTSDyxQeV1mqG3dsznTe0DYhBkLFLHkq7MCtslYucn2ebHS09yc3brFFGtPlmT+p0m3ilpkYrWf+0u5jKH/thhc9YGGuohIrKcJy2/DL8iUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-01 (Coremail) with SMTP id qwCowADnD6RT93loK4wdBQ--.27021S5;
	Fri, 18 Jul 2025 15:27:29 +0800 (CST)
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
Subject: [PATCH V3 3/5] raid6: riscv: Prevent compiler with vector support to build already vectorized code
Date: Fri, 18 Jul 2025 15:27:09 +0800
Message-Id: <20250718072711.3865118-4-zhangchunyan@iscas.ac.cn>
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
X-CM-TRANSID:qwCowADnD6RT93loK4wdBQ--.27021S5
X-Coremail-Antispam: 1UD129KBjvdXoWruFy3CFyrJr4UZF1rKrW5GFg_yoW3Jrg_AF
	1FkF1xJFykCFs2v39IyFZ8u3s5Zws0qF18XF97tw13Xry8Za4Y9a9Ivrn5ZFy0qrW7ZFsI
	qrn8JFWIyw1q9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb98YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r1rM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CE
	w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6x
	kF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY
	1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4
	xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCa
	FVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I
	0En4kS14v26r1q6r43MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
	7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jOF4_UUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgoHB2h50BWMfQAAsp

To avoid the inline assembly code to break what the compiler could have
vectorized, this code must be built without compiler support for vector.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 lib/raid6/rvv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 89da5fc247aa..015f3ee4da25 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -20,6 +20,10 @@ static int rvv_has_vector(void)
 	return has_vector();
 }
 
+#ifdef __riscv_vector
+#error "This code must be built without compiler support for vector"
+#endif
+
 static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
 {
 	u8 **dptr = (u8 **)ptrs;
-- 
2.34.1

