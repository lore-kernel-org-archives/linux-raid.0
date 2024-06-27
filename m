Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5542C13C9CA;
	Thu, 27 Jun 2024 11:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719487489; cv=none; b=DjIn78B9glWMtOpdVsRmDg1U6nyKgGDDnVUjgECrefJvvDQNK1STP/K2VULDA034zTM4b/HLml1q8Jr5ot7gPDw13PdHSQg/i0e+qiiyXf1EMcRY7exc9GzHVub8j9hnjXaId6T6kJ9rDzx+HB52E+c1/YdrjJ2ZbgMB3UAC0bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719487489; c=relaxed/simple;
	bh=4LAavDgVL6Zi07g1N6DYyV89gbwEJziT8WrmwA8d8yU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=buurty/zp6iHWiWB2/1/NW1o505pIENZvQhY4IK3aYLwnBAXIndgfcuSLJgzvOKST/LuP24aU+/E/tmYopcrZrBhWizBSgsmwaX8GjcazvXBPume35DvLiMbTvYoNclDvNgXKsvf4HOeYwYTLbKlZUwMVlQYLwJzuopdU88yYso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W8x6s0JWJz4f3k6Z;
	Thu, 27 Jun 2024 19:24:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 2F6411A0572;
	Thu, 27 Jun 2024 19:24:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP2 (Coremail) with SMTP id Syh0CgB34Yb4S31mmRL0AQ--.22237S4;
	Thu, 27 Jun 2024 19:24:42 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mateusz.kusiak@linux.intel.com,
	mariusz.tkaczyk@linux.intel.com,
	nfbrown@suse.de,
	hare@suse.de
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next] md: don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl
Date: Thu, 27 Jun 2024 19:23:21 +0800
Message-Id: <20240627112321.3044744-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34Yb4S31mmRL0AQ--.22237S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4DZw4xtr4fCFy7JrW5Jrb_yoW8CF18pF
	43GF90qFyDCr1Ikw4DJ3WkXa45Aw40y3y3CFy3Wwn7Za45Ary5WFWjkFW5uas8Kr95tanx
	JF1kJr93Ga4rKaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	UdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Commit 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting
device removal.") explained in the commit message that failed device
must be reomoved from the personality first by md_check_recovery(),
before it can be removed from the array. That's the reason the commit
add the code to wait for MD_RECOVERY_NEEDED.

However, this is not the case now, because remove_and_add_spares() is
called directly from hot_remove_disk() from ioctl path, hence failed
device(marked faulty) can be removed from the personality by ioctl.

On the other hand, the commit introduced a performance problem that
if MD_RECOVERY_NEEDED is set and the array is not running, ioctl will
wait for 5s before it can return failure to user.

Since the waiting is not needed now, fix the problem by removing the
waiting.

Fixes: 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting device removal.")
Reported-by: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Closes: https://lore.kernel.org/all/814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0426a6d2fd1..da3065a3c2fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7827,12 +7827,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return get_bitmap_file(mddev, argp);
 	}
 
-	if (cmd == HOT_REMOVE_DISK)
-		/* need to ensure recovery thread has run */
-		wait_event_interruptible_timeout(mddev->sb_wait,
-						 !test_bit(MD_RECOVERY_NEEDED,
-							   &mddev->recovery),
-						 msecs_to_jiffies(5000));
 	if (cmd == STOP_ARRAY || cmd == STOP_ARRAY_RO) {
 		/* Need to flush page cache, and ensure no-one else opens
 		 * and writes
-- 
2.39.2

