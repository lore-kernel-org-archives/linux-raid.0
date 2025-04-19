Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A5078C9C;
	Sat, 19 Apr 2025 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745026224; cv=none; b=IyjA558vlw9LNZ8bQX7ZE+z7QoEhcV0HVaVDbqNFyCDyxcgRhi8F76VcpolB7kd5tfo6PKIGSFX7sQXhggFCaZyH8mZ2UUQ6ydZigqs6hCheoKyjg+W8iH1kULfGsiNDMgWnqMvAhoLbmMpWgOcd9kphIo340ip15PY6oTZVLAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745026224; c=relaxed/simple;
	bh=JN/ug3dM1UBGfNxAh11HlE1UcacJnvtGdNX59TS7qxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLdnHMKTVGaRXUlIztFSep1C2enH78DQdHQqMQNKiI9z/ez6fCIg3qk2nQ1RpX8LQJ1wouP6Wkx4KqoKx9o/eEC6PtNDw96sDtRzfPBxOACqiBLPS6C9weH8BeiqdgSvQoi6xAljwXXnypa7JXJU0d/il+gXnRjVlYPgmVrpQD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZfYw317hmz4f3k5c;
	Sat, 19 Apr 2025 09:29:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 970981A0359;
	Sat, 19 Apr 2025 09:30:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa1+i_AJo6lCaJw--.27471S6;
	Sat, 19 Apr 2025 09:30:13 +0800 (CST)
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
Subject: [PATCH 6.1 2/2] md: fix mddev uaf while iterating all_mddevs list
Date: Sat, 19 Apr 2025 09:23:03 +0800
Message-Id: <20250419012303.85554-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHa1+i_AJo6lCaJw--.27471S6
X-Coremail-Antispam: 1UD129KBjvJXoWxurykWr1fCw48tF47Zr15XFb_yoWrGrWUpF
	Waga1fGr48X3s3XF4DGw4DuFy5Ww18Kr4qqryxGa1rCr1Utr98Wr1Sgw15XFyj9ayfXrn0
	qa18Ja4Yvr1DWwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AK
	xVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 8542870237c3a48ff049b6c5df5f50c8728284fa upstream.

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
Link: https://lore.kernel.org/linux-raid/20250220124348.845222-1-yukuai1@huaweicloud.com
Fixes: f26514342255 ("md: stop using for_each_mddev in md_notify_reboot")
Fixes: 16648bac862f ("md: stop using for_each_mddev in md_exit")
Reported-and-tested-by: Guillaume Morin <guillaume@morinfr.org>
Closes: https://lore.kernel.org/all/Z7Y0SURoA8xwg7vn@bender.morinfr.org/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[skip md_seq_show() that is not exist]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 639fe8ebaa68..d5fbccc72810 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -684,6 +684,12 @@ static void __mddev_put(struct mddev *mddev)
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
@@ -9704,11 +9710,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
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
@@ -9720,8 +9726,8 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
-		mddev_put(mddev);
 		spin_lock(&all_mddevs_lock);
+		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
@@ -10043,7 +10049,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev, *n;
+	struct mddev *mddev;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -10064,7 +10070,7 @@ static __exit void md_exit(void)
 	remove_proc_entry("mdstat", NULL);
 
 	spin_lock(&all_mddevs_lock);
-	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
 			continue;
 		spin_unlock(&all_mddevs_lock);
@@ -10076,8 +10082,8 @@ static __exit void md_exit(void)
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

