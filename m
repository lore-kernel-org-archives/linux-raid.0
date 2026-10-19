Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871133264F5;
	Mon, 19 Oct 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372549; cv=none; b=COplnpn2necOsaJWkxfVups0wF0oUTU1FTe85DPiSPAvhVUD2KsRa4WOzbRHFlolGRh1MMuRMMjnsEWEnIwitj2UWEev3NRxXlK8MDQAK1kVFQ2PtmFItY9TMjpEceZlMbrVDtkxXzorfuiahpxjStpppngmGmqNGLjDWcDSrC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372549; c=relaxed/simple;
	bh=6xEGJWrHT3hlas+CKvfPNTeANEppetlsVP9KsjSchvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skk3TqKTfJUQUhPZh6oEbmrC90L/ovDJeJJ9wyLKQID9zj8SgAFYR01iSnM8Fh9hhPlOxRV4lShmQPJcETxnh0fXdIfaCk6bJcy7FiteYY40JOquqVBCjuhbIX48W+OnxezqZMqj1psdemP1x+cg75B7ERpceSM1onmXKyUxqY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j7HfV6dbXzKHMQ1;
	Mon, 19 Oct 2026 09:15:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4CD0940C90;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO85b9VqI9LoAw--.23742S7;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH V2 3/6] md/raid5: don't leave mddev in an inconsistent state when takeover fails
Date: Mon, 19 Oct 2026 09:08:24 +0800
Message-ID: <20261019010827.2922617-4-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXkO85b9VqI9LoAw--.23742S7
X-Coremail-Antispam: 1UD129KBjvJXoW7tw47tw48uFyrCrWUJr4ktFb_yoW8Zw1Upw
	47X3W3XrWfJrWrX34DA3yqkaySy3s3GryvyF9xZ3y8WF1xAFWDGay5XFW5GFWUCas3Ar47
	t3yrArZYvFykKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrD73DUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

raid45_takeover_raid0() sets mddev->dev_sectors and resync_offset before
setup_conf(), which can fail. level_store() does not roll those back, so a
failed takeover leaves the running raid0 with the wrong component size and
resync offset.

setup_conf() does not need dev_sectors, so set it and resync_offset only
after setup_conf() succeeds.

Fixes: 54071b3808ee ("md:Add support for Raid0->Raid5 takeover")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid5.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..55b936830726 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8881,10 +8881,11 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 }
 
 static void *raid45_takeover_raid0(struct mddev *mddev, int level)
 {
 	struct r0conf *raid0_conf = mddev->private;
+	struct r5conf *conf;
 	sector_t sectors;
 
 	/* for raid0 takeover only one zone is supported */
 	if (raid0_conf->nr_strip_zones > 1) {
 		pr_warn("md/raid:%s: cannot takeover raid0 with more than one zone.\n",
@@ -8892,20 +8893,24 @@ static void *raid45_takeover_raid0(struct mddev *mddev, int level)
 		return ERR_PTR(-EINVAL);
 	}
 
 	sectors = raid0_conf->strip_zone[0].zone_end;
 	sector_div(sectors, raid0_conf->strip_zone[0].nb_dev);
-	mddev->dev_sectors = sectors;
 	mddev->new_level = level;
 	mddev->new_layout = ALGORITHM_PARITY_N;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->raid_disks += 1;
 	mddev->delta_disks = 1;
-	/* make sure it will be not marked as dirty */
-	mddev->resync_offset = MaxSector;
 
-	return setup_conf(mddev);
+	conf = setup_conf(mddev);
+	if (!IS_ERR(conf)) {
+		mddev->dev_sectors = sectors;
+		/* make sure it will be not marked as dirty */
+		mddev->resync_offset = MaxSector;
+	}
+
+	return conf;
 }
 
 static void *raid5_takeover_raid1(struct mddev *mddev)
 {
 	int chunksect;
-- 
2.52.0

