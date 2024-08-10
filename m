Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC42C768FC;
	Sat, 10 Aug 2024 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255980; cv=none; b=t/yyYoZRsQxeqEw/Zix3UUxucSjzskhUBuzlxEtbBHls9Uv4gg7hR63aWg5aTSNzSKCJ8ptk5PD1oAcHxyp81S59Af6rt6yEds3MVK/fSy+B5ZI6cCKOk1cwIxaR32VDftw++lF+JU9hUz1uGv2SexXVvZFlt+qKPZFxXyZC2Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255980; c=relaxed/simple;
	bh=EPAN+eNjEibMqCHz2sVTaGwU1MF1ALOpXhYvKQo4nfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JaqLWcgc/GCYU/gLYoEi8TiqfVOgFd2A4dyDkDmA3Qd3JIuSbYdkAjcpXZM+yrtJKPe1sVViMETyrAr20SDhDSYqQDSlj5MckgYK59pOX+w1ew5hONzSjxl3zjPDRT9mLdOvhaulZ4mkKTiJWaHqc+zxHmierEN/DqjDR/QQ440=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknp3nHgz4f3jk0;
	Sat, 10 Aug 2024 10:12:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 99BCF1A07B6;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S13;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 09/26] md/md-bitmap: remove md_bitmap_setallbits()
Date: Sat, 10 Aug 2024 10:08:37 +0800
Message-Id: <20240810020854.797814-10-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S13
X-Coremail-Antispam: 1UD129KBjvdXoW7Jr1ftF15WF45uw1xXr1DWrg_yoW3Grb_Za
	1ktryxWryUCF9YyF17Xr1Svry2qw1DWa1kuFWIqrWfZF13Aa4rGr40kr1DtrW8GFyDCa43
	KryUXr48Gr4Y9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbD8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r
	1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_bitmap_setallbits() is not used, hence can be removed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index c60b6a9f6163..3fd2e5a7ba9c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -296,7 +296,6 @@ static inline void md_bitmap_update_sb(struct mddev *mddev)
 	mddev->bitmap_ops->update_sb(mddev->bitmap);
 }
 
-int  md_bitmap_setallbits(struct bitmap *bitmap);
 void md_bitmap_write_all(struct bitmap *bitmap);
 
 void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
-- 
2.39.2

