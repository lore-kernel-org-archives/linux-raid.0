Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002791DFDA5;
	Sat, 24 May 2025 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067501; cv=none; b=rwcsDvn5GXABpoDsId2mJ1DyMq0pXO/vVU1Yt3kyVVuSqZC9TIPum6imvCRz5jP5wEYAWJtTuhuBIuq6Ye7rPRXPr4mZza/eyqZzLHVgYFzr9ETDWdm9VE5EDfcMyMNbSfdpSmcSJjkDOEpY5EC3IC/0a3CaNxLZuUM2BcCC7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067501; c=relaxed/simple;
	bh=gF4q1MnynjtKoY4K5z56lCg8NbxZd1ZEpE+ukJebSYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HpJ93JugS3O39USb6NJPc1G0p/FVEla4M8V4OkHRxe8sfV45gHxTV9kDQ2X41/8xrNHJTQ1/ypzDZIbNZ5Db8i18z6Q8ecuhfphLIJVbMQj9DxQauPEs5BXfBZ4WeLZgEwvVGYm/Rida8OdQF0N7ooDHFv196qWxsaNwpDrIXkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b4Bfg3R7rzKHMbS;
	Sat, 24 May 2025 14:18:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EDDE71A018D;
	Sat, 24 May 2025 14:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S17;
	Sat, 24 May 2025 14:18:17 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 13/23] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Sat, 24 May 2025 14:13:10 +0800
Message-Id: <20250524061320.370630-14-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S17
X-Coremail-Antispam: 1UD129KBjvdXoWrKry5trW3Xw1DWrW8Kr4kWFg_yoWfJrc_u3
	WrWrZaqFyDGr1rJw13Zw13ZrZ0q3Z8X3WDurWxKrZ3Zrn8Za4rurs5u3yxta1fuFWDC3y5
	Wry7Xr4rXrs5CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 689d5dba9328..535bc1888e8c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -777,7 +777,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
 	 */
 	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
-	if (write_behind > COUNTER_MAX)
+	if (write_behind > COUNTER_MAX / 2)
 		write_behind = COUNTER_MAX / 2;
 	sb->write_behind = cpu_to_le32(write_behind);
 	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
-- 
2.39.2

