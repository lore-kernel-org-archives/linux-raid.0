Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD308146D59;
	Mon, 26 Aug 2024 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658601; cv=none; b=lObRHh7ql4FhwtynXYIMuhqiMWBX8pU1C4KyTzAsTpOO6DLz/LMLTA8lSBMomGVHsW232eAoY8BT0liWUA2qW79l8tSGNY4o4Q89Yadfz34l2q1j91dfaZRepeH37FmnTTe6NGkwMtSa/cyGINM+0Mr/rlAy3M3rExaMXfkO+TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658601; c=relaxed/simple;
	bh=QPraFIGGdf1VAj556NxPyVNMWC4BYAGNVynMxjpbnzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oL81OYDlx4/itcqN3E/3Xiuvzmbf3h70d/JTDrbE2QzmHS6qyDlP+xOWS8bT5qtohEdZfM0wt0AQtB0KKEiOfqSUIPN9ncfVdK31D1ZqnByoTOAiVgn5w5sbmr3IUTyE9D0zFawg9cBhqRO00jtXkpBGddZThvPW2HHA30Fiprg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW84nV5z4f3jLy;
	Mon, 26 Aug 2024 15:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 244481A1682;
	Mon, 26 Aug 2024 15:49:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S20;
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
Subject: [PATCH md-6.12 v2 16/42] md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:26 +0800
Message-Id: <20240826074452.1490072-17-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S20
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Cr4fAFWDWryDXry5urg_yoW8tr45pF
	Z7ta45Cr45JrWaqw1UZrykCa4Yq3Z7trZrtFyfCw4ruFy5XFn8GF4rWayUJwn5W3W3JFsI
	vw45tryUWr18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c | 6 ++----
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index dc898db266d0..0035162fe6f3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1773,10 +1773,7 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 	}
 }
 
-/*
- * flush out any pending updates
- */
-void md_bitmap_flush(struct mddev *mddev)
+static void bitmap_flush(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 	long sleep;
@@ -2725,6 +2722,7 @@ static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
+	.flush			= bitmap_flush,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index c8d27b91241b..c0858665554e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -250,13 +250,13 @@ struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
+	void (*flush)(struct mddev *mddev);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-void md_bitmap_flush(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 15e830641c0c..46ffba143990 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6463,7 +6463,8 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
-	md_bitmap_flush(mddev);
+
+	mddev->bitmap_ops->flush(mddev);
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.39.2

