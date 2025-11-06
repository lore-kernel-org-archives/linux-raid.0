Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E032C92B;
	Thu,  6 Nov 2025 12:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430897; cv=none; b=UzvV+vJeVlTUGWdQoiyfpQPOgFeJfFzM7QWoRr7JvG1WPBBmYoz5EHvMlSh6UZm+LHsxAILGqwO44Ug4N4iISHeUpqVhr5n82cnEEiefpcJfyRqXIRmhnmRYnd1+RoRZYYu/pNCKC09sH8O5mrhFU2cSUx8pvupJXjOED+p3P6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430897; c=relaxed/simple;
	bh=nKtxhoejEknn4V5i1b7tQPQVPpbTxPMqfdKksbnZBWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eM7/ByaJ9D/DAan59hnoBz3LEjH0cnSQDNkMm+iebmPu6NBUfL4YD+suaXgD0i0m7jBqskrrn5BbIQqqLLspAtQ4xuE8RIhyIiKSiijlO51cUfcgPrOP/HCWMxMTxaxdcPIi64CqRe9wKJcF6GW03LEWc9tR05+RNsAHLEpTiTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYP3pZdzKHMmj;
	Thu,  6 Nov 2025 20:07:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 38BA41A1066;
	Thu,  6 Nov 2025 20:08:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S13;
	Thu, 06 Nov 2025 20:08:02 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 09/11] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Thu,  6 Nov 2025 19:59:33 +0800
Message-Id: <20251106115935.2148714-10-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S13
X-Coremail-Antispam: 1UD129KBjvdXoWrtFy7uFy8Zw47GF1fKry8Krg_yoWkKFXEka
	45ZF4Yqr1I9r12yw15Cr1SvrWSva4DWan7Gr1Utry8Z34fZ3WFkr98uas5Xw15AF98XF90
	kw10g34Sva1DujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbL8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I64
	8v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQeOt
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 30a3434e9cbc..2a7817b23e25 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3400,7 +3400,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3415,6 +3414,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.39.2

