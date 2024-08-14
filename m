Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7AC159209;
	Wed, 14 Aug 2024 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619744; cv=none; b=K9dsQ6b8oPd9JFCsM6kf1LJ4abDVHLYVgU8la6FkgdpHpCrouK0f0Qa2+gKumQdgecf2YlTxOjIU+EbAlrK9dsmYCYkaAEwhnVoL6yREy+9GyH9Lu1Pwwgh9rsseBQqO1KBJVCtlNsSjzVplHSHS4tEmHoli+ZJGxyB6l9x3tdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619744; c=relaxed/simple;
	bh=4GK3ZP1CdIjELYzOD9Wp+EvSdeQVRTV2TkT4ScfzcTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EgsI4Q+H+TaKcBoV11flGyBiks2yAKbbR+jkdXzrZ8Fim9BsT/k8fR+goqqoovWU9sLhMbHlv0mUv50fADnozJq/8FLBie10QEwg8Aa0p6bHaD32Iwf5CHk5ShgNHXo4elsN+2RvmXRtpEgAB4STFYgogNFYhnnnnjTgvOgBYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKF4xKlz4f3jZL;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0A8F11A0359;
	Wed, 14 Aug 2024 15:15:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S36;
	Wed, 14 Aug 2024 15:15:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 32/41] md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:04 +0800
Message-Id: <20240814071113.346781-33-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S36
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAF4rtry7Zw4DXF15CFg_yoW5ArWkpF
	W5K3W5Cr45tFWYq3WUZFWDAFyFqwn7trZrKryxC34rWFyrJFnxWayruFyDtwn5WFy3JFn8
	Zw45try8Ga40qrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 9 +++++----
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ec85d7f2eeee..a1f57f751b55 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1298,7 +1298,7 @@ static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
  * bitmap daemon -- periodically wakes up to clean bits and flush pages
  *			out to disk
  */
-void md_bitmap_daemon_work(struct mddev *mddev)
+static void bitmap_daemon_work(struct mddev *mddev)
 {
 	struct bitmap *bitmap;
 	unsigned long j;
@@ -1815,11 +1815,11 @@ static void bitmap_flush(struct mddev *mddev)
 	 */
 	sleep = mddev->bitmap_info.daemon_sleep * 2;
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
 	if (mddev->bitmap_info.external)
 		md_super_wait(mddev);
 	bitmap_update_sb(bitmap);
@@ -2751,6 +2751,7 @@ static struct bitmap_operations bitmap_ops = {
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
 	.unplug			= bitmap_unplug,
+	.daemon_work		= bitmap_daemon_work,
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index eaaaab51701e..b4c3e4faf288 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -254,6 +254,7 @@ struct bitmap_operations {
 	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
 			   unsigned long e);
 	void (*unplug)(struct mddev *mddev, bool sync);
+	void (*daemon_work)(struct mddev *mddev);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
@@ -277,7 +278,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_daemon_work(struct mddev *mddev);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		     int chunksize, int init);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d621c28cea0..4bdfe23a565d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9621,7 +9621,7 @@ static void unregister_sync_thread(struct mddev *mddev)
 void md_check_recovery(struct mddev *mddev)
 {
 	if (mddev->bitmap)
-		md_bitmap_daemon_work(mddev);
+		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
 		if (mddev->pers->sync_request && !mddev->external) {
-- 
2.39.2

