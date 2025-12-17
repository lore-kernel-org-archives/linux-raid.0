Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB41487E9;
	Wed, 17 Dec 2025 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765977380; cv=none; b=fZ7ZziB6F9YxKeEJi4kDzrHp22GNhrFY2en3rFVVr4XuXNegtphl9D7pNJ9WTnskwQqmFDHW9HNYC78EvzEanojut4mJROsW/ticcd/HdlqaRnKGsAOMiXuE28fAv5FVGrqXwOXP6nDoB3566el7PGsRAgrlxCbPXNeHfGCKHQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765977380; c=relaxed/simple;
	bh=OhMWGlNdWne0AVIBdA/1mdhlw6O0iosSjrlHlJWtDwI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VrCZnOGRbsCJotLztqGIpDey1bcF7lYeScZB0e/pLkmxi8G3O+Eubt7wWsrNWD8IQyQHksCAe5zHPMQhITm738XG79qDNUmLCIQQU/jb0nAOIvBNDh2ABdKdAJgAgigADbmu7A/Jddiz40YNTVZWJNXqzXh5/m+uYA7CCpaiycA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWZ783gS7zKHMP3;
	Wed, 17 Dec 2025 21:16:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A3F6E40583;
	Wed, 17 Dec 2025 21:16:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_carUJpKY0OAg--.53331S4;
	Wed, 17 Dec 2025 21:16:11 +0800 (CST)
From: linan666@huaweicloud.com
To: stable@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH stable/6.18-6.17] md: add check_new_feature module parameter
Date: Wed, 17 Dec 2025 21:05:13 +0800
Message-Id: <20251217130513.2706844-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_carUJpKY0OAg--.53331S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4UJr1xtFWDtrWxXr4xWFg_yoW8uFy8pa
	18WryavrWxXw12y3yvqr4kuryrJ392qay7KrW5A34fur1UKr95A3yfKayFqrnF9ry5ZF47
	WF4j93Wxuw1xCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14
	v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbhL05UUUUU==
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
---
 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..9d9cb7e1e6e8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -340,6 +340,7 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 static bool legacy_async_del_gendisk = true;
+static bool check_new_feature = true;
 
 /*
  * We have a system wide 'event count' that is incremented
@@ -1752,9 +1753,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
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
@@ -10459,6 +10464,7 @@ module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
 module_param(legacy_async_del_gendisk, bool, 0600);
+module_param(check_new_feature, bool, 0600);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
-- 
2.39.2

