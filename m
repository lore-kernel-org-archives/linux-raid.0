Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B478238C0C;
	Wed,  2 Jul 2025 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751452258; cv=none; b=JRcih80wGxwI/M+rfEknxVB6v6zk3++kbUhUbIn7iKQSEtTbdGYKfxfUS+ojm26FkkiBS1O2dKh9MXzXys4ucyvYsDK+OeVU1pXJHu2/BNPeakvSAfxj4ZTtn/OoSumFYoIk2xjud31XpWC+7X/gkXGnXM6iv/RUa1hRrQgYyUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751452258; c=relaxed/simple;
	bh=PwaLIRZZ+zNd55Wo4Lwsq2k0+RwAv0Yy8uSElGUCDoo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b2p/oU8bN0CXNdWdYMnm30+db6hpFFtOUvkWUsJde6pWqialplMAZmQjh86+lmhZ1czV+GetDGyLry6QoTjW/TMv3a2KsnrL1zeadwtb2THzrHZiIqg0jpRYgBXaRlbd0+nzMtQdg+hjQtoXhMWMmDNNFH7qX/9I3FpjpHgbgtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bXGQ55LvJzKHMyb;
	Wed,  2 Jul 2025 18:30:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 28A341A07FA;
	Wed,  2 Jul 2025 18:30:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgCHNSNaCmVoxoqlAQ--.14629S4;
	Wed, 02 Jul 2025 18:30:52 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH] md/raid1,raid10: strip REQ_NOWAIT from member bios
Date: Wed,  2 Jul 2025 18:23:41 +0800
Message-Id: <20250702102341.1969154-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHNSNaCmVoxoqlAQ--.14629S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJr47Zw4xAw4ruF18uFWfKrg_yoW8uFyfp3
	9rKa4rZrW5G34rZF1jyayDuayFqwsFga9FkrWxJ3yfZryavFyDWa1rXay0grn8XFn5ury7
	ZFn0yrsrWF45JFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

RAID layers don't implement proper non-blocking semantics for
REQ_NOWAIT, making the flag potentially misleading when propagated
to member disks.

This patch clear REQ_NOWAIT from cloned bios in raid1/raid10. Retain
original bio's REQ_NOWAIT flag for upper layer error handling.

Maybe we can implement non-blocking I/O handling mechanisms within
RAID in future work.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/raid1.c  | 3 ++-
 drivers/md/raid10.c | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c5a0ce5a40..213ad5b7e20b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1399,7 +1399,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	read_bio = bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
 				   &mddev->bio_set);
-
+	read_bio->bi_opf &= ~REQ_NOWAIT;
 	r1_bio->bios[rdisk] = read_bio;
 
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
@@ -1649,6 +1649,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				wait_for_serialization(rdev, r1_bio);
 		}
 
+		mbio->bi_opf &= ~REQ_NOWAIT;
 		r1_bio->bios[i] = mbio;
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..951b9b443cd1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1221,6 +1221,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->master_bio = bio;
 	}
 	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
+	read_bio->bi_opf &= ~REQ_NOWAIT;
 
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
@@ -1256,6 +1257,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 			     conf->mirrors[devnum].rdev;
 
 	mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
+	mbio->bi_opf &= ~REQ_NOWAIT;
 	if (replacement)
 		r10_bio->devs[n_copy].repl_bio = mbio;
 	else
-- 
2.39.2

