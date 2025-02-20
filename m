Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606D979CD;
	Thu, 20 Feb 2025 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740055659; cv=none; b=t7BFHEcCeCmXD7qf/1hf0PvYq7zVPdAPgQazOQ/nux65LWPU6T9b3QVzpPEs7jrcQjQP1JmhiPuzqXfprUN00GARtukCGPA9pskwXhhCCr8wlbj32G2CSzDi5yvAak7R6caZM0+dydtstxvSQN3SYwTSaIPWsCIQnX7dGQ2IqFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740055659; c=relaxed/simple;
	bh=DzsGVY7B3W9qUDARt5o5KYc/6ezxGdKjkMX5DdP5NOY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N4LtWj75/6h8BbaqICNWUX5BBWbFefIZisvn8D8SlJr/r7nHZgq2z6mLOu+aCUdv8ntqQAZblY9/sW/lK7bHV0JcIBqnIOC93yiZbM+WWyh47SMBA8vz+pN4g5i5Lj6AMlxQBdJOff1H1fIMkbNGoNsuvNdcJkrzrHyVzj0snc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YzChF5m56z4f3kvv;
	Thu, 20 Feb 2025 20:47:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D17A21A0D5C;
	Thu, 20 Feb 2025 20:47:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHq19gJLdn4NmPEQ--.56042S4;
	Thu, 20 Feb 2025 20:47:30 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de,
	axboe@kernel.dk,
	logang@deltatee.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	hch@lst.de,
	guillaume@morinfr.org
Subject: [PATCH v3] md: fix mddev uaf while iterating all_mddevs list
Date: Thu, 20 Feb 2025 20:43:48 +0800
Message-Id: <20250220124348.845222-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHq19gJLdn4NmPEQ--.56042S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFW7urW3AryxCw4ktrW3GFg_yoWrGr1kpF
	WagFWfGr48Xr93XF4DGa1kuFy5Ww18trWDtry7Ka1rCr15twn5Wr1Sqr15XFyY9ayrXrn0
	ya1UJ345Zr1UWwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

While iterating all_mddevs list from md_notify_reboot() and md_exit(),
list_for_each_entry_safe is used, and this can race with deletint the
next mddev, causing UAF:

t1:
spin_lock
//list_for_each_entry_safe(mddev, n, ...)
 mddev_get(mddev1)
 // assume mddev2 is the next entry
 spin_unlock
            t2:
            //remove mddev2
            ...
            mddev_free
            spin_lock
            list_del
            spin_unlock
            kfree(mddev2)
 mddev_put(mddev1)
 spin_lock
 //continue dereference mddev2->all_mddevs

The old helper for_each_mddev() actually grab the reference of mddev2
while holding the lock, to prevent from being freed. This problem can be
fixed the same way, however, the code will be complex.

Hence switch to use list_for_each_entry, in this case mddev_put() can free
the mddev1 and it's not safe as well. Refer to md_seq_show(), also factor
out a helper mddev_put_locked() to fix this problem.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: f26514342255 ("md: stop using for_each_mddev in md_notify_reboot")
Fixes: 16648bac862f ("md: stop using for_each_mddev in md_exit")
Reported-by: Guillaume Morin <guillaume@morinfr.org>
Closes: https://lore.kernel.org/all/Z7Y0SURoA8xwg7vn@bender.morinfr.org/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 827646b3eb59..f501bc5f68f1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -629,6 +629,12 @@ static void __mddev_put(struct mddev *mddev)
 	queue_work(md_misc_wq, &mddev->del_work);
 }
 
+static void mddev_put_locked(struct mddev *mddev)
+{
+	if (atomic_dec_and_test(&mddev->active))
+		__mddev_put(mddev);
+}
+
 void mddev_put(struct mddev *mddev)
 {
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
@@ -8461,9 +8467,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (mddev == list_last_entry(&all_mddevs, struct mddev, all_mddevs))
 		status_unused(seq);
 
-	if (atomic_dec_and_test(&mddev->active))
-		__mddev_put(mddev);
-
+	mddev_put_locked(mddev);
 	return 0;
 }
 
@@ -9895,11 +9899,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int need_delay = 0;
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -9911,8 +9915,8 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -10245,7 +10249,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -10266,7 +10270,7 @@ static __exit void md_exit(void)
 	remove_proc_entry("mdstat", NULL);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -10278,8 +10282,8 @@ static __exit void md_exit(void)
 		 * the mddev for destruction by a workqueue, and the
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
-- 
2.39.2

