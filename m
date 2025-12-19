Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE81E8826;
	Fri, 19 Dec 2025 09:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136758; cv=none; b=V/DnasTc2K1NG6QKyvTOeE7GogZtybjPSM47nyGHAITsSHaxsYPOYAEMVPFjCXBJPL/etnioBmZKTnfh+g/K1geIzj3k6uqTS5U3kfWGzhBSLunZGFwUDBbl/Ky9zBZIBCfmvzjXIyrD+6uVXDI49SO9zI7cEWfbKDthxNZCqbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136758; c=relaxed/simple;
	bh=mkB2sp/AKzhIhIlwUlmSpGt8WvIT0TTvH5TxYPMPXrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYsKYmffKdAngojs2LuAGBvUhiBoJwqxckDDkMVNmQcVJjONYJdvqgpvRL8a6IJAk8pry8Hs1W/cfLA9beFUt75xLJejCilbmquTDdFSGsVIyayMKDB7smYunxTfmUYhjaP4vNyKLIk12V/sFKSkKvXhMJT2ljJQpB+FtYJFpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dXj45306CzKHMVx;
	Fri, 19 Dec 2025 17:32:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6046F4057D;
	Fri, 19 Dec 2025 17:32:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPmuG0VpE9voAg--.36108S5;
	Fri, 19 Dec 2025 17:32:31 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	bugreports61@gmail.com
Subject: [PATCH 2/2] md: Fix forward incompatibility from configurable logical block size
Date: Fri, 19 Dec 2025 17:21:27 +0800
Message-Id: <20251219092127.1815922-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251219092127.1815922-1-linan666@huaweicloud.com>
References: <20251219092127.1815922-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPmuG0VpE9voAg--.36108S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy3tryUuw1xJFy3WF4UJwb_yoW5tF1fpa
	yxCF15tw47Xryfta1xAas5ua45Xw48KFWDtrZIqw4YvFy2yr1UCrs3WFyrXryYg3s7Jrn8
	XFs8trW8uFn7GFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqtCcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Commit 62ed1b582246 ("md: allow configuring logical block size") used
reserved pad to add 'logical_block_size' to metadata. RAID rejects
non-zero reserved pad, so arrays fail when rolling back to old kernels
after booting new ones.

Set 'logical_block_size' only for newly created arrays to support rollback
to old kernels. Importantly new arrays still won't work on old kernels to
prevent data loss issue from LBS changes.

For arrays created on old kernels which confirmed not to rollback,
configure LBS by echo 'enable' to md/logical_block_size.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Reported-by: BugReports <bugreports61@gmail.com>
Closes: https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com/T/#t
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7c0dd94a4d25..28c9435016fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2014,8 +2014,14 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 
 		mddev->max_disks =  (4096-256)/2;
 
-		if (!mddev->logical_block_size)
+		if (!mddev->logical_block_size) {
 			mddev->logical_block_size = le32_to_cpu(sb->logical_block_size);
+			if (!mddev->logical_block_size)
+				pr_warn("%s: echo 'enable' to md/logical_block_size to prevent data loss issue from LBS changes.\n"
+					"    Note: After enable, array will not be assembled in old kernels (<= 6.18)\n",
+					mdname(mddev));
+		}
+
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
 		    mddev->bitmap_info.file == NULL) {
@@ -5983,8 +5989,27 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->major_version == 0)
 		return -EINVAL;
 
-	if (mddev->pers)
-		return -EBUSY;
+	if (mddev->pers) {
+		if (mddev->logical_block_size)
+			return -EBUSY;
+		/*
+		 * To fix forward compatibility issues, LBS is not
+		 * configured in old kernels array (<=6.18) by default.
+		 * If the user confirms no rollback to old kernels,
+		 * enable LBS by writing "enable" — to prevent data
+		 * loss from LBS changes.
+		 */
+		if (cmd_match(buf, "enable")) {
+			mddev->logical_block_size =
+				queue_logical_block_size(mddev->gendisk->queue);
+			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+			pr_info("%s: config logical block size success, array will not be assembled in old kernels (<= 6.18)\n",
+				mdname(mddev));
+			return len;
+		} else {
+			return -EBUSY;
+		}
+	}
 
 	err = kstrtouint(buf, 10, &lbs);
 	if (err < 0)
@@ -6165,7 +6190,18 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 			mdname(mddev));
 		return -EINVAL;
 	}
-	mddev->logical_block_size = lim->logical_block_size;
+
+	/*
+	 * Fix forward compatibility issue. Only set LBS by default for
+	 * new array, mddev->events == 0 indicates the array was just
+	 * created. When assembling an array, read LBS from the superblock
+	 * instead — LBS is 0 in superblocks created by old kernels.
+	 */
+	if (!mddev->events && mddev->major_version == 1) {
+		pr_info("%s: array will not be assembled in old kernels that lack configurable lbs support (<= 6.18)\n",
+			mdname(mddev));
+		mddev->logical_block_size = lim->logical_block_size;
+	}
 
 	return 0;
 }
-- 
2.39.2

