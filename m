Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5F30BBAE;
	Mon,  3 Nov 2025 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175178; cv=none; b=TB17Xv2eQNH4Ha4LonssI4zm3NeQvZWKuIc91vMvwFVkTOafz+1ArqapaYUtkDWPWSoPR0Om2mc8lmwEjJbEQTIUDJh/f0pgPGEZ5i0Y7bN20aBxV2A9solxrWRQBGVWgm2/qmcpdt2zEYV7yk1RtmLgQ39Y7GLLUseH6NYegZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175178; c=relaxed/simple;
	bh=/PEyIDJ2p8WdahNDBHhGyuDuzhhotlhiawUBlxMwSSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IeQPjnWOyWG+XRlzg7YIBR8lt5picPGv3E9H2xe5uBQmqVrJoaEqaBtnlT9kzHxVRRoxZ/jdfbddvYj6GrDU+5gY2JPKyShPH4nHWaV6yGO7Ge5lnOh4zdwikcPY3aSLwO9SXJu6wAwkl4e6w68kuN7IFrpJ+UfoWxdDdzA8HRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0Wzz3BK4zKHMMY;
	Mon,  3 Nov 2025 21:06:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C1D051A018D;
	Mon,  3 Nov 2025 21:06:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCHK0TCqAhp+jFMCg--.19557S8;
	Mon, 03 Nov 2025 21:06:11 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v9 4/5] md: add check_new_feature module parameter
Date: Mon,  3 Nov 2025 20:57:56 +0800
Message-Id: <20251103125757.1405796-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251103125757.1405796-1-linan666@huaweicloud.com>
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHK0TCqAhp+jFMCg--.19557S8
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy7ur1DWr1kCryUAw47Jwb_yoW8CF1xpa
	1rXryavr47Xw12yayvqr1kuryrJ3s2yay7Kry5A34xur1UKr95AFW3tFWFqrnF9ry5Zr4I
	gF4UZ3Wxu3WxCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Raid checks if pad3 is zero when loading superblock from disk. Arrays
created with new features may fail to assemble on old kernels as pad3
is used.

Add module parameter check_new_feature to bypass this check.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index dffc6a482181..5921fb245bfa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -339,6 +339,7 @@ static int start_readonly;
  */
 static bool create_on_open = true;
 static bool legacy_async_del_gendisk = true;
+static bool check_new_feature = true;
 
 /*
  * We have a system wide 'event count' that is incremented
@@ -1850,9 +1851,13 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
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
@@ -10704,6 +10709,7 @@ module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
 module_param(legacy_async_del_gendisk, bool, 0600);
+module_param(check_new_feature, bool, 0600);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
-- 
2.39.2

