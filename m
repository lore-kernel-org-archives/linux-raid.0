Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E34F143C70;
	Mon, 26 Aug 2024 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658598; cv=none; b=cRoRbyDM9lKNZVmWwZXq9mAVnpGNP16aCZMLwdTX3yU+61s0jEFGYFb8LvuQFbF3qL5K6EnGbG42ngSnvt90JbV4erlKUCZsZeBgPhAVml8b3mKsAUoh06WhVWZ4ESanFGB0Z9Ta4Ud1MtF5wF7RDyCNLX+y4zIjaqz30mjBFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658598; c=relaxed/simple;
	bh=S7Rk4gk333xtqt1WdIodWOuQxScCnEJTG+Mw+bX0doE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GEthju5+AHu8OXLrf8XscYuRvUxa/suz6MCQ+9thtNnmf4EbxWJIRl2aRJEEyKKeWs2Fes/MWj/aYZUiewmvtsOsHuejXDxLP3i/MgfdnsYk+4ftEaqfJiKxabZolb2CwGI8/8h/4qt1eiXKZUjFaeqchkFyPcCTRsmbFskj2vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWD3Blpz4f3jk1;
	Mon, 26 Aug 2024 15:49:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4FCD01A018D;
	Mon, 26 Aug 2024 15:49:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S18;
	Mon, 26 Aug 2024 15:49:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 14/42] md/md-bitmap: merge md_bitmap_load() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:24 +0800
Message-Id: <20240826074452.1490072-15-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S18
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWUtw1UXF15WF47Zry8AFb_yoWrJr4kpr
	sFqa45Cr43JrW3Ww1UuFyv9a4Fqw1vgrZrtrWxGw1fuF93JFnxGF4FgF17tw18Ka43AFsx
	Xw15tr1UGr1xXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c   | 4 +++-
 drivers/md/md-bitmap.c | 6 +++---
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 7 ++++---
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0c3323e0adb2..c3e201fde4c5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3949,7 +3949,9 @@ static int __load_dirty_region_bitmap(struct raid_set *rs)
 	/* Try loading the bitmap unless "raid0", which does not have one */
 	if (!rs_is_raid0(rs) &&
 	    !test_and_set_bit(RT_FLAG_RS_BITMAP_LOADED, &rs->runtime_flags)) {
-		r = md_bitmap_load(&rs->md);
+		struct mddev *mddev = &rs->md;
+
+		r = mddev->bitmap_ops->load(mddev);
 		if (r)
 			DMERR("Failed to load bitmap");
 	}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c534382f0b57..c236754df66e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1977,7 +1977,7 @@ static int bitmap_create(struct mddev *mddev, int slot)
 	return 0;
 }
 
-int md_bitmap_load(struct mddev *mddev)
+static int bitmap_load(struct mddev *mddev)
 {
 	int err = 0;
 	sector_t start = 0;
@@ -2033,7 +2033,6 @@ int md_bitmap_load(struct mddev *mddev)
 out:
 	return err;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_load);
 
 /* caller need to free returned bitmap with md_bitmap_free() */
 struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
@@ -2425,7 +2424,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			if (rv)
 				goto out;
 
-			rv = md_bitmap_load(mddev);
+			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
 				md_bitmap_destroy(mddev);
@@ -2724,6 +2723,7 @@ const struct attribute_group md_bitmap_group = {
 
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
+	.load			= bitmap_load,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f4c4925102b6..f5b04b61d9e9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -248,13 +248,13 @@ struct md_bitmap_stats {
 
 struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
+	int (*load)(struct mddev *mddev);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-int md_bitmap_load(struct mddev *mddev);
 void md_bitmap_flush(struct mddev *mddev);
 void md_bitmap_destroy(struct mddev *mddev);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f766f5b8d2d3..ff59826aa192 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6316,7 +6316,8 @@ int do_md_run(struct mddev *mddev)
 	err = md_run(mddev);
 	if (err)
 		goto out;
-	err = md_bitmap_load(mddev);
+
+	err = mddev->bitmap_ops->load(mddev);
 	if (err) {
 		md_bitmap_destroy(mddev);
 		goto out;
@@ -7284,7 +7285,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		if (fd >= 0) {
 			err = mddev->bitmap_ops->create(mddev, -1);
 			if (!err)
-				err = md_bitmap_load(mddev);
+				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
 				md_bitmap_destroy(mddev);
@@ -7578,7 +7579,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_space;
 			rv = mddev->bitmap_ops->create(mddev, -1);
 			if (!rv)
-				rv = md_bitmap_load(mddev);
+				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
 				md_bitmap_destroy(mddev);
-- 
2.39.2

