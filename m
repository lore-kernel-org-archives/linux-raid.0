Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB1D32D5AC;
	Wed, 17 Sep 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102305; cv=none; b=Vq7PM/qv/si2k91c8tJnLytJjbG+QGE9xLJ7HTEuPzckkQrwdrkiyHl4uNIOqSB/DJwQw9vhDbS8DwWY8zWA+UAEaiCVBQsviOI/dba14cZt8RI0VSCeHCUaeaGTP75fKN7hn+gjp2kiR5zs3rMWWgPz/e8LJ2ywiVce/Rv4NJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102305; c=relaxed/simple;
	bh=fgaqSLkspfg00MVRGpJadOrOiZ/ze2qgXCIvP8ec92A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QiqsKPHBIcHn40kkkA8K7oJII7Fva4VoeJfXlLV1pQMKt2Kc2z46tD8uiuCWyYYkAkeKU6TikE9eJ1nvFaW5L4rEOL1hVzztTtki0hPXcW4Q/CJV1/XroAKzvmcGBU2rnr6v9L03+Zpze5TT1nL7i3VExqhXZoQ40+RU1iV/kc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cRYlb0Jd9zKHMv9;
	Wed, 17 Sep 2025 17:44:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BD93D1A0FAF;
	Wed, 17 Sep 2025 17:44:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Zg8poSuc1Cw--.51298S4;
	Wed, 17 Sep 2025 17:44:59 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 0/7] cleanup and bugfix of sync
Date: Wed, 17 Sep 2025 17:35:01 +0800
Message-Id: <20250917093508.456790-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Zg8poSuc1Cw--.51298S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKrykurW7Gr4xKw43WFyfWFg_yoW3Zwc_KF
	W8XFy3tr409Fy3JFy5Wr129rWUXF4q9Fn7JFyqg3y5Zry3Zr1UKr1jvr4rXw1rZFWjvFn8
	Jr18G34xAr4vvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbT8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
	4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYWrWUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Li Nan (7):
  md: factor error handling out of md_done_sync into helper
  md: mark rdev Faulty when badblocks setting fails
  md: cleanup MD_RECOVERY_ERROR flag
  md: factor out sync completion update into helper
  md/raid10: fix any_working flag handling in raid10_sync_request
  md/raid10: cleanup skip handling in raid10_sync_request
  md: remove recovery_disabled

 drivers/md/md.h     |  11 +--
 drivers/md/raid1.h  |   5 --
 drivers/md/raid10.h |   5 --
 drivers/md/raid5.h  |   1 -
 drivers/md/md.c     | 122 ++++++++++++++++----------------
 drivers/md/raid1.c  |  75 ++++++++------------
 drivers/md/raid10.c | 168 ++++++++++++++------------------------------
 drivers/md/raid5.c  |  40 ++++-------
 8 files changed, 160 insertions(+), 267 deletions(-)

-- 
2.39.2

