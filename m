Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0A928F53B;
	Tue,  6 May 2025 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746495154; cv=none; b=VHjXPG3xmflod6BdvmAicVxtZ9OQlCS6ocaF97gtihAcAKXPCKfbtkrSNcTGn7OxFchv+nOc6JdzoROHbWox6ayglyGTgwehZaM0/czOH5XGuJYP+U9Ytxw4W8ZdOuIrGcTLNTp7UPC6xpbCbw2TK2I/DRvxu+a7+SbVlx61eqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746495154; c=relaxed/simple;
	bh=JEVdDGwP/mUWnGIERoQTcQqBFyxqChOa3pFWAK5hTpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ecAs2hSzJlAhmQqPwD+cudZtb7Qq7zQYjAPyYRY8y/GVq79+YpTNU99i1D0XYwqQzOw7LHLvvQo3tNSiEOJBw6RO3DR/w112p572G0Z7vi1JbnLvkenKdvjw3YPd5x7x3wvqlniXK88vVZ1hXzGGie9cR6kr4dC5odukVgSVkp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zs1992wNGzYQtwr;
	Tue,  6 May 2025 09:32:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C2E7B1A1432;
	Tue,  6 May 2025 09:32:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB32l6pZhlomhpALg--.25912S4;
	Tue, 06 May 2025 09:32:27 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v6.1] md: move initialization and destruction of 'io_acct_set' to md.c
Date: Tue,  6 May 2025 09:24:17 +0800
Message-Id: <20250506012417.312790-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l6pZhlomhpALg--.25912S4
X-Coremail-Antispam: 1UD129KBjvJXoW3JFW5JFWfZr1furWrtFy5Arb_yoW3tw17pa
	1SgasYgr4FqrWSqa1DA3yv9a4Fqrn7Kr97trW7J348Ar4xAr4DG3W5WFyFvryDJ3yrCr13
	Zw4rKFWUuF17K3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoWlkDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit c567c86b90d4715081adfe5eb812141a5b6b4883 upstream.

'io_acct_set' is only used for raid0 and raid456, prepare to use it for
raid1 and raid10, so that io accounting from different levels can be
consistent.

By the way, follow up patches will also use this io clone mechanism to
make sure 'active_io' represents in flight io, not io that is dispatching,
so that mddev_suspend will wait for io to be done as designed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230621165110.1498313-2-yukuai1@huaweicloud.com
[Yu Kuai: This is the relied patch for commit 4a05f7ae3371 ("md/raid10:
fix missing discard IO accounting"), kernel will panic while issuing
discard to raid10 without this patch]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c    | 27 ++++++++++-----------------
 drivers/md/md.h    |  2 --
 drivers/md/raid0.c | 16 ++--------------
 drivers/md/raid5.c | 41 +++++++++++------------------------------
 4 files changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d5fbccc72810..a9fcfcbc2d11 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5965,6 +5965,13 @@ int md_run(struct mddev *mddev)
 			goto exit_bio_set;
 	}
 
+	if (!bioset_initialized(&mddev->io_acct_set)) {
+		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
+				  offsetof(struct md_io_acct, bio_clone), 0);
+		if (err)
+			goto exit_sync_set;
+	}
+
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
 	if (!pers || !try_module_get(pers->owner)) {
@@ -6142,6 +6149,8 @@ int md_run(struct mddev *mddev)
 	module_put(pers->owner);
 	md_bitmap_destroy(mddev);
 abort:
+	bioset_exit(&mddev->io_acct_set);
+exit_sync_set:
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
 	bioset_exit(&mddev->bio_set);
@@ -6374,6 +6383,7 @@ static void __md_stop(struct mddev *mddev)
 	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_acct_set);
 }
 
 void md_stop(struct mddev *mddev)
@@ -8744,23 +8754,6 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
-int acct_bioset_init(struct mddev *mddev)
-{
-	int err = 0;
-
-	if (!bioset_initialized(&mddev->io_acct_set))
-		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
-			offsetof(struct md_io_acct, bio_clone), 0);
-	return err;
-}
-EXPORT_SYMBOL_GPL(acct_bioset_init);
-
-void acct_bioset_exit(struct mddev *mddev)
-{
-	bioset_exit(&mddev->io_acct_set);
-}
-EXPORT_SYMBOL_GPL(acct_bioset_exit);
-
 static void md_end_io_acct(struct bio *bio)
 {
 	struct md_io_acct *md_io_acct = bio->bi_private;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4f0b48097455..1fda5e139beb 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,8 +746,6 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
-int acct_bioset_init(struct mddev *mddev);
-void acct_bioset_exit(struct mddev *mddev);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7c6a0b4437d8..c50a7abda744 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -377,7 +377,6 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	struct r0conf *conf = priv;
 
 	free_conf(mddev, conf);
-	acct_bioset_exit(mddev);
 }
 
 static int raid0_run(struct mddev *mddev)
@@ -392,16 +391,11 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	if (acct_bioset_init(mddev)) {
-		pr_err("md/raid0:%s: alloc acct bioset failed.\n", mdname(mddev));
-		return -ENOMEM;
-	}
-
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
 		if (ret < 0)
-			goto exit_acct_set;
+			return ret;
 		mddev->private = conf;
 	}
 	conf = mddev->private;
@@ -432,15 +426,9 @@ static int raid0_run(struct mddev *mddev)
 
 	ret = md_integrity_register(mddev);
 	if (ret)
-		goto free;
+		free_conf(mddev, conf);
 
 	return ret;
-
-free:
-	free_conf(mddev, conf);
-exit_acct_set:
-	acct_bioset_exit(mddev);
-	return ret;
 }
 
 /*
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4315dabd3202..6e80a439ec45 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7770,19 +7770,12 @@ static int raid5_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
 	sector_t reshape_offset = 0;
-	int i, ret = 0;
+	int i;
 	long long min_offset_diff = 0;
 	int first = 1;
 
-	if (acct_bioset_init(mddev)) {
-		pr_err("md/raid456:%s: alloc acct bioset failed.\n", mdname(mddev));
+	if (mddev_init_writes_pending(mddev) < 0)
 		return -ENOMEM;
-	}
-
-	if (mddev_init_writes_pending(mddev) < 0) {
-		ret = -ENOMEM;
-		goto exit_acct_set;
-	}
 
 	if (mddev->recovery_cp != MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
@@ -7813,8 +7806,7 @@ static int raid5_run(struct mddev *mddev)
 	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
 		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
 			  mdname(mddev));
-		ret = -EINVAL;
-		goto exit_acct_set;
+		return -EINVAL;
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -7839,15 +7831,13 @@ static int raid5_run(struct mddev *mddev)
 		if (journal_dev) {
 			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 
 		if (mddev->new_level != mddev->level) {
 			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
 		/* reshape_position must be on a new-stripe boundary, and one
@@ -7863,8 +7853,7 @@ static int raid5_run(struct mddev *mddev)
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
 			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		reshape_offset = here_new * chunk_sectors;
 		/* here_new is the stripe we will write to */
@@ -7886,8 +7875,7 @@ static int raid5_run(struct mddev *mddev)
 			else if (mddev->ro == 0) {
 				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
 					mdname(mddev));
-				ret = -EINVAL;
-				goto exit_acct_set;
+				return -EINVAL;
 			}
 		} else if (mddev->reshape_backwards
 		    ? (here_new * chunk_sectors + min_offset_diff <=
@@ -7897,8 +7885,7 @@ static int raid5_run(struct mddev *mddev)
 			/* Reading from the same stripe as writing to - bad */
 			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
 				mdname(mddev));
-			ret = -EINVAL;
-			goto exit_acct_set;
+			return -EINVAL;
 		}
 		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
@@ -7922,10 +7909,8 @@ static int raid5_run(struct mddev *mddev)
 	else
 		conf = mddev->private;
 
-	if (IS_ERR(conf)) {
-		ret = PTR_ERR(conf);
-		goto exit_acct_set;
-	}
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		if (!journal_dev) {
@@ -8125,10 +8110,7 @@ static int raid5_run(struct mddev *mddev)
 	free_conf(conf);
 	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
-	ret = -EIO;
-exit_acct_set:
-	acct_bioset_exit(mddev);
-	return ret;
+	return -EIO;
 }
 
 static void raid5_free(struct mddev *mddev, void *priv)
@@ -8136,7 +8118,6 @@ static void raid5_free(struct mddev *mddev, void *priv)
 	struct r5conf *conf = priv;
 
 	free_conf(conf);
-	acct_bioset_exit(mddev);
 	mddev->to_remove = &raid5_attrs_group;
 }
 
-- 
2.39.2

