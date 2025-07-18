Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A360B220F52;
	Fri, 18 Jul 2025 07:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752823661; cv=none; b=IQvY7o39Edtyci6cm3WpXLsMAVPNOOGclNmJz+kA0Sh81pG327leS0vFZcVyMwCacJUNs0EgdSGGSOnrglFd1ixvd+fIQQH7ABOPo03Na2V4P2mP3W6uapDaPAewAw3PAeJVQvBirA2de+CKbsBt1omL7DlVfoDbHP2+2gzrCjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752823661; c=relaxed/simple;
	bh=ZzBKV0+kSG9HbhtwE8QNYCUxdAxT0eZQEfO4bI49Kws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MVSzLB011L1aWNVIdBXDY3KaX5hilxyhx7pVhW2gHQ2GJGmSTkZujOvvFcg5sIgxW3sGp3Rsb+kvUgU57owu8DVEpIT/HYxFbg2ONaEvw9Pep/7XiDDGJ5GPSXUM/4xmsYnEvIAzt0ZhZ5MDAQyC8kD8aSDSkJETZs3UgfgjJdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-01 (Coremail) with SMTP id qwCowADnD6RT93loK4wdBQ--.27021S4;
	Fri, 18 Jul 2025 15:27:27 +0800 (CST)
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
Subject: [PATCH V3 2/5] raid6: riscv: replace one load with a move to speed up the caculation
Date: Fri, 18 Jul 2025 15:27:08 +0800
Message-Id: <20250718072711.3865118-3-zhangchunyan@iscas.ac.cn>
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
X-CM-TRANSID:qwCowADnD6RT93loK4wdBQ--.27021S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyDXrW8uF4xCw43CF4kWFg_yoWrury7p3
	WfKF1xAa4SqryxXrn7Arn7Jr93XFW2yay3tFnxAw47ZayDJw4DKrsYkw1v9F1DAFy8JayD
	ZryUtF1YyryqvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmqb7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE
	c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
	8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCF
	s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x
	0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
	CTnIWIevJa73UjIFyTuYvjxUcHqcUUUUU
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAgHB2h50cuIwAAAsH

Since wp$$==wq$$, it doesn't need to load the same data twice, use move
instruction to replace one of the loads to let the program run faster.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 lib/raid6/rvv.c | 60 ++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index b193ea176d5d..89da5fc247aa 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -44,7 +44,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
@@ -117,7 +117,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
@@ -218,9 +218,9 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
@@ -310,9 +310,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
@@ -440,13 +440,13 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      "vle8.v	v8, (%[wp2])\n"
-			      "vle8.v	v9, (%[wp2])\n"
+			      "vmv.v.v	v9, v8\n"
 			      "vle8.v	v12, (%[wp3])\n"
-			      "vle8.v	v13, (%[wp3])\n"
+			      "vmv.v.v	v13, v12\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
@@ -566,13 +566,13 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      "vle8.v	v8, (%[wp2])\n"
-			      "vle8.v	v9, (%[wp2])\n"
+			      "vmv.v.v	v9, v8\n"
 			      "vle8.v	v12, (%[wp3])\n"
-			      "vle8.v	v13, (%[wp3])\n"
+			      "vmv.v.v	v13, v12\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
@@ -754,21 +754,21 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      "vle8.v	v8, (%[wp2])\n"
-			      "vle8.v	v9, (%[wp2])\n"
+			      "vmv.v.v	v9, v8\n"
 			      "vle8.v	v12, (%[wp3])\n"
-			      "vle8.v	v13, (%[wp3])\n"
+			      "vmv.v.v	v13, v12\n"
 			      "vle8.v	v16, (%[wp4])\n"
-			      "vle8.v	v17, (%[wp4])\n"
+			      "vmv.v.v	v17, v16\n"
 			      "vle8.v	v20, (%[wp5])\n"
-			      "vle8.v	v21, (%[wp5])\n"
+			      "vmv.v.v	v21, v20\n"
 			      "vle8.v	v24, (%[wp6])\n"
-			      "vle8.v	v25, (%[wp6])\n"
+			      "vmv.v.v	v25, v24\n"
 			      "vle8.v	v28, (%[wp7])\n"
-			      "vle8.v	v29, (%[wp7])\n"
+			      "vmv.v.v	v29, v28\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
@@ -948,21 +948,21 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
 		asm volatile (".option	push\n"
 			      ".option	arch,+v\n"
 			      "vle8.v	v0, (%[wp0])\n"
-			      "vle8.v	v1, (%[wp0])\n"
+			      "vmv.v.v	v1, v0\n"
 			      "vle8.v	v4, (%[wp1])\n"
-			      "vle8.v	v5, (%[wp1])\n"
+			      "vmv.v.v	v5, v4\n"
 			      "vle8.v	v8, (%[wp2])\n"
-			      "vle8.v	v9, (%[wp2])\n"
+			      "vmv.v.v	v9, v8\n"
 			      "vle8.v	v12, (%[wp3])\n"
-			      "vle8.v	v13, (%[wp3])\n"
+			      "vmv.v.v	v13, v12\n"
 			      "vle8.v	v16, (%[wp4])\n"
-			      "vle8.v	v17, (%[wp4])\n"
+			      "vmv.v.v	v17, v16\n"
 			      "vle8.v	v20, (%[wp5])\n"
-			      "vle8.v	v21, (%[wp5])\n"
+			      "vmv.v.v	v21, v20\n"
 			      "vle8.v	v24, (%[wp6])\n"
-			      "vle8.v	v25, (%[wp6])\n"
+			      "vmv.v.v	v25, v24\n"
 			      "vle8.v	v28, (%[wp7])\n"
-			      "vle8.v	v29, (%[wp7])\n"
+			      "vmv.v.v	v29, v28\n"
 			      ".option	pop\n"
 			      : :
 			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
-- 
2.34.1

