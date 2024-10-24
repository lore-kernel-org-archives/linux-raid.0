Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8211DD9C6;
	Thu, 24 Oct 2024 13:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775793; cv=none; b=K4tRpG7wLGCLDmDm4X0WrIXVLIVsCBUBK7GQ45cp2MQ1TynIQh3QM/h8PLGkO1s9v6BDVI3Zl1HKX3QvxSdtcew4N7TCQkWU75URelRpNcZ3sUZ3OJUhvYyrcLU5Xs5kZW8h9waDGTsoh9jIZPHH4wkw+cGdZQXjkMkIOrtBhHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775793; c=relaxed/simple;
	bh=e6xpKQqPzxCEs53Nn2VczOxVuFiYJmhAmAwhC3mHKng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=unJC3Nhy/lUfWGP4Af9Brf+/FFc87gw5dbqumr0+SVbk8BaJgN0WiyZVleyWUh3EWoaIQ1Y0ajXFakaV+miQ45AllejwpZtruckvFkMcSD0atRni/qX1Bb2sDSwlXHfIDszsF5lcC0PqiDLWuADkptsBwe2SnDfuC7OZs8dCF2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XZ5yN4n5kz4f3m85;
	Thu, 24 Oct 2024 21:15:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C5661A0359;
	Thu, 24 Oct 2024 21:16:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXysaWSBpnPGb6Ew--.10198S6;
	Thu, 24 Oct 2024 21:16:08 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC 2/4] md/md-bitmap: merge md_bitmap_group into bitmap_operations
Date: Thu, 24 Oct 2024 21:13:23 +0800
Message-Id: <20241024131325.2250880-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
References: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXysaWSBpnPGb6Ew--.10198S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy5CFWktFWrtryDKFy8Xwb_yoW5WryDpF
	ZrJFy5Zw1rJF45Xa17Z34Uua4rX3s7trZrKFWfCw1F9Fy7XF9xJr48Ga4UAwn0gFy3CFZI
	qw1Yyw1Uur18WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUFoGdUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that all bitmap implementations are internal, it doesn't make sense
to export md_bitmap_group anymore.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 5 ++++-
 drivers/md/md-bitmap.h | 2 ++
 drivers/md/md.c        | 6 +++++-
 drivers/md/md.h        | 1 -
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c5e86f9b384f..f68eb79e739d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2963,7 +2963,8 @@ static struct attribute *md_bitmap_attrs[] = {
 	&max_backlog_used.attr,
 	NULL
 };
-const struct attribute_group md_bitmap_group = {
+
+static struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
@@ -2996,6 +2997,8 @@ static struct bitmap_operations bitmap_ops = {
 	.copy_from_slot		= bitmap_copy_from_slot,
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
+
+	.group			= &md_bitmap_group,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 38425bf4a110..0c19983453c7 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -106,6 +106,8 @@ struct bitmap_operations {
 			      sector_t *hi, bool clear_bits);
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
+
+	struct attribute_group *group;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 35c2e1e761aa..aad9b87cafa0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5660,7 +5660,6 @@ static const struct attribute_group md_redundancy_group = {
 
 static const struct attribute_group *md_attr_groups[] = {
 	&md_default_group,
-	&md_bitmap_group,
 	NULL,
 };
 
@@ -5902,6 +5901,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+			pr_warn("md: cannot register extra bitmap attributes for %s\n",
+				mdname(mddev));
+
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..a53af8818923 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -753,7 +753,6 @@ struct md_sysfs_entry {
 	ssize_t (*show)(struct mddev *, char *);
 	ssize_t (*store)(struct mddev *, const char *, size_t);
 };
-extern const struct attribute_group md_bitmap_group;
 
 static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_node *sd, char *name)
 {
-- 
2.39.2

