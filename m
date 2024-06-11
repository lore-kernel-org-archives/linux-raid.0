Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C017E441;
	Tue, 11 Jun 2024 13:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112207; cv=none; b=NW8Z1FmLfH4BkSkU4t+vPZJI0RULo0IixyeCm2COFxwIYCJa2ABiCeQj0vlyjtPHJNeLuMLKFr9QB0r0izVvVo1naOdzSRw2+hG9JmSf9MfuNEnrwiVxOOc3cZ0KvG4OyjltKbrD1fa40am4gzRjrJDS3r4r9z7lNKxXPQeuMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112207; c=relaxed/simple;
	bh=2Mvq1CtAyOh7dVmzBRiuc/CmiV6WyJs/IbNluF/En8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CRux48zCTRSXjTf5doEy1Bxl3YmkcOYsfjTvzvzN3b87ZXC+oUdaBh1+PzgvuTZfgUXZSZ3rkT6xlvsFkUFvWLzzpwWG1Qvr5UD8Qc+NaEu0ZBxsqt6+yJIQslZ8ilrPYQ8KeEeE1RzYAxQbr5GfmWS10t1hZ+QsH8CT4ijH7Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W62Wr9z4f3jHh;
	Tue, 11 Jun 2024 21:23:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E00E21A0FDB;
	Tue, 11 Jun 2024 21:23:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S14;
	Tue, 11 Jun 2024 21:23:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 10/12] md: factor out helpers for different sync_action in md_do_sync()
Date: Tue, 11 Jun 2024 21:22:49 +0800
Message-Id: <20240611132251.1967786-11-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S14
X-Coremail-Antispam: 1UD129KBjvJXoWxZw45ZFW8Gw4DtFy5GF18AFb_yoWrtrWDpa
	yftFZ8GryDAFW3XwsrJ3WkZFyava40qF9rt347W345CwnxKrnxXFyFgF98Xr98C3sYyr4Y
	q3y5X3yUuF4j9w7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Make code cleaner by replacing if else if with switch, and it's more
obvious now what is doing for each sync_action. There are no
functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 123 ++++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ab492e885867..ec2ef4dd42cf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8914,6 +8914,77 @@ void md_allow_write(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
+static sector_t md_sync_max_sectors(struct mddev *mddev,
+				    enum sync_action action)
+{
+	switch (action) {
+	case ACTION_RESYNC:
+	case ACTION_CHECK:
+	case ACTION_REPAIR:
+		atomic64_set(&mddev->resync_mismatches, 0);
+		fallthrough;
+	case ACTION_RESHAPE:
+		return mddev->resync_max_sectors;
+	case ACTION_RECOVER:
+		return mddev->dev_sectors;
+	default:
+		return 0;
+	}
+}
+
+static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
+{
+	sector_t start = 0;
+	struct md_rdev *rdev;
+
+	switch (action) {
+	case ACTION_CHECK:
+	case ACTION_REPAIR:
+		return mddev->resync_min;
+	case ACTION_RESYNC:
+		if (!mddev->bitmap)
+			return mddev->recovery_cp;
+		return 0;
+	case ACTION_RESHAPE:
+		/*
+		 * If the original node aborts reshaping then we continue the
+		 * reshaping, so set again to avoid restart reshape from the
+		 * first beginning
+		 */
+		if (mddev_is_clustered(mddev) &&
+		    mddev->reshape_position != MaxSector)
+			return mddev->reshape_position;
+		return 0;
+	case ACTION_RECOVER:
+		start = MaxSector;
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev)
+			if (rdev->raid_disk >= 0 &&
+			    !test_bit(Journal, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
+			    !test_bit(In_sync, &rdev->flags) &&
+			    rdev->recovery_offset < start)
+				start = rdev->recovery_offset;
+		rcu_read_unlock();
+
+		/* If there is a bitmap, we need to make sure all
+		 * writes that started before we added a spare
+		 * complete before we start doing a recovery.
+		 * Otherwise the write might complete and (via
+		 * bitmap_endwrite) set a bit in the bitmap after the
+		 * recovery has checked that bit and skipped that
+		 * region.
+		 */
+		if (mddev->bitmap) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
+		return start;
+	default:
+		return MaxSector;
+	}
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9032,56 +9103,8 @@ void md_do_sync(struct md_thread *thread)
 		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
-	j = 0;
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		/* resync follows the size requested by the personality,
-		 * which defaults to physical size, but can be virtual size
-		 */
-		max_sectors = mddev->resync_max_sectors;
-		atomic64_set(&mddev->resync_mismatches, 0);
-		/* we don't use the checkpoint if there's a bitmap */
-		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-			j = mddev->resync_min;
-		else if (!mddev->bitmap)
-			j = mddev->recovery_cp;
-
-	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
-		max_sectors = mddev->resync_max_sectors;
-		/*
-		 * If the original node aborts reshaping then we continue the
-		 * reshaping, so set j again to avoid restart reshape from the
-		 * first beginning
-		 */
-		if (mddev_is_clustered(mddev) &&
-		    mddev->reshape_position != MaxSector)
-			j = mddev->reshape_position;
-	} else {
-		/* recovery follows the physical size of devices */
-		max_sectors = mddev->dev_sectors;
-		j = MaxSector;
-		rcu_read_lock();
-		rdev_for_each_rcu(rdev, mddev)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < j)
-				j = rdev->recovery_offset;
-		rcu_read_unlock();
-
-		/* If there is a bitmap, we need to make sure all
-		 * writes that started before we added a spare
-		 * complete before we start doing a recovery.
-		 * Otherwise the write might complete and (via
-		 * bitmap_endwrite) set a bit in the bitmap after the
-		 * recovery has checked that bit and skipped that
-		 * region.
-		 */
-		if (mddev->bitmap) {
-			mddev->pers->quiesce(mddev, 1);
-			mddev->pers->quiesce(mddev, 0);
-		}
-	}
+	max_sectors = md_sync_max_sectors(mddev, action);
+	j = md_sync_position(mddev, action);
 
 	pr_info("md: %s of RAID array %s\n", desc, mdname(mddev));
 	pr_debug("md: minimum _guaranteed_  speed: %d KB/sec/disk.\n", speed_min(mddev));
-- 
2.39.2

