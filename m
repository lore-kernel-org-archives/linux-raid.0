Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E972D28315C;
	Tue, 10 Jun 2025 10:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749550870; cv=none; b=Ek3DT18HutqngRiLBjbfiG2reExo26bWy6ZUIiqBTkAQmjtxMqkJID6qOmmW8w6X1Dxf0meVyMumbrMR9wY061IDXP4r2V0Oi4W4Vzmux+s3pjKtsYWcmGC602/TxKlhVbEjWQtifxmtA6Pl4SuL9vVx8ja3kW3V9SwHGVN3/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749550870; c=relaxed/simple;
	bh=XyalkKVjp2q+pBLqXVw/2cnq0wd74L3otLOdH41cd8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MSAovaoIeBuadpfEmqWpUkLq1c4J9I8NdWhatgWbqMbfPy4FQe+fyGMNYpxbgnfHVQbYxpnXrNVawKGf4RgTgpu+PhdBUwX/6bl+i4zRHiIz3Jx7IogWcBenMLr9n1p7Jb71vO5jaCHZK0FNJAzj8wGlVq5HkwIS6Y51ZGv7D6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-05 (Coremail) with SMTP id zQCowADXJRQjBUhoCfqKBQ--.1934S2;
	Tue, 10 Jun 2025 18:12:51 +0800 (CST)
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
Subject: [PATCH 0/4] Fix a segmentation fault also add raid6test for RISC-V support
Date: Tue, 10 Jun 2025 18:12:30 +0800
Message-Id: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXJRQjBUhoCfqKBQ--.1934S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr17Zr4UtrWkZFW3JrWkZwb_yoWfZwc_Wa
	yxGFWqkF17GFWvvay3AF1kA3y8Cr4avry8Z3W8Jay3Jry3CrW3KrsIgrW7X3WDZFy8ZFnr
	Xr1rAFWxZrnF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-8YjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
	80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_AcC_ZcWlOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UYxBIdaVFxhVjvjDU0xZFpf9x07jjfOwUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgoJB2hH3sPHqgAAsd

The first two patches are fixes. 
The last two are for userspace raid6test support on RISC-V.

The issue fixed in patch 2/4 was probably the same which was spotted by
Charlie [1], I couldn't reproduce it at that time.

When running raid6test in userspace on RISC-V, I saw a segmentation fault,
I used gdb command to print pointer p, it was an unaccessible address.

With patch 2/4, the issue didn't appear anymore.

[1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/

Chunyan Zhang (4):
  raid6: riscv: clean up unused header file inclusion
  raid6: riscv: Fix NULL pointer dereference issue
  raid6: riscv: Allow code to be compiled in userspace
  raid6: test: add support for RISC-V

 lib/raid6/recov_rvv.c   |  9 +-----
 lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
 lib/raid6/rvv.h         | 15 ++++++++++
 lib/raid6/test/Makefile |  8 ++++++
 4 files changed, 56 insertions(+), 38 deletions(-)

-- 
2.34.1

