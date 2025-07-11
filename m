Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787833993;
	Fri, 11 Jul 2025 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228931; cv=none; b=FIjZQWvIFtvXArk+1FkknCDdG0zo8XwFF0fqjY2SiL29FGMlNQSd5mjNrIA8V4BT6Daqd64b7+qZvE5YTST0TlfJHbs3P1Y+5/eKgWMG6wst1cQS4+xpu6TsLmIq1vtZ+Uc9KoxOXhXSxKMXlMBjadJnjQB/rtB4rGZ0gDqAZVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228931; c=relaxed/simple;
	bh=r40kPMpsSl83aWblRJUVZTbn65KWGymHphp5La1fMAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P4T4S1xpn0tEPOlaAP4mCm/Ye0rVcfLLc1640B9YWxxFkJmRWOU/0y68OWJvrWJiABMUq1fp0VICnqWnFOz4FeIc8uMngmJ8xcmJkxO2iMl1lHbZB1VYaU+EKQ2wf9rCyTxAqdrffQyIuIXglAn7hyPIsvBxUqAmlO8OyMQhBYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-03 (Coremail) with SMTP id rQCowACXJ3nj4nBo8xESAw--.40582S2;
	Fri, 11 Jul 2025 18:09:39 +0800 (CST)
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
Subject: [PATCH V2 0/5] Add an optimization also raid6test for RISC-V support
Date: Fri, 11 Jul 2025 18:09:25 +0800
Message-Id: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXJ3nj4nBo8xESAw--.40582S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xry3JrWkXrW8WrW5Aw4UXFb_yoWfCFX_KF
	yrWF97Kw1DGF92gayayFs5AayUZrZ09ryrJ3WUGayUtr9rC392gws09w4xXF1UuFWrZF47
	Xr1rXF1xAr9F9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-8YjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
	80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_AcC_ZcWlOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UYxBIdaVFxhVjvjDU0xZFpf9x07jbxhdUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwwAB2hw2WUj2gAAsR

The 1st patch is a cleanup;
Patch 2/4 is an optimization that takes Palmer's suggestion;
The last two patches add raid6test support and make the raid6 RVV code buildable on user space.

V2:
* Addressed comments from v1:
- Replaced one load with a move to speed up in _gen/xor_syndrome();
- Added a compiler error
- Dropped the NSIZE macro, instead of using the vector length;
- Modified has_vector() definition for user space;

Chunyan Zhang (5):
  raid6: riscv: Clean up unused header file inclusion
  raid6: riscv: replace one load with a move to speed up the caculation
  raid6: riscv: Add a compiler error
  raid6: riscv: Allow code to be compiled in userspace
  raid6: test: Add support for RISC-V

 lib/raid6/recov_rvv.c   |   9 +-
 lib/raid6/rvv.c         | 362 ++++++++++++++++++++--------------------
 lib/raid6/rvv.h         |  17 ++
 lib/raid6/test/Makefile |   8 +
 4 files changed, 211 insertions(+), 185 deletions(-)

-- 
2.34.1

