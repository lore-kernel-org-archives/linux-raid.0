Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9E2A1BA;
	Wed,  2 Apr 2025 01:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743556898; cv=none; b=KfspgK72P2p+pjmFADjngkyxJ/dfl54CxxlSKnxZ+5YlpeDR1+YUQCfI39RBlC+AMOy0PRad6bCAQbRNmHs6hGZWbgGPwoUHHXqj2AnxsTugEgBHIvkgBaP3SsEqxtuTC1LmXs6MYx5fGZftY4vHBwsN3wa0FvkCUcelYCJhM+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743556898; c=relaxed/simple;
	bh=aYyVIzgzhhyHvf939E1o9CMp+M6zmVsxNMXbQCBdI1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dx+mcTcKYabD3QEojvh60Gw8b+oYtyFVcTXYMwlRh5lRMRtwnuF0TGcT7/sdoJR+J7u8D0RbDvx3VgNE+CRp9M9Yg19BlNl8XNG3F0hInRvHpRu0ZA9JsFQBQzVd/7wQGb1bI9zxa6esr+7c6wUzsL5jafIE1/Spv/jWfT5gIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZS6Wm2PWnz4f3jdm;
	Wed,  2 Apr 2025 09:21:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 789781A13C6;
	Wed,  2 Apr 2025 09:21:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl8ZkexnpREBIQ--.27487S4;
	Wed, 02 Apr 2025 09:21:31 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH] md/md-bitmap: fix stats collection for external bitmaps
Date: Wed,  2 Apr 2025 09:15:23 +0800
Message-Id: <20250402011523.2271768-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl8ZkexnpREBIQ--.27487S4
X-Coremail-Antispam: 1UD129KBjvdXoW7JF1rWrW7uF45JF13Jw1UJrb_yoWkKFX_ua
	40yrySgrWUXrs8tw13Xr43Zryjya4DW3WkJ3y0q3yS9r13u34DGF40vrnIy3srXry3Cwn8
	Wryjvr1Iqr13ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

The bitmap_get_stats() function incorrectly returns -ENOENT for external
bitmaps, preventing statistics collection when a valid superblock page
exists.

Remove the external bitmap check as the statistics should be available
regardless of bitmap storage location when sb_page is present.

Note: "bitmap_info.external" here refers to a bitmap stored in a separate
file (bitmap_file), not to external metadata.

Fixes: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md-bitmap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 44ec9b17cfd3..afd01c93ddd9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2357,8 +2357,6 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 
 	if (!bitmap)
 		return -ENOENT;
-	if (bitmap->mddev->bitmap_info.external)
-		return -ENOENT;
 	if (!bitmap->storage.sb_page) /* no superblock */
 		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
-- 
2.39.2

