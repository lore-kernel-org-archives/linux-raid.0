Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8FA18CBFB;
	Sat, 12 Apr 2025 07:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744443536; cv=none; b=KmaXRH0kazRUIz9gWIAxKQs7SCzNHZylNxK9GHEUJKfvYrG1mnwdyB7Ps2tJqQhZgvdYQ8sADHthl3Z1XTAXbsOjLhQY7Z9NODLsZoYJM1VCtCMck4pU0iFjF1OPV4Gi5jE5MM0uqYX1rbqzBcTCxoNh/qdOROosB02+YmOYB/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744443536; c=relaxed/simple;
	bh=nwRslf+nbEOJuN0PeJPlyUCOsxj3w2LWTIgmtyN1tco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HQjBXlyYFjv7Kr6qov3kyslBorlVjbtMzWQKZovnYm0dXzIMBW+6NjKEpSAOXO+cvjaupNC3STtg4SHs1ZJHuTzIoRoXGJ1/os6hem0n2Jsy4tEy9NeDMOmDMSOYRFse4K5ozqfNc33ScwaEYuONUScdm0E7e6+jV5gMVMGbEY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZZQQb2pwxz4f3jt7;
	Sat, 12 Apr 2025 15:38:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 87EF61A06DD;
	Sat, 12 Apr 2025 15:38:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CFGPpnI5n6JA--.63008S8;
	Sat, 12 Apr 2025 15:38:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 4/4] md: cleanup accounting for issued sync IO
Date: Sat, 12 Apr 2025 15:32:02 +0800
Message-Id: <20250412073202.3085138-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CFGPpnI5n6JA--.63008S8
X-Coremail-Antispam: 1UD129KBjvJXoW3Ww13JrWrJF4DJr1fJr43KFg_yoW7Zw1Upa
	9xXa4xAFWUGrWF93WDJrWDC3ZY9347KrW7ArW7u393u3WFyryDZF1UJFWYqF98AFW5urW5
	Xa4kGan8CFs7tFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's no longer used and can be removed, also remove the field
'gendisk->sync_io'.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h        | 11 -----------
 drivers/md/raid1.c     |  3 ---
 drivers/md/raid10.c    |  9 ---------
 drivers/md/raid5.c     |  8 --------
 include/linux/blkdev.h |  1 -
 5 files changed, 32 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 95cf11c4abc6..6233ec9f10a3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -716,17 +716,6 @@ static inline int mddev_trylock(struct mddev *mddev)
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
-{
-	if (blk_queue_io_stat(bdev->bd_disk->queue))
-		atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
-}
-
-static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
-{
-	md_sync_acct(bio->bi_bdev, nr_sectors);
-}
-
 struct md_personality
 {
 	struct md_submodule_head head;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index de9bccbe7337..657d481525be 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2382,7 +2382,6 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
 		submit_bio_noacct(wbio);
 	}
@@ -3055,7 +3054,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
 				read_targets--;
-				md_sync_acct_bio(bio, nr_sectors);
 				if (read_targets == 1)
 					bio->bi_opf &= ~MD_FAILFAST;
 				submit_bio_noacct(bio);
@@ -3064,7 +3062,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	} else {
 		atomic_set(&r1_bio->remaining, 1);
 		bio = r1_bio->bios[r1_bio->read_disk];
-		md_sync_acct_bio(bio, nr_sectors);
 		if (read_targets == 1)
 			bio->bi_opf &= ~MD_FAILFAST;
 		submit_bio_noacct(bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ba32bac975b8..dce06bf65016 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
 		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
 			tbio->bi_opf |= MD_FAILFAST;
@@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(tbio));
 		submit_bio_noacct(tbio);
 	}
 
@@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
 		submit_bio_noacct(wbio);
 	}
 	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(wbio2));
 		submit_bio_noacct(wbio2);
 	}
 }
@@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		r10_bio->sectors = nr_sectors;
 
 		if (bio->bi_end_io == end_sync_read) {
-			md_sync_acct_bio(bio, nr_sectors);
 			bio->bi_status = 0;
 			submit_bio_noacct(bio);
 		}
@@ -4880,7 +4873,6 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	r10_bio->sectors = nr_sectors;
 
 	/* Now submit the read */
-	md_sync_acct_bio(read_bio, r10_bio->sectors);
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
 	submit_bio_noacct(read_bio);
@@ -4940,7 +4932,6 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 
 		atomic_inc(&rdev->nr_pending);
-		md_sync_acct_bio(b, r10_bio->sectors);
 		atomic_inc(&r10_bio->remaining);
 		b->bi_next = NULL;
 		submit_bio_noacct(b);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6389383166c0..ca5b0e8ba707 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 
 		if (rdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(bi, rdev->bdev, &dev->vec, 1, op | op_flags);
@@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				submit_bio_noacct(bi);
 		}
 		if (rrdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rrdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op | op_flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e39c45bc0a97..f3a625b00734 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -182,7 +182,6 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.39.2

