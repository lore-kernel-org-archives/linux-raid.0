Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B11FCCF9;
	Mon, 27 Jan 2025 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968301; cv=none; b=XuYNR6HJoT3gMUXTSnZVuV2s8bt1NTCjBdcI3R+BrUN+fnxldzV+ulQAvjKBcl5V1+null2g3Vl6GI2bB8Foxt9sjLrZnqHmW1aCf7vo6n1qBqqO5eBiCYM4QvwLDfDaeKd5wf3a2Pc+FBAg8uWyqVSxA9BazhK9clx4hZWjoXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968301; c=relaxed/simple;
	bh=y/LXVW6oH4u4C6MXkjImW0HbM2iucpRfObOtzgX0T2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oNsxaBtExPVRUlSfnNffvIwzNAhiB+nQ6RknramCwFJh9bYdeQvB/x1dpse9to4aNulEfllX+hxKvhd47KJjMasrFub3MbI06jknPIwrTHvdIFa2BxkUFpl+6MGBioe7nJy0S5LbQjUrZlinGkXY1qUzGtE+qw3+O354J4HCW9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YhMkr1hH1z4f3jXb;
	Mon, 27 Jan 2025 16:57:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0AF791A0D8C;
	Mon, 27 Jan 2025 16:58:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXe1+mSpdnShB+CA--.53281S7;
	Mon, 27 Jan 2025 16:58:16 +0800 (CST)
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
Subject: [PATCH 6.12 3/5] md: add a new callback pers->bitmap_sector()
Date: Mon, 27 Jan 2025 16:52:12 +0800
Message-Id: <20250127085214.3197761-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250127085214.3197761-1-yukuai1@huaweicloud.com>
References: <20250127085214.3197761-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe1+mSpdnShB+CA--.53281S7
X-Coremail-Antispam: 1UD129KBjvdXoW7GF47Cry8KF4UJFW5uw4Durg_yoWDArc_Cr
	nIqryfGFn8Grn5tr18ur1SvrWqywn3WF4DWFy7KFyfZF95t34fArWvkFyrJw1fXF95u3sx
	JryUXrs5ZFnrJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb6xFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43Mx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8
	Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JULBMNUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 0c984a283a3ea3f10bebecd6c57c1d41b2e4f518 upstream.

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-4-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/md/md.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d2e6bd58e4d..6836d6684cc1 100644
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

