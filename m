Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90697330B15;
	Thu, 30 Oct 2025 06:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806176; cv=none; b=Mnfhn/6OgVQwvVXIyLBIo9IrLYy0Tw/bIbvqgjHdiQveZV5m7rfWa/OZiM677sAVbOZTs92RLMxkD8CY4Knbgq7Mrp+xPFebJb7JcJpdxImOcc2G5FjdCQvrVnXcFlmAft1U8XP0+60SZTGylPYqMCbutrPABcYg3Tpt7Z1wZcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806176; c=relaxed/simple;
	bh=AszGIhudkeauUKARKvxfTAQArAQEz3CXyE0Pq5DpCkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NVNv39xUTBC+tdjWpIzvJ6n4kM76CKMalzadNjrDLN9WaG6E9aXJioVP9HhlLDLK9RCCh0aLWIsSxV7Ph8fIzLR7HsbMeO21hooMBOtVXifg0s2IFaTBPS9SKjyKqw6KVk+5Uoxmtkrihswys7LU3A9mpzVQcuilDGseTnqk970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cxvWh1vDWzYQtkY;
	Thu, 30 Oct 2025 14:36:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8F2521A0359;
	Thu, 30 Oct 2025 14:36:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgDnPUZUBwNpEqJkCA--.9906S7;
	Thu, 30 Oct 2025 14:36:06 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	hare@suse.de,
	xni@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v8 3/4] md/raid0: Move queue limit setup before r0conf initialization
Date: Thu, 30 Oct 2025 14:28:06 +0800
Message-Id: <20251030062807.1515356-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251030062807.1515356-1-linan666@huaweicloud.com>
References: <20251030062807.1515356-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnPUZUBwNpEqJkCA--.9906S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1kWw43Xr15WFW5JF15XFb_yoW8tFykp3
	93K3ZIgry0gFW3WayDZrWkCa4Fqa4UtrWDtF9xZ348Xr1avryFgFy3WFy3WFW3t3yrAF15
	X3y5CFs7Cr9xKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd5rcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Prepare for making logical blocksize configurable. This change has no
impact until logical block size becomes configurable.

Move raid0_set_limits() before create_strip_zones(). It is safe as fields
modified in create_strip_zones() do not involve mddev configuration, and
rdev modifications there are not used in raid0_set_limits().

'blksize' in create_strip_zones() fetches mddev's logical block size,
which is already the maximum aross all rdevs, so the later max() can be
removed.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid0.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e443e478645a..fbf763401521 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -68,7 +68,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct strip_zone *zone;
 	int cnt;
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned blksize = 512;
+	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
 
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
@@ -84,9 +84,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		sector_div(sectors, mddev->chunk_sectors);
 		rdev1->sectors = sectors * mddev->chunk_sectors;
 
-		blksize = max(blksize, queue_logical_block_size(
-				      rdev1->bdev->bd_disk->queue));
-
 		rdev_for_each(rdev2, mddev) {
 			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
 				 " with %pg(%llu)\n",
@@ -405,6 +402,12 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
+	if (!mddev_is_dm(mddev)) {
+		ret = raid0_set_limits(mddev);
+		if (ret)
+			return ret;
+	}
+
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
@@ -413,11 +416,6 @@ static int raid0_run(struct mddev *mddev)
 		mddev->private = conf;
 	}
 	conf = mddev->private;
-	if (!mddev_is_dm(mddev)) {
-		ret = raid0_set_limits(mddev);
-		if (ret)
-			return ret;
-	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
-- 
2.39.2

