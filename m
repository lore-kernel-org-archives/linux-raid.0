Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BC81170F;
	Tue, 16 Jul 2024 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721098779; cv=none; b=hSHpgbgcfYNWgfBLcwNtqkP15M1GPl6hUX3vASCQf3MYIpiEkp5SM/g05AuX43dAtK1TDOJ9pdxO5I8zCbzzjpiILRhWsbVhwrlfhmrkmUOvmjioAbdfUefs41gTjcW2jjfWWuFKBwqrpVSXFdhD63EdmMHJP6JEqV2+146QAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721098779; c=relaxed/simple;
	bh=czKrBD/JvtXcPrM9YlfnvLLKo6Z2IzSZOmRbncwqi1c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J1bl2FarkEzqXkM7AYm1VlazPSTU9XukiBBuJbWkPX6i7WEBP5t5gHYmmd+yvOgJRvrgbRNuruUo9H1r06ttT4brdu7Z8HHI/YAc9y5GRhHDnaFuQbmJYZWHFBooA7OkyuLQZKeTHbBcmIE9jXMt7SZ+u+xDp5FeWWO4mjIjXuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAA3IyAR4pVmZw+NAw--.52047S2;
	Tue, 16 Jul 2024 10:59:29 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: song@kernel.org,
	yukuai3@huawei.com,
	neilb@suse.de
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] md: convert comma to semicolon
Date: Tue, 16 Jul 2024 10:58:52 +0800
Message-Id: <20240716025852.400259-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3IyAR4pVmZw+NAw--.52047S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZrWDGF1rGr4fuFW5trb_yoWxtFbEk3
	W8ZwsIqr1jyrnF9w1Uuw1fu392v34Durn7X3ZagFZavFZ8Zwn5ur1Uur18Gw15Ar909Fn8
	CryDGryUZw1kCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK
	6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbTUDJUUUU
	U==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery better.")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2a9c4ee982e0..e55e020b5571 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2465,7 +2465,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			s = PAGE_SIZE >> 9;
 
 		rdev = conf->mirrors[dr].rdev;
-		addr = r10_bio->devs[0].addr + sect,
+		addr = r10_bio->devs[0].addr + sect;
 		ok = sync_page_io(rdev,
 				  addr,
 				  s << 9,
-- 
2.25.1

