Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9BA161936;
	Fri, 30 Aug 2024 07:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002924; cv=none; b=n8inT+mcMwNMZHuShFWWbxr1CHSlLoOuUwc6b+IQhPynboLH0QlISEBNW2kwK8KvYpPijw14qKlbLclOq3Xf0Bjlm3ND4Lp0QHJhzZaRZInhyZTIWzXxf1B/Mn8jlHJh2o0tXOpHEkw07vgng/tr4r3u9YehOXWOEau1uHZDGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002924; c=relaxed/simple;
	bh=M70W3TWK0lN7YVPkPxWiHuPdmCqToE4o00o1VK1WO9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pwHxHlOu2axQaCiZQNJ1IOIfZGzuqelTDbmgDHXXY0IoIgrao88uEnRqqhQnH22+wrX+4aNC4YdQWIQJlM3FiJzXEMoR4Cs9Ka1uAaqfVSNAo7kOedoxk5OvzGkbPF5BShiNFq64SWUnxGtiyRMy/gwzsmgDBKg1D4HvbJTnRWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rs3mTWz4f3jtw;
	Fri, 30 Aug 2024 15:28:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8DFFD1A0568;
	Fri, 30 Aug 2024 15:28:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S7;
	Fri, 30 Aug 2024 15:28:36 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 3/7] md: don't record new badblocks for faulty rdev
Date: Fri, 30 Aug 2024 15:27:17 +0800
Message-Id: <20240830072721.2112006-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S7
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13ArWrJFW5JF1xtr4ruFg_yoWkKwbE9F
	Z8ZFWUGr1fJFnxtr45tr1avrZav34vgr1kXFy09r13Zr1UXFs5K34qgrn3Zr4xAFy5CFyY
	yry09r4Svw4YgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb68FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbTUDJUUUUU==
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
metadata[1].

[1] https://lore.kernel.org/all/f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 675d89597c7b..a3f7f407fe42 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9757,6 +9757,10 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 {
 	struct mddev *mddev = rdev->mddev;
 	int rv;
+
+	if (test_bit(Faulty, &rdev->flags))
+		return 1;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
-- 
2.39.2

