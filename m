Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8AA1B983F;
	Mon,  7 Jul 2025 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851963; cv=none; b=JDDe6L24G7uW27KphYbdF7R0hwPlE4+jgxnM7E3Ll3gdIYIKWplsIE3zVLS8hKyeZJ4RHTD5+WESWG0YDAqSjGY5oHdebE6EMHlfWPebWMWndSHS589JJsqvlPOhdwgpWu5Pu01+f/WED9iI0zWzez5+V+GZoe0osArPzrCJ7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851963; c=relaxed/simple;
	bh=MidPMLWlgoLJE4H68Ndj32hIGOHlav/sP+7iUTFZVt0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TRlH/XmVKdvdEP7NFSFHGdEe0or9oLItDnE19vZ20HeULM6NRF5JfXBq5+Mn3DnUrKkydaxe/EnyQefHos1HuZwq1ASfxEzPV8Xo42NG+UbMA9m+C3d/o/3fLei8p8Q83JZbkGbe4Ypls5iSI34qFcrmsjNvnssz5NfHSZyPF7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dl3g9dzYQtrm;
	Mon,  7 Jul 2025 09:32:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 57BC51A1239;
	Mon,  7 Jul 2025 09:32:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S5;
	Mon, 07 Jul 2025 09:32:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 01/15] md/raid1: change r1conf->r1bio_pool to a pointer type
Date: Mon,  7 Jul 2025 09:26:57 +0800
Message-Id: <20250707012711.376844-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S5
X-Coremail-Antispam: 1UD129KBjvJXoWxtF1xCr17WrWkAw43trWfGrg_yoW7WFWxpa
	13X3s3Gr4UZrZ3Cr4UJF4DuFyFv3ZagFWxtFWxJa1FvFnYqryrX3WUCry5GryqvFWkKrsr
	JF98trZxZF17trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU4OJ5UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

In raid1_reshape(), newpool is a stack variable.
mempool_init() initializes newpool->wait with the stack address.
After assigning newpool to conf->r1bio_pool, the wait queue
need to be reinitialized, which is not ideal.

Change raid1_conf->r1bio_pool to a pointer type and
replace mempool_init() with mempool_create_kmalloc_pool() to
avoid referencing a stack-based wait queue.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 39 ++++++++++++++++++---------------------
 drivers/md/raid1.h |  2 +-
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd4ce2a4136f..8249cbb89fec 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -255,7 +255,7 @@ static void free_r1bio(struct r1bio *r1_bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 
 	put_all_bios(conf, r1_bio);
-	mempool_free(r1_bio, &conf->r1bio_pool);
+	mempool_free(r1_bio, conf->r1bio_pool);
 }
 
 static void put_buf(struct r1bio *r1_bio)
@@ -1305,9 +1305,8 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio)
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 
-	r1_bio = mempool_alloc(&conf->r1bio_pool, GFP_NOIO);
-	/* Ensure no bio records IO_BLOCKED */
-	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
+	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+	memset(r1_bio, 0, offsetof(struct r1bio, bios[conf->raid_disks * 2]));
 	init_r1bio(r1_bio, mddev, bio);
 	return r1_bio;
 }
@@ -3084,6 +3083,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	int i;
 	struct raid1_info *disk;
 	struct md_rdev *rdev;
+	size_t r1bio_size;
 	int err = -ENOMEM;
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
@@ -3124,9 +3124,10 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->poolinfo)
 		goto abort;
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
-	err = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, conf->poolinfo);
-	if (err)
+
+	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
+	conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS, r1bio_size);
+	if (!conf->r1bio_pool)
 		goto abort;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
@@ -3197,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
  abort:
 	if (conf) {
-		mempool_exit(&conf->r1bio_pool);
+		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
@@ -3310,7 +3311,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 {
 	struct r1conf *conf = priv;
 
-	mempool_exit(&conf->r1bio_pool);
+	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
 	safe_put_page(conf->tmppage);
 	kfree(conf->poolinfo);
@@ -3366,17 +3367,14 @@ static int raid1_reshape(struct mddev *mddev)
 	 * At the same time, we "pack" the devices so that all the missing
 	 * devices have the higher raid_disk numbers.
 	 */
-	mempool_t newpool, oldpool;
+	mempool_t *newpool, *oldpool;
 	struct pool_info *newpoolinfo;
+	size_t new_r1bio_size;
 	struct raid1_info *newmirrors;
 	struct r1conf *conf = mddev->private;
 	int cnt, raid_disks;
 	unsigned long flags;
 	int d, d2;
-	int ret;
-
-	memset(&newpool, 0, sizeof(newpool));
-	memset(&oldpool, 0, sizeof(oldpool));
 
 	/* Cannot change chunk_size, layout, or level */
 	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
@@ -3408,18 +3406,18 @@ static int raid1_reshape(struct mddev *mddev)
 	newpoolinfo->mddev = mddev;
 	newpoolinfo->raid_disks = raid_disks * 2;
 
-	ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
-			   rbio_pool_free, newpoolinfo);
-	if (ret) {
+	new_r1bio_size = offsetof(struct r1bio, bios[raid_disks * 2]);
+	newpool = mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
+	if (!newpool) {
 		kfree(newpoolinfo);
-		return ret;
+		return -ENOMEM;
 	}
 	newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
 					 raid_disks, 2),
 			     GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
-		mempool_exit(&newpool);
+		mempool_destroy(newpool);
 		return -ENOMEM;
 	}
 
@@ -3428,7 +3426,6 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
-	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
@@ -3460,7 +3457,7 @@ static int raid1_reshape(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 
-	mempool_exit(&oldpool);
+	mempool_destroy(oldpool);
 	return 0;
 }
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 33f318fcc268..652c347b1a70 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -118,7 +118,7 @@ struct r1conf {
 	 * mempools - it changes when the array grows or shrinks
 	 */
 	struct pool_info	*poolinfo;
-	mempool_t		r1bio_pool;
+	mempool_t		*r1bio_pool;
 	mempool_t		r1buf_pool;
 
 	struct bio_set		bio_split;
-- 
2.39.2

