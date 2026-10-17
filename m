Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443392C87F;
	Sat, 17 Oct 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199113; cv=none; b=VBGLHAWjUBySDImR23sJgycKJJwW44iFZRHX2xEf6SCowpq2kOqG2rkYtaZ45oNxIryE21ImX/td0VZKvUfw8LOaK+17ri36YwehM5l5/MSmlQwuKh3+irrycdMTYnJTz58lRCbLPfrKRSC+hTMnf+E+HaWHICq+rApnhJtSdmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199113; c=relaxed/simple;
	bh=qH+9dqUUhV1hU9QJquO7hhGrsZML1+KTZePi0RMkwQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpHW/fTfYZZOUr4jYK+TztSNjt5WkYlsVkur55bPWt3YlVCYidka0/sNlHqUccRqrYAZi/kt1jaaA0B2lGluGN8XQXI+u8yr1I0yrlAXii016CZoMd4KZty3iHDL5XWjA5erDT88ZLfMdID593Mn0zkw9IovndJWYo5qCEs+qo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j63WM2MX3zKHMNl;
	Sat, 17 Oct 2026 09:05:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 617C04056E;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXBydJqADTpAg--.35962S5;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
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
Subject: [PATCH 1/3] md/raid0: reject a takeover whose zones cannot cover the array
Date: Sat, 17 Oct 2026 08:58:00 +0800
Message-ID: <20261017005802.2212102-2-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
References: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvXBydJqADTpAg--.35962S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1kKF4UGF1fWrWxCrW8Crg_yoWrXF1xpw
	4IqFn8XrZ5Jr9xAwn3tr9rGayFyryfGrZrtF9xX3y8Wr43Ar4DGFW5Xa4YgayUA395ZrWU
	ta1UGFWqkFyvgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzGYLUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

If a raid0 takeover builds strip zones that cover less than the advertised
array size, the block layer still accepts I/O for the whole size.
raid0_make_request() hands any request past the zones to the mapping code,
which fails to map it and triggers a BUG_ON.

The zones are built from the member sizes in rdev->sectors, which may not
match the size the array already advertises, so the zones can come out
covering less than it. The extreme case is a member with no size recorded
at all: an array created without metadata imports its devices through
md_import_device(dev, -1, -1), which never sets rdev->sectors, and
bind_rdev_to_array() does not reject such a member either, because its
check that mddev->dev_sectors fits inside a member is skipped when
rdev->sectors is zero.

Refuse a raid0 takeover when its zones cannot cover the size the gendisk
advertises. This prevents the takeover from silently shrinking the array,
mirroring the rule raid5_start_reshape() and raid10_start_reshape() apply
to a reshape.

Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..fccc62a5fecc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -641,10 +641,38 @@ static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
 		pr_crit("md/raid0%s: Disk failure on %pg detected, failing array.\n",
 			md_name, rdev->bdev);
 	}
 }
 
+/*
+ * Refuse a takeover whose strip zones cannot cover the capacity the gendisk
+ * advertises: raid0 derives those zones from the sizes of its members, so
+ * find_zone() cannot map I/O that falls beyond them.
+ */
+static int raid0_takeover_check(struct mddev *mddev, int chunk)
+{
+	sector_t capacity = get_capacity(mddev->gendisk);
+	sector_t coverage = 0;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		sector_t sectors = rdev->sectors;
+
+		sector_div(sectors, chunk);
+		coverage += sectors * chunk;
+	}
+
+	if (coverage < capacity) {
+		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
+			mdname(mddev), (unsigned long long)coverage,
+			(unsigned long long)capacity);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	struct r0conf *priv_conf;
 
@@ -663,10 +691,13 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 			return ERR_PTR(-EINVAL);
 		}
 		rdev->sectors = mddev->dev_sectors;
 	}
 
+	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->raid_disks--;
@@ -705,10 +736,13 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 		pr_warn("md/raid0:%s: All mirrors must be already degraded!\n",
 			mdname(mddev));
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->delta_disks = - mddev->raid_disks / 2;
@@ -748,10 +782,13 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 
 	if ((chunksect << 9) < PAGE_SIZE)
 		/* array size does not allow a suitable chunk size */
 		return ERR_PTR(-EINVAL);
 
+	if (raid0_takeover_check(mddev, chunksect))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = chunksect;
 	mddev->chunk_sectors = chunksect;
-- 
2.52.0

