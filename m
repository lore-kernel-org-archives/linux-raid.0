Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68821E3DDE;
	Wed, 31 Dec 2025 07:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767165502; cv=none; b=CkZHNrqhTSKMO5BL0w7lbj7TqGa539EIil2RZV/ELb+qWBc/Mqoox9Zlei47f0nNsJndDjopkFLIRktElycEFgIPTM81JtaxRxfEpUTJImCToDXixg4l+1Kkymh6sR4C+Wc36rtgRX7Nf/4FTNz026EJOkL6w8ynheEzH1GuBlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767165502; c=relaxed/simple;
	bh=5fhhdDqGvZE6TNpB2GUAOlc5+/XdCqYefr6aCqA7TFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IkUI9j86Yuo6IuOLW6SXsVEPIAcRRrIQSiUcsPlfSx1DCvtYes+vk3UZk6RZsjA9uJeaxuoEkXQ18uS0AA9JJ+ssYWB1YHg/nVLyPy/2OZwKGAhU30I3YwpuLfjAqdYr6sGdEKwwsELsedRY6wgtx5ge8xQ3IeyX1nZaR/caRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dh1WH3chKzKHMcr;
	Wed, 31 Dec 2025 15:17:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AEA994056B;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+PgvzlRpTtVyCA--.62349S8;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com,
	linan122@h-partners.com
Subject: [RFC PATCH 4/5] md: introduce MAX_RAID_DISKS macro to replace magic number
Date: Wed, 31 Dec 2025 15:09:51 +0800
Message-Id: <20251231070952.1233903-5-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+PgvzlRpTtVyCA--.62349S8
X-Coremail-Antispam: 1UD129KBjvJXoW7trWUtry7WF1fWrWkZFW8JFb_yoW8WrW3pa
	97WF9xuw1rZw4UKw1kXrykuFy5Zw13KrWDKrWa939avF90yr15uFZ8Ga4DJr95WF95ZF12
	vrs0gw45W348Kr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UJKsUUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Define MAX_RAID_DISKS macro for the maximum number of RAID disks.
No functional change.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 4 ++--
 drivers/md/md.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9eeab5258189..d2f136706f6c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1888,7 +1888,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 
 	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
 	    sb->major_version != cpu_to_le32(1) ||
-	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
+	    le32_to_cpu(sb->max_dev) > MAX_RAID_DISKS ||
 	    le64_to_cpu(sb->super_offset) != rdev->sb_start ||
 	    (le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
 		return -EINVAL;
@@ -2065,7 +2065,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->resync_offset = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
 
-		mddev->max_disks =  (4096-256)/2;
+		mddev->max_disks = MAX_RAID_DISKS;
 
 		if (!mddev->logical_block_size)
 			mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a083f37374d0..6a4af4a1959c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -22,6 +22,7 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+#define MAX_RAID_DISKS ((4096-256)/2)
 
 enum md_submodule_type {
 	MD_PERSONALITY = 0,
-- 
2.39.2

