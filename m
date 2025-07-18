Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AFA237717;
	Fri, 18 Jul 2025 07:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752823651; cv=none; b=Ixpuhb65voBvu+61uG80rzrv52koJtZ8GFZepzSBdj9amgiv+XMenhaIxtfaKmauwuAdH7xe/Er0JGN52btJbpbjZhv/Gr7xOVPw2Tn4bXgclsdEsQYLrkJYZxD7bzIAgb6txKuPY3Gpi13zv1tYUa0Gef17BWPdXe7NjRfFq9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752823651; c=relaxed/simple;
	bh=LC+Yvb+Z1xqcYH1f5RBWJfa8DiKCPYJJneO4xjY0yG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=de9igmsXK4p68wJmWwcWgqs/4uC+PjKmNV6b0BbgbtoPAGcYf9IKfJk1frMCAbMVnJK8xK2ab3NI7xaeFgMD243wso+grw+LimMfzaFE85819kNsJbux+NvJNAzdc5GA2qEGuo4WDxed0PSsd6ncp2R9TrxDlWvJ9YQekmwdyqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.2])
	by APP-01 (Coremail) with SMTP id qwCowADnD6RT93loK4wdBQ--.27021S2;
	Fri, 18 Jul 2025 15:27:15 +0800 (CST)
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
Subject: [PATCH V3 0/5] Add an optimization also raid6test for RISC-V support
Date: Fri, 18 Jul 2025 15:27:06 +0800
Message-Id: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnD6RT93loK4wdBQ--.27021S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xry3JrWkXry8Jr43uFy5twb_yoWDurg_KF
	yrCF97Kw1DGF92qay3AFs5Aa4j9rWq9ryrt3WUJay5tr9rC39rWws8ZrWxXF1UuFWrZF4x
	Xr1rXF1xAr9F9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-8YjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
	80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxV
	CFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r10
	6r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxV
	WUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UYxBIdaVFxhVjvjDU0xZFpf9x07jrYFAUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgsHB2h50BWMSQAAsc

The 1st patch is a cleanup;
Patch 2/4 is an optimization that takes Palmer's suggestion;
The last two patches add raid6test support and make the raid6 RVV code buildable on user space.

V3:
- Rephrased the commit message of patch 3;
- Added Alex's Reviewed-by on patch 1-2;

V2:
* Addressed comments from v1:
- Replaced one load with a move to speed up in _gen/xor_syndrome();
- Added a compiler error
- Dropped the NSIZE macro, instead of using the vector length;
- Modified has_vector() definition for user space;

Chunyan Zhang (5):
  raid6: riscv: Clean up unused header file inclusion
  raid6: riscv: replace one load with a move to speed up the caculation
  raid6: riscv: Prevent compiler with vector support to build already
    vectorized code
  raid6: riscv: Allow code to be compiled in userspace
  raid6: test: Add support for RISC-V

 lib/raid6/recov_rvv.c   |   9 +-
 lib/raid6/rvv.c         | 362 ++++++++++++++++++++--------------------
 lib/raid6/rvv.h         |  17 ++
 lib/raid6/test/Makefile |   8 +
 4 files changed, 211 insertions(+), 185 deletions(-)

-- 
2.34.1

