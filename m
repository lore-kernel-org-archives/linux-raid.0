Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7614264A;
	Thu, 31 Oct 2024 03:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345677; cv=none; b=pgWVJkHjGfpaosr+LRBsBECA4NvOePLZuTDojjnUHS6uvM+rAbbSOFe5cJuI4UBo1cs5GwTPXgKkZv+Ev5ehRg6ErhAg4s4PAYjH8WRtHvXvWQMjwxxBIBDh7FmiGvWt82hKtpSG23W74Gl6v1hBtbyxpjzZ6qUbIkkx4Vu+QFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345677; c=relaxed/simple;
	bh=HCadqzRGDHXPvMHcSezNPjkg2eia/z32SkyaCn+eH8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XiQJmGZ5btk1sKx2aUka6JARfnYk1TMeWbqE58LVqR8o+G6x9ZdiyFN87FlXkp07ZdA4pb8R2Nerm+2xPKQ/hJVAYTKwOdd/1iHhDVI+WtracA05ZpyxloFJHlGEKZUutWcytPE2v+8CdWLapll7e3Q+sc/TiTPCgKEdwoepDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jw0HN6z4f3jkv;
	Thu, 31 Oct 2024 11:34:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A56A91A018D;
	Thu, 31 Oct 2024 11:34:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S7;
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
Subject: [PATCH RESEND 3/7] md: don't record new badblocks for faulty rdev
Date: Thu, 31 Oct 2024 11:31:10 +0800
Message-Id: <20241031033114.3845582-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary7tw13tr43JF48Xr4fKrg_yoW8WFWrpa
	ySqFyrJr4UWr12vw1kXw12ga4Fgas5CrWUKry3Ga4UZay5JrySgwsxta13urZ09ry3XF45
	XF15Kay8ua4vq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
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
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
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

