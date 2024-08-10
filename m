Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9FD18E20;
	Sat, 10 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255980; cv=none; b=pxaqxbgrBgQz8V+GsACdvfDqzEBJpj7jnsUqCLFJ3VoyGEAGjHk9yn/G8YfjUO6imfPEKgnPiMSl1mLnONj7oZ2EMY8+Jw7Z+zrp2xWJrLwEDz34O4P8UFz+r9C+vfwXVFoCJIckbqY3T7GnbuZ+6sZGpxtF3bXskZGNCimDOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255980; c=relaxed/simple;
	bh=Ub/xMJwEu+Nf5291AZMXWWXELeyrO/nsn3k8t0xpd5A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nbh6+axE5ITavjswSiX1aZokPPczYrbvHfafVNh6iMRTA1ElaYPEmg8+57Vj5S+ctWSGUOnorAOLEV6Nrhm2gId3ROxzMgwJDZFpvJrfgr1AXgfxXvWQm/ErbQijGoMrvQ3X6VAhvWd866KRnI/aUirsYpPF7bsOWwWUISGku0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknm601pz4f3jk0;
	Sat, 10 Aug 2024 10:12:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F0B0C1A0359;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S8;
	Sat, 10 Aug 2024 10:12:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 04/26] md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:32 +0800
Message-Id: <20240810020854.797814-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S8
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47GF4DCryfuw1rtrWrZrb_yoW5Jr1rpa
	nrta45Cr43JrW3Wr1UZFWq9a4FvF1ktr9rtryxGw1rCF9xJFnxGF4rWF1jyw1rGa43AFsI
	v3W5tryrWr18XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r
	1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbx9NDUUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  7 ++++---
 drivers/md/md-bitmap.h | 10 +++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9a9f0fe3ebd0..8aaf0491bf5d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1852,7 +1852,7 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 	}
 }
 
-void md_bitmap_destroy(struct mddev *mddev)
+static void bitmap_destroy(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -2366,7 +2366,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		md_bitmap_destroy(mddev);
+		bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2413,7 +2413,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				md_bitmap_destroy(mddev);
+				bitmap_destroy(mddev);
 				goto out;
 			}
 		}
@@ -2710,6 +2710,7 @@ const struct attribute_group md_bitmap_group = {
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
+	.destroy		= bitmap_destroy,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index de7fbe5903dd..46db4d8199d8 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -237,6 +237,7 @@ struct bitmap {
 struct bitmap_operations {
 	struct bitmap* (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
+	void (*destroy)(struct mddev *mddev);
 };
 
 /* the bitmap API */
@@ -259,8 +260,15 @@ static inline int md_bitmap_load(struct mddev *mddev)
 	return mddev->bitmap_ops->load(mddev);
 }
 
+static inline void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!mddev->bitmap_ops->destroy)
+		return;
+
+	mddev->bitmap_ops->destroy(mddev);
+}
+
 void md_bitmap_flush(struct mddev *mddev);
-void md_bitmap_destroy(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
-- 
2.39.2

