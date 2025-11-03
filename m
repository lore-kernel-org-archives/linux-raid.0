Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA1330E0E4;
	Mon,  3 Nov 2025 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175179; cv=none; b=kepS6h9C6RDQrZKhnka8SZhzuYNHUSmSlfQVHM323HNZbdgeCcmi8uUZhbzHoepl1sxlUmTYnPb5xUhCAsy7SIsh7wVErrs+hZxX5vN9SGQ58f87Tzrw/zxwJ9ZixmZlRg6HPGftrk0RR+cZuh3LpM5cCSb0OxXVTRg4Trk1nBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175179; c=relaxed/simple;
	bh=jyVLrsfYOAIfwh0iHMqXUD8NvA8U1ETE85ayoonOPX8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hFsZeK1C5EKZo/Av57QFB0LtRe2giGLHTVw6gOg0J6jvv58T8XESEUeLLOi2xSyqlZLMLq0bBoRoqCMqA25D8E8K+9f3BFic/HShSMeGj9M0zLvsE/cn7Ze/13TBdSZetItnJHF968EHPqqaUEaStdNrXTN1A08ytpWZ03dSVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0Wzz0DQbzKHMMY;
	Mon,  3 Nov 2025 21:06:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5D0E71A14FC;
	Mon,  3 Nov 2025 21:06:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCHK0TCqAhp+jFMCg--.19557S4;
	Mon, 03 Nov 2025 21:06:11 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v9 0/5] make logical block size configurable
Date: Mon,  3 Nov 2025 20:57:52 +0800
Message-Id: <20251103125757.1405796-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHK0TCqAhp+jFMCg--.19557S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw43AF1xAr15Gw1Dtw17Awb_yoWktrXE9F
	43XF9xKr18GFy7uFyagr4furWUAF4fuFykZF9xtr45Zw1fZr47CF4q93y5X3WUuryDZFn8
	Cr18Way8Jr4agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbDAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F
	4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxV
	WUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdpnQU
	UUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

v9:
 - Add new patch to intorduce check_new_feature to address forward and
   backward compatibility
 - Patch 5: update description of check_new_feature in md.rst

v8:
 - Path 2: remove unnecessary bioset_initialized() check.
 - Path 3: remove the max(blksize, ...)
 - Path 4: set MD_SB_CHANGE_DEVS instead of call md_update_sb()

v7:
 - Add three prerequisite patch to fix some config lbs related issues
 - Update sb when lbs configuration is done
 - This feature should support raid0, update documentation accordingly

Li Nan (5):
  md: delete md_redundancy_group when array is becoming inactive
  md: init bioset in mddev_init
  md/raid0: Move queue limit setup before r0conf initialization
  md: add check_new_feature module parameter
  md: allow configuring logical block size

 Documentation/admin-guide/md.rst |  10 ++
 drivers/md/md.h                  |   1 +
 include/uapi/linux/raid/md_p.h   |   3 +-
 drivers/md/md-linear.c           |   1 +
 drivers/md/md.c                  | 162 +++++++++++++++++++++++--------
 drivers/md/raid0.c               |  17 ++--
 drivers/md/raid1.c               |   1 +
 drivers/md/raid10.c              |   1 +
 drivers/md/raid5.c               |   1 +
 9 files changed, 148 insertions(+), 49 deletions(-)

-- 
2.39.2

