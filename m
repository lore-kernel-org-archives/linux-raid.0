Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A96143875;
	Wed, 14 Aug 2024 07:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619736; cv=none; b=RvA+fuWJUI3frgS6ncPUt30bWXCSz1DhxX7yABfP+uZQmOjqNxVXIvXYiqYR82SmTbv0PPstPzidiK/jilAaUXYJlJQB1gIAYSIqUOEkX0GeiQ2sepHQyWVRAQJIkI8RQMK346sVPf/j4+Z7cPzuuXXTJNLP9aVNXulzC3kkwY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619736; c=relaxed/simple;
	bh=5N7GpYxrlUSkabbjcRn1AqKF1nVvJqhpLJpI3gi6j38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBvTlWLuh2avwf0KBVtZUYXSkL+wTM2d0osSqy8Rfy6w+ialH/uhGLkftFBPCU1YvMWGqGetf79CiavchIlNumhfZ1+VulC5dnjv09MjbXCLdVP9Ef9JgkJGqxwgq/YrxsX7NThLlJZF2L7UpMBH/H0WGv8WBSShI/VPg5R3Qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK042Vcz4f3jJG;
	Wed, 14 Aug 2024 15:15:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 450D51A0359;
	Wed, 14 Aug 2024 15:15:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S17;
	Wed, 14 Aug 2024 15:15:31 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 13/41] md/md-bitmap: merge md_bitmap_load() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:45 +0800
Message-Id: <20240814071113.346781-14-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S17
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWUtw1UXF15WF47Aw1rXrb_yoWrJr4kpr
	sFqa45Cr43JrW3Ww1UuFyv9a4Yqw1vgrZrtrWxC34fuF93XFnxGF4FgF17tw18Ka43AFsx
	X3W5tr1UGr1xXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
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
index 9606bcafb834..0113a972e42d 100644
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
@@ -2422,7 +2421,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			if (rv)
 				goto out;
 
-			rv = md_bitmap_load(mddev);
+			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
 				md_bitmap_destroy(mddev);
@@ -2721,6 +2720,7 @@ const struct attribute_group md_bitmap_group = {
 
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
+	.load			= bitmap_load,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 4b9c22b66e65..ba912f5f3450 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -247,13 +247,13 @@ struct md_bitmap_stats {
 
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
index b32ab7ca7640..2fe25a6257e6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6303,7 +6303,8 @@ int do_md_run(struct mddev *mddev)
 	err = md_run(mddev);
 	if (err)
 		goto out;
-	err = md_bitmap_load(mddev);
+
+	err = mddev->bitmap_ops->load(mddev);
 	if (err) {
 		md_bitmap_destroy(mddev);
 		goto out;
@@ -7271,7 +7272,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		if (fd >= 0) {
 			err = mddev->bitmap_ops->create(mddev, -1);
 			if (!err)
-				err = md_bitmap_load(mddev);
+				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
 				md_bitmap_destroy(mddev);
@@ -7565,7 +7566,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_space;
 			rv = mddev->bitmap_ops->create(mddev, -1);
 			if (!rv)
-				rv = md_bitmap_load(mddev);
+				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
 				md_bitmap_destroy(mddev);
-- 
2.39.2

