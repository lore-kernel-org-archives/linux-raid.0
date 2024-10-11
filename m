Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B954A31;
	Fri, 11 Oct 2024 01:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609512; cv=none; b=tlCtYs5CYxF/1ci9q7payPPvkVdux1bZHhzExaN2hGpATNXMiaOXR2gFg4KE8yvNtNPSu9gozvferSYAVbFpOjxod+6QE/hwXyAVaej7eRukv9iEPc552WeXQHJllTLNbJbUK7zEZvIkvLrbVDdYSfYD1SbUHPmn0CjyT4vh6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609512; c=relaxed/simple;
	bh=vgKiVQtB+5hTtCw47Emv/NfB/u2JtaQpEj4fgSpCqfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uiBNRwSHA9/YZn3QhJxnKTHWTDh572I9ebMHFTQBoeGAUe/eEqMQrBYvrdYFhlDvHyVSTgjkCbZ8asjzQYmZhr63XvwSwU5FvV41AFtjvvXYP8rQGH86C3H1gX57bUjLuZ9s4EOqGQETxYizd8wTiY2wPvvZnG8Qma6c9yVe/Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XPpfB65qQz4f3jMy;
	Fri, 11 Oct 2024 09:18:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BD2831A058E;
	Fri, 11 Oct 2024 09:18:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sbefAhnm9MFDw--.55490S7;
	Fri, 11 Oct 2024 09:18:25 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 3/7] md: don't record new badblocks for faulty rdev
Date: Fri, 11 Oct 2024 09:16:26 +0800
Message-Id: <20241011011630.2002803-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sbefAhnm9MFDw--.55490S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary7tw13tr43JF48Xr4fKrg_yoW8Wr43pF
	WSvFyrJr4UWr12vw1kXw17Ga4F9as5CrWUKry3Ga4UZay5JrySqwsxta13WryY9ry3XF45
	XF15GFW8ua4kX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9J5rUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Faulty will be checked before issuing IO to the rdev, however, rdev can
be faulty at any time, hence it's possible that rdev_set_badblocks()
will be called for faulty rdev. In this case, mddev->sb_flags will be
set and some other path can be blocked by updating super block.

Since faulty rdev will not be accesed anymore, there is no need to
record new babblocks for faulty rdev and forcing updating super block.

Noted this is not a bugfix, just prevent updating superblock in some
corner cases, and will help to slice a bug related to external
metadata[1], testing also shows that devices are removed faster in the
case IO error.

[1] https://lore.kernel.org/all/f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 37d1469bfc82..35c2e1e761aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9791,6 +9791,17 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 {
 	struct mddev *mddev = rdev->mddev;
 	int rv;
+
+	/*
+	 * Recording new badblocks for faulty rdev will force unnecessary
+	 * super block updating. This is fragile for external management because
+	 * userspace daemon may trying to remove this device and deadlock may
+	 * occur. This will be probably solved in the mdadm, but it is safer to
+	 * avoid it.
+	 */
+	if (test_bit(Faulty, &rdev->flags))
+		return 1;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
-- 
2.39.2

