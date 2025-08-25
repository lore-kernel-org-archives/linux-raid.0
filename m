Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CAE288C22;
	Mon, 25 Aug 2025 08:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756109277; cv=none; b=hgkScN8BFlgU2j38I36NQVTpN2S5wUxS7Ei9FhKZYKZ7+rwZyK9iA8YD5YjmJ8+CI//+An1V9dzb8xDqh63dwWdNKJHqNLnzUkWQ95qVxRqSu3vBwglDonuv3E8ZjwGDpbTain7BvXlMr7V9fA+wJc4NByv+43O4970+FYXUnww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756109277; c=relaxed/simple;
	bh=qSy9J9nyQE7Bo1X2SfwCn5BJQvXE9ufcyq/8tky3LAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g5+T7QhyhFFfRhEMf/WBfAS0c4s7NKe1JBtF9B5YZbSKj6ArOPyfVK1wxsZdDBQs+fTjouPxP3oJntl3tdytOF2iTFrRn4H4f9T26kM1bw6gRJGnZI+F1LKhyuu27/ICdW8gJXivN+gmQnYB+9ZkmM1PsfxjiOxowdapEqB6jKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9Nh80w9yzKHNPZ;
	Mon, 25 Aug 2025 16:07:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B1BB91A1274;
	Mon, 25 Aug 2025 16:07:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIzVGaxosLjpAA--.42805S4;
	Mon, 25 Aug 2025 16:07:51 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 0/2] make logical_block_size configurable
Date: Mon, 25 Aug 2025 15:59:22 +0800
Message-Id: <20250825075924.2696723-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIzVGaxosLjpAA--.42805S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtr43Xr4DXFW5tFyrJF1fZwb_yoW3JwcEva
	yxXrZ3try09Fn7Zay5urs3ZryjkF48u3s7X3Wagr4a93W3Zr18GF109r95X3WkCa4jqF1D
	Jr1UJ3y8Ars8KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbDxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYWrWUUUU
	U
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

v3:
 - logical_block_size must not exceed PAGE_SIZE for bio device.
 - Assign lim to mddev rather than to gendisk in mddev_stack_rdev_limits().
 - Remove the patch that modifies the return value.

v2: No new exported interfaces are introduced.

Li Nan (2):
  md: prevent adding disks with larger logical_block_size to active
    arrays
  md: allow configuring logical_block_size

 drivers/md/md.h                |  1 +
 include/uapi/linux/raid/md_p.h |  6 ++-
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 82 ++++++++++++++++++++++++++++++++++
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 8 files changed, 92 insertions(+), 2 deletions(-)

-- 
2.39.2

