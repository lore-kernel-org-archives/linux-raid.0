Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A005413B7BC;
	Thu, 31 Oct 2024 03:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345672; cv=none; b=oWBNKSLRvj42A1QTs/xZo6csIrGngqoAHbKA6pZBo+EZjlBPBuNbuw70M1xxi31rU7Zz11cc6s9ooaJzLH8iIORGvmU8IWeVTktOYPiet++GqeKhzVET0M66Zsx/E4dh72pISUCduB/wvj5aAlHw/fOLgAMs8UE+lAg9Nd0ldRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345672; c=relaxed/simple;
	bh=Lx6ANa7NRU5QksnZsL+37RITL0Jg2i4arTTXt6NAw+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=so0Es0HcLgm/20OcVBMRi9ZuNgxMt+qspUE9n8D4H/7ULLfjZ02yrwGiZ6PA2bB9iVKTdjmw4fR9gNxNnFqQ+SRC3iumm9YQGxGqz4Ld3cAtNf47eGODgykXkqaKwcuL4V5vvj8R5cfA1RG9Dc04RiYKniwi/0vHQh6zZG2/M4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jk6KHfz4f3lVX;
	Thu, 31 Oct 2024 11:34:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6FF6A1A058E;
	Thu, 31 Oct 2024 11:34:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S6;
	Thu, 31 Oct 2024 11:34:21 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 2/7] md: don't wait faulty rdev in md_wait_for_blocked_rdev()
Date: Thu, 31 Oct 2024 11:31:09 +0800
Message-Id: <20241031033114.3845582-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
References: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S6
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy5WFWrXF48Kry3Cr4xXrb_yoWkXrgE9a
	s3Zr97Gr1xJF1Syr1YyFW8ZrZ0kw1kWF4xXFy2qFya9F15Jw48Cw4qv34rJwsruasxC3sI
	krW0gFyavr1SkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbhAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
	ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
	62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
	AFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
	0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_Jw1l42
	xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
	GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
	8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4U
	MIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
	8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU1c_TUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_wait_for_blocked_rdev() is called for write IO while rdev is
blocked, howerver, rdev can be faulty after choosing this rdev to write,
and faulty rdev should never be accessed anymore, hence there is no point
to wait for faulty rdev to be unblocked.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 179ee4afe937..37d1469bfc82 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9762,9 +9762,7 @@ EXPORT_SYMBOL(md_reap_sync_thread);
 void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
-	wait_event_timeout(rdev->blocked_wait,
-			   !test_bit(Blocked, &rdev->flags) &&
-			   !test_bit(BlockedBadBlocks, &rdev->flags),
+	wait_event_timeout(rdev->blocked_wait, !rdev_blocked(rdev),
 			   msecs_to_jiffies(5000));
 	rdev_dec_pending(rdev, mddev);
 }
-- 
2.39.2

