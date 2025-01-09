Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB7D1BF37;
	Thu,  9 Jan 2025 01:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736387808; cv=none; b=CzLVk5KNcBP1nmu43Q3olMAUsvHu/cNKMQrET2dNHWYblcs6/1S9P7Ci09dFE8FQRtwyv9O74TB+qOhMM1kL6tYC9MnOR24hdQfBMLU/DoPFvLkD819y2OWdeHRJ/g9OaUbvGsayoR46w3Hi184GshWEJ7WR+ZCrjKAu4xs7biU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736387808; c=relaxed/simple;
	bh=qCBiIYWOdYrECwI01ejDTEQKuhKzGqr7m4XdSxpZWr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LdfNtpClra5g8C4T3SFBW6IAhfDP8M07/l0xjXvSehlCZo+19CjjBcrDmuj2/8HE60Kx9wzGR3bUiBU0E0/F2Uru0toZzmO5QaXVgF43sybrmWsnBT2taWKwNiJuZpyz8higXYf2FYECsGhflzcYHF7NwEdlXt3BCtYc6ZRqDgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YT7Dk0bktz4f3kvl;
	Thu,  9 Jan 2025 09:56:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7854E1A14BB;
	Thu,  9 Jan 2025 09:56:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_YLH9nk+G_AQ--.844S7;
	Thu, 09 Jan 2025 09:56:43 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	xni@redhat.com,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.14 3/5] md: add a new callback pers->bitmap_sector()
Date: Thu,  9 Jan 2025 09:51:43 +0800
Message-Id: <20250109015145.158868-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250109015145.158868-1-yukuai1@huaweicloud.com>
References: <20250109015145.158868-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_YLH9nk+G_AQ--.844S7
X-Coremail-Antispam: 1UD129KBjvdXoWrZry3Kw1Dury7Gr4rAw15XFb_yoW3urb_Cr
	9Iv3s3WFnxKr95tF1Ivr4SvrWqvwn3Wr4DuFy7KFyfZF9YqrySvrWv9r1xJw1xZF95CasI
	yryDXryrArnxtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb68FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
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

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..de6dadb9a40b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,9 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* convert io ranges from array to bitmap */
+	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
+			      unsigned long *sectors);
 };
 
 struct md_sysfs_entry {
-- 
2.39.2

