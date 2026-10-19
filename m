Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA52331EC2;
	Mon, 19 Oct 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372550; cv=none; b=dYxygxL3pzPSEq2eol5J65bpfdxO87Hl45aB6E178Prubbvfz9H+iNfgwaySY49KFVpTfnn0uz/UGbfpCuTQJvjK3jBNLETTeNTOsWxdDNvHp7gITDlCyjU0u29V/YRqQ68h3B5TPrqyQFX8EUgRD/KZiaPE4cOdG61IBgEI304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372550; c=relaxed/simple;
	bh=ZAnTXQc0f7P0tzvqfmezm/Yazl+p4SAeLfizcquFfLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsGxs3z+GDcKWuj4r01Lq50UkxWSTjwdyT563BmQHRsyuTyg4ZzGBaFuo9BlaHp4SOkgmBg3CDsyQbDeoMeOPP+Mk+LFejzIbgeDgfmqZ808VY0NJb6PsBMaCelYNS4JWZm1S97s/ZOxdmaUaGZ/dzccm1klwndFvXRBJcCl4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j7HdT5GdDzYQtwK;
	Mon, 19 Oct 2026 09:14:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7BE8740C9E;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO85b9VqI9LoAw--.23742S9;
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
Subject: [PATCH V2 5/6] md/raid0: factor out raid0_member_sectors()
Date: Mon, 19 Oct 2026 09:08:26 +0800
Message-ID: <20261019010827.2922617-6-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBXkO85b9VqI9LoAw--.23742S9
X-Coremail-Antispam: 1UD129KBjvJXoW7ArW5Xw18Kw13KF47tF48tFb_yoW8trykpw
	48Kas2grW8WryfW3WDJ34Uuayrtry5GrWDKFy7Za48Wwn7ur1DGFW3X345WFyUAasYv343
	t3yjkrWqk3Z5KrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBIb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7Cj
	xVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F4
	0Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC
	6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1wSdDUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

create_strip_zones() and the takeover coverage check both compute the size
a member contributes to a raid0 array. Pull that into a small helper so the
two sites share one definition.

No functional change.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8a76158c8395..3ab1e5079cc5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -61,10 +61,16 @@ static void dump_zones(struct mddev *mddev)
 			(unsigned long long)zone_size>>1);
 		zone_start = conf->strip_zone[j].zone_end;
 	}
 }
 
+static sector_t raid0_member_sectors(sector_t sectors, unsigned int chunk)
+{
+	sector_div(sectors, chunk);
+	return sectors * chunk;
+}
+
 static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 {
 	int i, c, err;
 	sector_t curr_zone_end, sectors;
 	struct md_rdev *smallest, *rdev1, *rdev2, *rdev, **dev;
@@ -84,13 +90,12 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			 mdname(mddev),
 			 rdev1->bdev);
 		c = 0;
 
 		/* round size to chunk_size */
-		sectors = rdev1->sectors;
-		sector_div(sectors, mddev->chunk_sectors);
-		rdev1->sectors = sectors * mddev->chunk_sectors;
+		rdev1->sectors = raid0_member_sectors(rdev1->sectors,
+						      mddev->chunk_sectors);
 
 		if (mddev_is_dm(mddev))
 			blksize = max(blksize, queue_logical_block_size(
 				      rdev1->bdev->bd_disk->queue));
 
@@ -652,16 +657,12 @@ static int raid0_takeover_check(struct mddev *mddev, int chunk)
 {
 	sector_t capacity = get_capacity(mddev->gendisk);
 	sector_t coverage = 0;
 	struct md_rdev *rdev;
 
-	rdev_for_each(rdev, mddev) {
-		sector_t sectors = rdev->sectors;
-
-		sector_div(sectors, chunk);
-		coverage += sectors * chunk;
-	}
+	rdev_for_each(rdev, mddev)
+		coverage += raid0_member_sectors(rdev->sectors, chunk);
 
 	if (coverage < capacity) {
 		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
 			mdname(mddev), (unsigned long long)coverage,
 			(unsigned long long)capacity);
-- 
2.52.0

