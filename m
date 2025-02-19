Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52CA1C760D;
	Wed, 19 Feb 2025 08:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954324; cv=none; b=Egbfbq7gOKyfYYABzcVNFIzEkEN7ZdKPe5fEvfTGaM6W+rYADq5FBm+QZqsJOlohyiTOLzf2G7VNps3VfH7sKt42QM8S5afE4ESHgmAoaoYddv+LRzHafJl3UN73fXotfIdG9IaZYXigKARv1jjGZOIw27W1DHkSc0bRTdLtTzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954324; c=relaxed/simple;
	bh=qzGa7Wvf0L6fskDeh67YcmARigHHfqduEUwCEn60IPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kb0HYmZR9UXe7mH2+L6GPfV5PRbh3VuOh9lhOSnxhXpK2EN37Lg56pojTae8FmI+neDHFvMLfZ/Yp6Hc0Nl8pgpg+IBLObgXiZSOcEr3FzVN045QWVTvlrb1fvc0Y3HWzyXgLWt6amEJQUbCBvK2F0NJGzoeXs78Rc7Oep5Xfbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YyVCg3v8Kz4f3jt3;
	Wed, 19 Feb 2025 16:38:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CF5841A0F6F;
	Wed, 19 Feb 2025 16:38:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S12;
	Wed, 19 Feb 2025 16:38:39 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 08/11] md/raid10: check before referencing mddev->bitmap_ops
Date: Wed, 19 Feb 2025 16:34:53 +0800
Message-Id: <20250219083456.941760-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219083456.941760-1-yukuai1@huaweicloud.com>
References: <20250219083456.941760-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S12
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4DJF13Wry8ZrW8Gry7Awb_yoW5JrWfp3
	9rtFy3tryUCrWaga15AFyku3WFv3s7tr9rtFyfWw1xGrn7GrnrJF4rWFWjqF1jva4rAF15
	X3yDtr45CF13WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid10.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 82ff326d56aa..cba1f3c8dbda 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3255,7 +3255,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 			conf->fullsync = 0;
 		}
-		mddev->bitmap_ops->close_sync(mddev);
+		if (md_bitmap_enabled(mddev))
+			mddev->bitmap_ops->close_sync(mddev);
 		close_sync(conf);
 		*skipped = 1;
 		return sectors_skipped;
@@ -3574,7 +3575,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * safety reason, which ensures curr_resync_completed is
 		 * updated in bitmap_cond_end_sync.
 		 */
-		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
+		if (md_bitmap_enabled(mddev))
+			mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
@@ -4230,7 +4232,6 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	 */
 	struct r10conf *conf = mddev->private;
 	sector_t oldsize, size;
-	int ret;
 
 	if (mddev->reshape_position != MaxSector)
 		return -EBUSY;
@@ -4244,9 +4245,12 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > size)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, size, 0);
-	if (ret)
-		return ret;
+	if (md_bitmap_enabled(mddev)) {
+		int ret = mddev->bitmap_ops->resize(mddev, size, 0);
+
+		if (ret)
+			return ret;
+	}
 
 	md_set_array_sectors(mddev, size);
 	if (sectors > mddev->dev_sectors &&
@@ -4512,7 +4516,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		oldsize = raid10_size(mddev, 0, 0);
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
-		if (!mddev_is_clustered(mddev)) {
+		if (!mddev_is_clustered(mddev) && md_bitmap_enabled(mddev)) {
 			ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 			if (ret)
 				goto abort;
@@ -4535,6 +4539,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
+		/* cluster can't be setup without bitmap */
 		ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 		if (ret)
 			goto abort;
-- 
2.39.2

