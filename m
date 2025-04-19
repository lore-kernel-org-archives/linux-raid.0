Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370DCA4B;
	Sat, 19 Apr 2025 01:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745026223; cv=none; b=mxdHbE5T7CDUeWtBfYnK0v8kGn9j3AotqjNc0I2NwBUzRKXi7S/cZQs3kiHEQzyNLsIGw+CBL2o0f2UEcY8j9juAcYz3Jd4QP/dOChytm4Fqwgsbx5Aj6zmmjSsXrX1+gM1yu2g35FIVmAUsm23IDqfyr6URI4yXnIwLn4qQq5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745026223; c=relaxed/simple;
	bh=joXZgQ0S73kvg2QAOzJTcNlXUKUVUS+xHcxiVstc31g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OtOb7WbDxtInby5sAjPKYzh6Q5TfR1L5P7XXyvx9wPoLX+U7/MSgbNSOLhM6KEZjiv4UQ6kVxlfdQ1BRmWb6GmJNWNRqL20roB0YaBMdWXk7iu/CBXpcCfD3IHu3NoS/K7w7l2NAifkhzs4yM64HA+RCvNlrBrSRjWkv5wg8Ju0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZfYw24th8z4f3jtt;
	Sat, 19 Apr 2025 09:29:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 231431A07BB;
	Sat, 19 Apr 2025 09:30:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa1+i_AJo6lCaJw--.27471S5;
	Sat, 19 Apr 2025 09:30:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com,
	carnil@debian.org
Subject: [PATCH 6.1 1/2] md: factor out a helper from mddev_put()
Date: Sat, 19 Apr 2025 09:23:02 +0800
Message-Id: <20250419012303.85554-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250419012303.85554-1-yukuai1@huaweicloud.com>
References: <20250419012303.85554-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa1+i_AJo6lCaJw--.27471S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1fur45KF47tFyUWrWkXrb_yoW8ur48p3
	yfta9xCrWkJrW3J3y7Jr4DW3W5Xw4vyrWqqryfWws5ZFy3Zr15Gw1Fgas5WryDC34fZF45
	Z3WUWFWDCr10gwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQq14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v2
	6r1q6r43MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjnXo7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 3d8d32873c7b6d9cec5b40c2ddb8c7c55961694f upstream.

There are no functional changes, prepare to simplify md_seq_ops in next
patch.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230927061241.1552837-2-yukuai1@huaweicloud.com
[minor context conflict]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e2751d42f64..639fe8ebaa68 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -667,24 +667,28 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 
 static void mddev_delayed_delete(struct work_struct *ws);
 
+static void __mddev_put(struct mddev *mddev)
+{
+	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
+	    mddev->ctime || mddev->hold_active)
+		return;
+
+	/* Array is not configured at all, and not held active, so destroy it */
+	set_bit(MD_DELETED, &mddev->flags);
+
+	/*
+	 * Call queue_work inside the spinlock so that flush_workqueue() after
+	 * mddev_find will succeed in waiting for the work to be done.
+	 */
+	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
+	queue_work(md_misc_wq, &mddev->del_work);
+}
+
 void mddev_put(struct mddev *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
-	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
-	    mddev->ctime == 0 && !mddev->hold_active) {
-		/* Array is not configured at all, and not held active,
-		 * so destroy it */
-		set_bit(MD_DELETED, &mddev->flags);
-
-		/*
-		 * Call queue_work inside the spinlock so that
-		 * flush_workqueue() after mddev_find will succeed in waiting
-		 * for the work to be done.
-		 */
-		INIT_WORK(&mddev->del_work, mddev_delayed_delete);
-		queue_work(md_misc_wq, &mddev->del_work);
-	}
+	__mddev_put(mddev);
 	spin_unlock(&all_mddevs_lock);
 }
 
-- 
2.39.2

