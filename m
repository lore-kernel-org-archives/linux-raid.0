Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933FC3783DA;
	Tue,  3 Feb 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099768; cv=none; b=L7k5Sl5Aw3mqKo6mxcV7T+ikf+LHRiRYsYh7xZreFtQgN/u+OQWUJU6HCvRZICQhQOS1fvTVroLxdXPxeFxIcXWwjmRhlSggYwZ8edjO77ENJP8ebSjVAsH+ncoAeWuqid3lcjUm9U83/KtoGObRXwPurX+u4jsKO3QXEgk7oDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099768; c=relaxed/simple;
	bh=+srh8IiFzbZjZLF0lmTKeUvcZo51QNWddbClixoALwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CpopkaEIZc5qSL0uXZQUw6oy4uWsiRpHfqtQEPJTl6GDI/DfQ7LSzpPJ2DR1hBs7rYWOyV5Jrpq1RNjLLVKcHRI7un6WYqHgtmwwVkLWBmI+EPzYLBhMpI1ca0OBxeVuQYWskyAGYne5+VXNyqg05/iRTyT+N2AtqvZBprYyIpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f4tg76SS1zYQtxN;
	Tue,  3 Feb 2026 14:21:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D16F540593;
	Tue,  3 Feb 2026 14:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_cilIFpIQhbGA--.27054S8;
	Tue, 03 Feb 2026 14:22:42 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [RFC v2 4/5] md: introduce MAX_RAID_DISKS macro to replace magic number
Date: Tue,  3 Feb 2026 14:12:58 +0800
Message-Id: <20260203061259.609206-5-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_cilIFpIQhbGA--.27054S8
X-Coremail-Antispam: 1UD129KBjvJXoW7CFW5XFWrWF45Jw45WF47CFg_yoW8Zr13pa
	9ruFy5Zw1rXr1UKwn7XrykCFy5Zw17GrWUKrWY939avas0yr1UArWDJa98Jr95WFn5AFnr
	Zrs8WrW5Was2qw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE
	7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
	kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw
	0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x
	07UX189UUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Per-device state is stored as a __le16 dev_roles[] array (2 bytes per
device) plus a fixed 256-byte header, still within a 4 KiB superblock.
Therefore the theoretical maximum is (4096 - 256) / 2 = 1920 entries.

Define MAX_RAID_DISKS macro for the maximum number of RAID disks. No
functional change.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 4 ++--
 drivers/md/md.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f319621c6832..aebbdbaa4e0a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1873,7 +1873,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 
 	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
 	    sb->major_version != cpu_to_le32(1) ||
-	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
+	    le32_to_cpu(sb->max_dev) > MAX_RAID_DISKS ||
 	    le64_to_cpu(sb->super_offset) != rdev->sb_start ||
 	    (le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
 		return -EINVAL;
@@ -2050,7 +2050,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		mddev->resync_offset = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
 
-		mddev->max_disks =  (4096-256)/2;
+		mddev->max_disks = MAX_RAID_DISKS;
 
 		if (!mddev->logical_block_size)
 			mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a083f37374d0..14f9db38b7c5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -21,6 +21,11 @@
 #include <linux/raid/md_u.h>
 #include <trace/events/block.h>
 
+/*
+ * v1.x superblock occupies one 4 KiB block: 256B header + 2B per device
+ * in dev_roles[].
+ */
+#define MAX_RAID_DISKS ((4096-256)/2)
 #define MaxSector (~(sector_t)0)
 
 enum md_submodule_type {
-- 
2.39.2

