Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B071A3159;
	Mon, 10 Feb 2025 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739173229; cv=none; b=qPKQ9kKBCRvoOt4bly83I23ezSaUrLegzMtNIG0Elmxa7P3GIZs8ZuyPhMmp8AStA7c5BMI3lZNVFWbv3Kh/+kRFiTyBHdIoDdLrusi7tGcsTrRZgL/J6vMLi5SFwZqsPbN0NTa72v0Yp8rJVRscwAQwdfy2ZpFgnexVbckBywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739173229; c=relaxed/simple;
	bh=RxMZsKwkw987TVn68LiEzpwlFk8ubzKP+paLdPW8YfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fwgDpWoqBOFVsPzNiV2OgrHEF5VDRIupsP7TohfOCBtzyXCrkVr5rsNPy5JPZTjQSpkUV5hxZ9GLz57d48pAJ7pdv8n8+F1/LeRHh/OKxQcOcmQJ4rtFlCIE4+riT7/zFyXNXKqq1i7gb0C2ODFytNybopFBLB/DTLR0p1YhXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YrxLN0vbqz4f3jXy;
	Mon, 10 Feb 2025 15:39:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6052B1A12EB;
	Mon, 10 Feb 2025 15:40:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa19cralnS0S5DQ--.28027S4;
	Mon, 10 Feb 2025 15:40:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 6.6 v2 0/6] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Mon, 10 Feb 2025 15:33:16 +0800
Message-Id: <20250210073322.3315094-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa19cralnS0S5DQ--.28027S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1fCF45KF48XrWkXFyftFb_yoW8Xr4kpa
	9IyrW3uw1fGrW7XF43XrWUuFy5Ja4rtF9rKr1Sk3yrWFyUZFyDJr48JFWvgrZruryfKFW7
	Wr15Jr1UWF10qFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - Add descriptions about chagnes from the original commits, in order to
 fix conflicts.

This set is actually a refactor, we're bacporting this set because
following problems can be fixed:

https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/

See details in patch 6.

I'll suggest people to upgrade their kernel to v6.6+, please let me know
if anyone really want this set for lower version.

Benjamin Marzinski (1):
  md/raid5: recheck if reshape has finished with device_lock held

Yu Kuai (5):
  md/md-bitmap: factor behind write counters out from
    bitmap_{start/end}write()
  md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
  md: add a new callback pers->bitmap_sector()
  md/raid5: implement pers->bitmap_sector()
  md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/md-bitmap.c   |  75 ++++++++++-------
 drivers/md/md-bitmap.h   |   6 +-
 drivers/md/md.c          |  26 ++++++
 drivers/md/md.h          |   5 ++
 drivers/md/raid1.c       |  35 ++------
 drivers/md/raid1.h       |   1 -
 drivers/md/raid10.c      |  26 +-----
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |   4 -
 drivers/md/raid5.c       | 174 ++++++++++++++++++++++-----------------
 drivers/md/raid5.h       |   4 -
 11 files changed, 185 insertions(+), 172 deletions(-)

-- 
2.39.2

