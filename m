Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87088285CAA;
	Mon, 19 Oct 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372550; cv=none; b=LraHoKMufrEqXioC3i5sLjjQX2wmy7JHgwOUDahMz/NdxFvKZt52lVlUtDLdOMLTqGns01Qg17F0Nw274fBKWhgXyCXktG3vAQAYVD5wHFa6sJpG3oyyNWKwca7xhdRKw2t9nzSL3WyOBokAlSRi2m59a9QDbF8OO4cuWfchPLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372550; c=relaxed/simple;
	bh=Mvx7xZATIR93As+EZhU49t/L281iwVY5itPncpIqMZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPsz684ZHRVcAukkQh0V/ZEKQaQmsRAl9C1NZ9+OMQaKTDNb+ZftmPiuOYS5Vmm0R259rD/0CUgr3wabs0vD4xh/Gbqwp4K/Zm+1aTZxKaaB/H7v4yasesaXUDSx51a9wEWXMwUX6hqp7y1Zp/jjacV8Vu8Om0FEPSiIv4hLCWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j7HfW01MDzKHMSH;
	Mon, 19 Oct 2026 09:15:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 65DF14056D;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO85b9VqI9LoAw--.23742S8;
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
Subject: [PATCH V2 4/6] md/raid0: reject a takeover whose zones cannot cover the array
Date: Mon, 19 Oct 2026 09:08:25 +0800
Message-ID: <20261019010827.2922617-5-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBXkO85b9VqI9LoAw--.23742S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1kKF4UGF1fWrWxCrW8Crg_yoWrAw4kp3
	y0qFnxXrZ5Gr9xAwnxJr9rGayFyryfGrZrtF9xX3yUWr47Ar4DGFW5Xa4YgayUA395ZryU
	ta1UCFWqkFyvgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7Cj
	xVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F4
	0Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC
	6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrKZXUUUUU
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

The check iterates the same devices and uses the same rounding as
create_strip_zones(). It does not skip devices with rdev->raid_disk < 0:
such devices cannot be raid0 members, so counting them only overestimates
the coverage and, if present, the takeover fails later in
create_strip_zones() anyway.

Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8157e1058a24..8a76158c8395 100644
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
@@ -706,10 +737,13 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
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
@@ -751,10 +785,13 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 
 	if ((chunksect << 9) < PAGE_SIZE)
 		/* array size does not allow a suitable chunk size */
 		return ERR_PTR(-EINVAL);
 
+	if (raid0_takeover_check(mddev, chunksect))
+		return ERR_PTR(-EINVAL);
+
 	/* Save for rollback if create_strip_zones() fails */
 	old_chunk_sectors = mddev->chunk_sectors;
 
 	/* Set new parameters */
 	mddev->new_level = 0;
-- 
2.52.0

