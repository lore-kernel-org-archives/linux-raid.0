Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541A4354AEF;
	Wed, 17 Dec 2025 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765977639; cv=none; b=pm+iNhM+mQ7BnUAOuY6SL9iWL6W+V/hChgGHvc9vHWgZsvR7hGWst0QBlAcYpweEmn6jPeBywtlaG23Xh26fdEngYny/7zXCOCx7kTH1u6/sV9eFeER/UmBupyX5C+dWslfwG31i8GuvB+7WdBs+AexB92L+Upi8Fi/U8sWn3NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765977639; c=relaxed/simple;
	bh=+tMzvd0ovtwGOkoVNCGKoezzLbdDwYNhBefq8E+muJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SaKEVWrkGgkBL7DwviCbSxaGOtUzxKG+/+F/D4dXHzOGZlqMwTcemarsZ86m7nxLAuHExiLYeGVzvQXPmkF9z8bLmLwK4KnCABtz+k85PC+GebkraWKhYuWYWUhC+tYkW1papJh3WF9ub8i3kwBr5Iloou2cJPbCnEL+l2BHlcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dWZCn688dzYQtlg;
	Wed, 17 Dec 2025 21:20:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C261D40573;
	Wed, 17 Dec 2025 21:20:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgDXOPkgrkJpEuYOAg--.54819S4;
	Wed, 17 Dec 2025 21:20:32 +0800 (CST)
From: linan666@huaweicloud.com
To: stable@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH stable/6.16-5.15] md: add check_new_feature module parameter
Date: Wed, 17 Dec 2025 21:09:35 +0800
Message-Id: <20251217130935.2712267-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOPkgrkJpEuYOAg--.54819S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4UJr1xtFWDtrWxXr4xWFg_yoW8Kw17pa
	1rWryaqrW7Xw12vFZ2qr18uFyrJ397tay2qrW5A34fuw1UGryrArWSk3yFqryq9ry5ZFWI
	gF4j93Wxuw1xCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14
	v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUb-eOJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.

Raid checks if pad3 is zero when loading superblock from disk. Arrays
created with new features may fail to assemble on old kernels as pad3
is used.

Add module parameter check_new_feature to bypass this check.

Link: https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
[ Conflict in md.c, because of a difference in the context,
  introduced by commit 25db5f284fb8 ("md: add legacy_async_del_gendisk
  mode"), which is not in this version. The same lines can still be
  added at the same place. ]
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f41573fa9f5..4bcbd2ed439e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -339,6 +339,7 @@ static int start_readonly;
  * so all the races disappear.
  */
 static bool create_on_open = true;
+static bool check_new_feature = true;
 
 /*
  * We have a system wide 'event count' that is incremented
@@ -1735,9 +1736,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	}
 	if (sb->pad0 ||
 	    sb->pad3[0] ||
-	    memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1])))
-		/* Some padding is non-zero, might be a new feature */
-		return -EINVAL;
+	    memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1]))) {
+		pr_warn("Some padding is non-zero on %pg, might be a new feature\n",
+			rdev->bdev);
+		if (check_new_feature)
+			return -EINVAL;
+		pr_warn("check_new_feature is disabled, data corruption possible\n");
+	}
 
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
@@ -10422,6 +10427,7 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
 module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
+module_param(check_new_feature, bool, 0600);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
-- 
2.39.2

