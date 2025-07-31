Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639052C08AD
	for <linux-raid@vger.kernel.org>; Thu, 31 Jul 2025 11:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753962760; cv=none; b=jKkmGmbXYL80rETO42IsLmFZFQgqK6XXbahyPAEEVwrQmCzCpSM14CHsV1dW1mKSCe8gpMy0iO3sBQd1wU0m7LrNOtAytCXiEWJ/ONVITRW9V0s+3qKhz47czUrSASzPqgCZgsyMcL+Lntmi+rDxBZ0ADqRXFDc9uG6QuUHWOlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753962760; c=relaxed/simple;
	bh=CGeXAGRyY2ZG7n7N4Gbo7HooPmX3bzwy2TqTdl1rXPw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ecQ951ebmz8zF6Wa6pMCgaYcAUNIYfR6gCfMoRpO/VN8Pq/4BdMIXzGQyfyj/N6ELMI1nFknf5x/WHjSsZ/0nDIDfJLM72wlAuHsqtcuZcNMUjW4Qav0r72dS2gnoWUScwNZlETrsPSEj8vwVA1DC7TQ6RL5LfPorpfaFy2kgIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bt6rt0HfQzKHMl3
	for <linux-raid@vger.kernel.org>; Thu, 31 Jul 2025 19:52:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EB4AF1A0D57
	for <linux-raid@vger.kernel.org>; Thu, 31 Jul 2025 19:52:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxP3WItoMDZlCA--.43045S4;
	Thu, 31 Jul 2025 19:52:28 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	yukuai@kernel.org
Cc: linux-raid@vger.kernel.org,
	yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH -next] md: make rdev_addable usable for rcu mode
Date: Thu, 31 Jul 2025 19:45:30 +0800
Message-Id: <20250731114530.776670-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxP3WItoMDZlCA--.43045S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4Duw17trW5Zw4kJrW3GFg_yoW8uF48pF
	W0qFWYkr48Z3yUtF4UCF129a45Ar1Syay7tFyfCw1fA3W5Jws8Aw1xK34jqFn8XayayryU
	ZF1jyanYq3WfXaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Cb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7Iv64x0x7Aq67IIx4CEVc8vx2IErcIFxwCY
	1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28Icw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAsqXUUUUU=
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Our testcase trigger panic:

BUG: kernel NULL pointer dereference, address: 00000000000000e0
...
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 2 UID: 0 PID: 85 Comm: kworker/2:1 Not tainted 6.16.0+ #94
PREEMPT(none)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
Workqueue: md_misc md_start_sync
RIP: 0010:rdev_addable+0x4d/0xf0
...
Call Trace:
 <TASK>
 md_start_sync+0x329/0x480
 process_one_work+0x226/0x6d0
 worker_thread+0x19e/0x340
 kthread+0x10f/0x250
 ret_from_fork+0x14d/0x180
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in: raid10
CR2: 00000000000000e0
---[ end trace 0000000000000000 ]---
RIP: 0010:rdev_addable+0x4d/0xf0

md_spares_need_change in md_start_sync will call rdev_addable which
protected by rcu_read_lock/rcu_read_unlock. This rcu context will help
protect rdev won't be released, but rdev->mddev will be set to NULL
before we call synchronize_rcu in md_kick_rdev_from_array. Fix this by
using READ_ONCE and check does rdev->mddev still alive.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Fixes: 570b9147deb6 ("md: use RCU lock to protect traversal in md_spares_need_change()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 046fe85c76fe..adc5f0b48a00 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9421,6 +9421,12 @@ static bool rdev_is_spare(struct md_rdev *rdev)
 
 static bool rdev_addable(struct md_rdev *rdev)
 {
+	struct mddev *mddev;
+
+	mddev = READ_ONCE(rdev->mddev);
+	if (!mddev)
+		return false;
+
 	/* rdev is already used, don't add it again. */
 	if (test_bit(Candidate, &rdev->flags) || rdev->raid_disk >= 0 ||
 	    test_bit(Faulty, &rdev->flags))
@@ -9431,7 +9437,7 @@ static bool rdev_addable(struct md_rdev *rdev)
 		return true;
 
 	/* Allow to add if array is read-write. */
-	if (md_is_rdwr(rdev->mddev))
+	if (md_is_rdwr(mddev))
 		return true;
 
 	/*
-- 
2.39.2

