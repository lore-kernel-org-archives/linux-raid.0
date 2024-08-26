Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B051465B1;
	Mon, 26 Aug 2024 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658600; cv=none; b=FkYKLJ4mDzgm0x5gebUgW2NNYG0+5dxyuRPlMJZ/tfuL15f6nXC3MvyV9i3uObIv5Yh3ySFdg46Rm+AXrWJNCYqvCNMSMw0CZceNCBS+dcOy+zpGCPLGM5e8R+5UNW2CIfdYKqpL4qkcHEJNGK39zA+dt8TjuVlkqJtMwtyDzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658600; c=relaxed/simple;
	bh=ITwCqz0sA5l6dXvDDFds7U2KSujPGX2k4RhY/aVLpdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h3Ia2ghxIdrydLhFYKb20q4CR/D/QrjSho8aRpUeRGiJGpCNwbZ1h8R7tAVxQD8lWC0ONLcFapQZCN5xugYd9GP7Htnx8RgqFG9UNXMIoMUaixm8lKWe8zQhmYAZSk5ELIMnGyedCqepemwU35dWvsWWdZUn2kTfM9P7PvqJSnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWF4ydxz4f3jjw;
	Mon, 26 Aug 2024 15:49:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8CB5C1A058E;
	Mon, 26 Aug 2024 15:49:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S21;
	Mon, 26 Aug 2024 15:49:55 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 17/42] md/md-bitmap: make md_bitmap_print_sb() internal
Date: Mon, 26 Aug 2024 15:44:27 +0800
Message-Id: <20240826074452.1490072-18-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S21
X-Coremail-Antispam: 1UD129KBjvJXoW7WryfAr1kCw1rXrWDZw43KFg_yoW8WF1xpF
	98Gwn8G3y5JF43Xw1UZryvkFyrAwsrtrZrKFyfC34ruFyUXFnxGr48K3Wqywn5Gr13JFsx
	Zrn8tryUGr1xXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

md_bitmap_print_sb() is only used inside md-bitmap.c, hence make it
static, also rename it to bitmap_print_sb.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 5 ++---
 drivers/md/md-bitmap.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0035162fe6f3..86444cbee56e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -512,8 +512,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
 }
 EXPORT_SYMBOL(md_bitmap_update_sb);
 
-/* print out the bitmap file superblock */
-void md_bitmap_print_sb(struct bitmap *bitmap)
+static void bitmap_print_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 
@@ -760,7 +759,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 			bitmap->mddev->bitmap_info.space > sectors_reserved)
 			bitmap->mddev->bitmap_info.space = sectors_reserved;
 	} else {
-		md_bitmap_print_sb(bitmap);
+		bitmap_print_sb(bitmap);
 		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
 	}
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index c0858665554e..5d5811c89b77 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -258,7 +258,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
 int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
-- 
2.39.2

