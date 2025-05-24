Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868A1DB13E;
	Sat, 24 May 2025 06:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067507; cv=none; b=nBRFDToEMucluqbrwaC45ajy7oRu+x+JVkqKx2J+mWOrIbUScCGhUsd9Pw99CzA0yNOJ2d2x+dvelWDv5/cIs1/7Zc4FSB3fzSnc4XOlA13S9VP8+Rjpodmr78tNhP0L2CBUoyrkjTeZBaMUulQ1edxsw/xpwHkj+YBg6465pgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067507; c=relaxed/simple;
	bh=Yksn/VMnec2y9uintveVhkg1+s2ouTyiPeqvkqMtvXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oroHGcgBKFzZQtMcVnQtYuCOpakI11hiXQ+pUl65V9NBjDbgBhg5Iv55TUGSyk6wk8eu0GUdb5cpyB62x4enG3+uZylD/ar7YoiWI7Zuydt0P0Tcfd/s4kjVnXzf4+D7psys4Adpsm6R/bCqcB9sHi9nQ4AFV4VsmzhOP3fwoUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b4Bfl5pXxzYQtvs;
	Sat, 24 May 2025 14:18:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F12AC1A07BB;
	Sat, 24 May 2025 14:18:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S27;
	Sat, 24 May 2025 14:18:22 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 23/23] md/md-llbitmap: add Kconfig
Date: Sat, 24 May 2025 14:13:20 +0800
Message-Id: <20250524061320.370630-24-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S27
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr1kCw43tr43CryfJr13urg_yoW7Wr1DpF
	ZxXry3Cw15JF4xXw15Ja47uF95ta1ktr9F9rn3C34ruFWUArZxtr4xGFyUJw1DWrsxJFZ8
	JF15GF9xCw1UXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new config MD_LLBITMAP is added, user can now using llbitmap to
replace the old bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig       | 11 +++++++
 drivers/md/Makefile      |  2 +-
 drivers/md/md-bitmap.h   | 13 ++++++++
 drivers/md/md-llbitmap.c | 66 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.c          |  6 ++++
 drivers/md/md.h          |  4 +--
 6 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f913579e731c..07c19b2182ca 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -52,6 +52,17 @@ config MD_BITMAP
 
 	  If unsure, say Y.
 
+config MD_LLBITMAP
+	bool "MD RAID lockless bitmap support"
+	depends on BLK_DEV_MD
+	help
+	  If you say Y here, support for the lockless write intent bitmap will
+	  be enabled.
+
+	  Note, this is an experimental feature.
+
+	  If unsure, say N.
+
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
 	depends on BLK_DEV_MD=y
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 87bdfc9fe14c..f1ca25cc1408 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,7 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o md-bitmap.o md-llbitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 linear-y       += md-linear.o
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index a9a0f6a8d96d..8b4f2068931e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -183,4 +183,17 @@ static inline void md_bitmap_exit(void)
 }
 #endif
 
+#ifdef CONFIG_MD_LLBITMAP
+int md_llbitmap_init(void);
+void md_llbitmap_exit(void);
+#else
+static inline int md_llbitmap_init(void)
+{
+	return 0;
+}
+static inline void md_llbitmap_exit(void)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 38e67d4582ad..8321dcbf1ce2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1487,4 +1487,70 @@ static struct attribute_group md_llbitmap_group = {
 	.attrs = md_llbitmap_attrs,
 };
 
+static struct bitmap_operations llbitmap_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_LLBITMAP,
+		.name	= "llbitmap",
+	},
+
+	.enabled		= llbitmap_enabled,
+	.create			= llbitmap_create,
+	.resize			= llbitmap_resize,
+	.load			= llbitmap_load,
+	.destroy		= llbitmap_destroy,
+
+	.start_write		= llbitmap_start_write,
+	.end_write		= llbitmap_end_write,
+	.start_discard		= llbitmap_start_discard,
+	.end_discard		= llbitmap_end_discard,
+	.unplug			= llbitmap_unplug,
+	.flush			= llbitmap_flush,
+
+	.start_behind_write	= llbitmap_start_behind_write,
+	.end_behind_write	= llbitmap_end_behind_write,
+	.wait_behind_writes	= llbitmap_wait_behind_writes,
+
+	.blocks_synced		= llbitmap_blocks_synced,
+	.skip_sync_blocks	= llbitmap_skip_sync_blocks,
+	.start_sync		= llbitmap_start_sync,
+	.end_sync		= llbitmap_end_sync,
+	.close_sync		= llbitmap_close_sync,
+	.cond_end_sync		= llbitmap_cond_end_sync,
+
+	.update_sb		= llbitmap_update_sb,
+	.get_stats		= llbitmap_get_stats,
+	.dirty_bits		= llbitmap_dirty_bits,
+	.write_all		= llbitmap_write_all,
+
+	.group			= &md_llbitmap_group,
+};
+
+int md_llbitmap_init(void)
+{
+	md_llbitmap_io_wq = alloc_workqueue("md_llbitmap_io",
+					 WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!md_llbitmap_io_wq)
+		return -ENOMEM;
+
+	md_llbitmap_unplug_wq = alloc_workqueue("md_llbitmap_unplug",
+					 WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+	if (!md_llbitmap_unplug_wq) {
+		destroy_workqueue(md_llbitmap_io_wq);
+		md_llbitmap_io_wq = NULL;
+		return -ENOMEM;
+	}
+
+	return register_md_submodule(&llbitmap_ops.head);
+}
+
+void md_llbitmap_exit(void)
+{
+	destroy_workqueue(md_llbitmap_io_wq);
+	md_llbitmap_io_wq = NULL;
+	destroy_workqueue(md_llbitmap_unplug_wq);
+	md_llbitmap_unplug_wq = NULL;
+	unregister_md_submodule(&llbitmap_ops.head);
+}
+
 #endif /* CONFIG_MD_LLBITMAP */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7f7914b7452..52e19344b73e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10183,6 +10183,10 @@ static int __init md_init(void)
 	if (ret)
 		return ret;
 
+	ret = md_llbitmap_init();
+	if (ret)
+		goto err_bitmap;
+
 	ret = -ENOMEM;
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
@@ -10214,6 +10218,8 @@ static int __init md_init(void)
 err_misc_wq:
 	destroy_workqueue(md_wq);
 err_wq:
+	md_llbitmap_exit();
+err_bitmap:
 	md_bitmap_exit();
 	return ret;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3adb1660c7ed..aba5f1ffcdfd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -26,7 +26,7 @@
 enum md_submodule_type {
 	MD_PERSONALITY = 0,
 	MD_CLUSTER,
-	MD_BITMAP, /* TODO */
+	MD_BITMAP,
 };
 
 enum md_submodule_id {
@@ -39,7 +39,7 @@ enum md_submodule_id {
 	ID_RAID10	= 10,
 	ID_CLUSTER,
 	ID_BITMAP,
-	ID_LLBITMAP,	/* TODO */
+	ID_LLBITMAP,
 	ID_BITMAP_NONE,
 };
 
-- 
2.39.2

