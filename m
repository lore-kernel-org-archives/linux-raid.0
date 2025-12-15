Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355F9284B3B;
	Mon, 15 Dec 2025 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768546; cv=none; b=I/VWYHVWsVZSQ72aMZN3dlz/cYDJk/07CBKrXJoiTrmXfR60Fkzes9sqaS3SrgL1EGMX/JMPyxuadCR0SUEo1Robt5IuJtPb3VF4KJJMIRTQEJtJENyjLocw2wvdjozNHP5j52Pa+7QmJwqNWk8VXPvf2XCezWmuGMhwANkzmIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768546; c=relaxed/simple;
	bh=pJM+D0fSLSNXARqKh17851HPswsmwNXuyFHbAVtTQWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o63oc7NYLzd9TKUNi+9s/rUhUKbRnehonM/D6RLpuMIrxUvPXMFRNsg6tZy7hV/ytRlZMUE58HbXJs17nI44gAetZ+ycEFxB75UWK3a9mjTlVn+XgCjcRGk5MtCbqFCtgJhbhHOzZDc/MsrsqYr/gJLgIk2bu6gdRHfT9BMZPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dV4v65W6kzKHMPr;
	Mon, 15 Dec 2025 11:15:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3D6C21A01A5;
	Mon, 15 Dec 2025 11:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S16;
	Mon, 15 Dec 2025 11:15:36 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 12/13] md/raid10: cleanup skip handling in raid10_sync_request
Date: Mon, 15 Dec 2025 11:04:43 +0800
Message-Id: <20251215030444.1318434-13-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S16
X-Coremail-Antispam: 1UD129KBjvJXoWxKw4UXFyrGw1UZFy7Zry7ZFb_yoWxGw4fpa
	nxJFZrt3y8X3yrJwn8AryUWFyFyryfJay5tr47W34Ikwn5KrsrZFW8XF40qFyDWFyrXF15
	Xw4DXr45CasxtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQqX
	LUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Skip a sector in raid10_sync_request() when it needs no syncing or no
readable device exists. Current skip handling is unnecessary:

- Use 'skip' label to reissue the next sector instead of return directly
- Complete sync and return 'max_sectors' when multiple sectors are skipped
  due to badblocks

The first is error-prone. For example, commit bc49694a9e8f ("md: pass in
max_sectors for pers->sync_request()") removed redundant max_sector
assignments. Since skip modifies max_sectors, `goto skip` leaves
max_sectors equal to sector_nr after the jump, which is incorrect.

The second causes sync to complete erroneously when no actual sync occurs.
For recovery, recording badblocks and continue syncing subsequent sectors
is more suitable. For resync, just skip bad sectors and syncing subsequent
sectors.

Clean up complex and unnecessary skip code. Return immediately when a
sector should be skipped. Reduce code paths and lower regression risk.

Fixes: bc49694a9e8f ("md: pass in max_sectors for pers->sync_request()")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 96 +++++++++++----------------------------------
 1 file changed, 22 insertions(+), 74 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 67955609ee14..d4af26487791 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3179,11 +3179,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int i;
 	int max_sync;
 	sector_t sync_blocks;
-	sector_t sectors_skipped = 0;
-	int chunks_skipped = 0;
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
-	int error_disk = -1;
 
 	/*
 	 * Allow skipping a full rebuild for incremental assembly
@@ -3204,7 +3201,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (init_resync(conf))
 			return 0;
 
- skipped:
 	if (sector_nr >= max_sector) {
 		conf->cluster_sync_low = 0;
 		conf->cluster_sync_high = 0;
@@ -3256,33 +3252,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			mddev->bitmap_ops->close_sync(mddev);
 		close_sync(conf);
 		*skipped = 1;
-		return sectors_skipped;
+		return 0;
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return reshape_request(mddev, sector_nr, skipped);
 
-	if (chunks_skipped >= conf->geo.raid_disks) {
-		pr_err("md/raid10:%s: %s fails\n", mdname(mddev),
-			test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?  "resync" : "recovery");
-		if (error_disk >= 0 &&
-		    !test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			/*
-			 * recovery fails, set mirrors.recovery_disabled,
-			 * device shouldn't be added to there.
-			 */
-			conf->mirrors[error_disk].recovery_disabled =
-						mddev->recovery_disabled;
-			return 0;
-		}
-		/*
-		 * if there has been nothing to do on any drive,
-		 * then there is nothing to do at all.
-		 */
-		*skipped = 1;
-		return (max_sector - sector_nr) + sectors_skipped;
-	}
-
 	if (max_sector > mddev->resync_max)
 		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 
@@ -3365,7 +3340,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				/* yep, skip the sync_blocks here, but don't assume
 				 * that there will never be anything to do here
 				 */
-				chunks_skipped = -1;
 				continue;
 			}
 			if (mrdev)
@@ -3496,29 +3470,19 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
-					if (mrdev && !test_bit(In_sync,
-						      &mrdev->flags)
-					    && !rdev_set_badblocks(
-						    mrdev,
-						    r10_bio->devs[k].addr,
-						    max_sync, 0))
-						any_working = 0;
-					if (mreplace &&
-					    !rdev_set_badblocks(
-						    mreplace,
-						    r10_bio->devs[k].addr,
-						    max_sync, 0))
-						any_working = 0;
-				}
-				if (!any_working)  {
-					if (!test_and_set_bit(MD_RECOVERY_INTR,
-							      &mddev->recovery))
-						pr_warn("md/raid10:%s: insufficient working devices for recovery.\n",
-						       mdname(mddev));
-					mirror->recovery_disabled
-						= mddev->recovery_disabled;
-				} else {
-					error_disk = i;
+					if (mrdev &&
+					    !test_bit(In_sync, &mrdev->flags))
+						rdev_set_badblocks(
+							mrdev,
+							r10_bio->devs[k].addr,
+							max_sync, 0);
+					if (mreplace)
+						rdev_set_badblocks(
+							mreplace,
+							r10_bio->devs[k].addr,
+							max_sync, 0);
+					pr_warn("md/raid10:%s: cannot recovery sector %llu + %d.\n",
+						mdname(mddev), r10_bio->devs[k].addr, max_sync);
 				}
 				put_buf(r10_bio);
 				if (rb2)
@@ -3559,7 +3523,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				rb2->master_bio = NULL;
 				put_buf(rb2);
 			}
-			goto giveup;
+			*skipped = 1;
+			return max_sync;
 		}
 	} else {
 		/* resync. Schedule a read for every block at this virt offset */
@@ -3583,7 +3548,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						 &mddev->recovery)) {
 			/* We can skip this block */
 			*skipped = 1;
-			return sync_blocks + sectors_skipped;
+			return sync_blocks;
 		}
 		if (sync_blocks < max_sync)
 			max_sync = sync_blocks;
@@ -3675,8 +3640,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						mddev);
 			}
 			put_buf(r10_bio);
-			biolist = NULL;
-			goto giveup;
+			*skipped = 1;
+			return max_sync;
 		}
 	}
 
@@ -3696,7 +3661,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
 				bio->bi_status = BLK_STS_RESOURCE;
 				bio_endio(bio);
-				goto giveup;
+				*skipped = 1;
+				return max_sync;
 			}
 		}
 		nr_sectors += len>>9;
@@ -3764,25 +3730,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 	}
 
-	if (sectors_skipped)
-		/* pretend they weren't skipped, it makes
-		 * no important difference in this case
-		 */
-		md_done_sync(mddev, sectors_skipped);
-
-	return sectors_skipped + nr_sectors;
- giveup:
-	/* There is nowhere to write, so all non-sync
-	 * drives must be failed or in resync, all drives
-	 * have a bad block, so try the next chunk...
-	 */
-	if (sector_nr + max_sync < max_sector)
-		max_sector = sector_nr + max_sync;
-
-	sectors_skipped += (max_sector - sector_nr);
-	chunks_skipped ++;
-	sector_nr = max_sector;
-	goto skipped;
+	return nr_sectors;
 }
 
 static sector_t
-- 
2.39.2

