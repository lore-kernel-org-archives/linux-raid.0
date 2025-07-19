Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6AF23534D;
	Sat, 19 Jul 2025 08:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752914255; cv=none; b=LwudzPtJF5JHJ5gxfw8leqUsTUqJfqYRmflRVDyVX3J53Zfocp4K6BJ3eZGRfkURXnfzXPjjAciNsI7/efEWA6t9IAXtZP/NacTL2eHZyrGRhnBd4LGwXEbt/ASY9dIqLTLg6+E1PUwCFCV3W49FG1FYSOum3APHMnnhpiHjx1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752914255; c=relaxed/simple;
	bh=p7bpIvZCIm0RHjrxeNtvLnmg5tVr/XRCGk0rMkfZ0qQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G+6O2WnK8iQ2ck56Zxf6ba3WJAlyqFkLFUuh9LrDSSe9jWfBflYnOjrtmEQBe1g7F8hIncGnWuHr/GrV7eP1Zpxy8jkU6YX8KoDCi6fQu59S5tEyBwClIxp5JqvBPWFEeCdkcOYL+Qaf6yHcFVrshfJepMOv7oQd4gdw6/dwJyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bkg5T1RwRzKHMgc;
	Sat, 19 Jul 2025 16:37:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CFDA81A0DDB;
	Sat, 19 Jul 2025 16:37:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERJIWXtorEYVAw--.20439S7;
	Sat, 19 Jul 2025 16:37:31 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 3/3] md: Fix the return value of mddev_stack_new_rdev
Date: Sat, 19 Jul 2025 16:31:19 +0800
Message-Id: <20250719083119.1068811-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250719083119.1068811-1-linan666@huaweicloud.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHERJIWXtorEYVAw--.20439S7
X-Coremail-Antispam: 1UD129KBjvdXoWruFyDZF43Gr45Kw4kKF1Dtrb_yoWftwc_CF
	sYvFy0grykCF97Zw15Z3yxZryDJw1kWanrXF12gryfZFW3Xrn5GFy8C343W3yrC3y3AryU
	KrsF9aySvw4akjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbNkFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK
	e7AKxVWUXVWUAwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4
	CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAa
	w2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4c8EcI0En4kS14v26r1Y6r17MxAqzxv26x
	kF7I0En4kS14v26r4a6rW5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjTRA_-BDUUU
	U
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In mddev_stack_new_rdev(), if the integrity profile check fails, it
returns -ENXIO, which means "No such device or address". This is
inaccurate and can mislead users. Change it to return -EINVAL.

Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ad8d44493c0f..f2dfe0a72c51 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5920,7 +5920,7 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		pr_err("%s: incompatible integrity profile for %pg\n",
 		       mdname(mddev), rdev->bdev);
 		queue_limits_cancel_update(mddev->gendisk->queue);
-		return -ENXIO;
+		return -EINVAL;
 	}
 
 	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
-- 
2.39.2

