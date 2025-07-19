Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D561D90C8;
	Sat, 19 Jul 2025 08:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752914255; cv=none; b=Q/tYtGvdttSCvnrvcDidvv/65jhsj6IHQcnjh++gvALQQQHDzU2adDDwXPJHYaTDd9oupDZ5BsT7Hgn2WaOxGVlOo4woAKdRUkkedLHJEEtQ4du9i7mqp23GglaYSOBs8Zxxv3tA2ZX6kKJazIMlt+ZM3NtpmuGN/QV/aGYqqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752914255; c=relaxed/simple;
	bh=ULVTSQcXzDKaZFJQyLlcKJrU2218hYTkhFRbfGeVMyk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=loNZUHUueezahTu1/VNBnzcA9Gl7nvHv9OSXeDStP8/ho1AkuOwfi+nFnaoEp9KAg8xLbAuxZqc1xNpN0yCbOK1lJ8I/Zlu7zM9G1A8Uatr3zjPfZsC8zxRGc4OlMgzu0lEfLXSyFH0fAjTid+rmWB3aJibS7lQJqAwFclnTcxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bkg5R473zzKHLxx;
	Sat, 19 Jul 2025 16:37:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38E5C1A084D;
	Sat, 19 Jul 2025 16:37:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERJIWXtorEYVAw--.20439S4;
	Sat, 19 Jul 2025 16:37:29 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	axboe@kernel.dk
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	hch@infradead.org,
	filipe.c.maia@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 0/3] make logical_block_size configurable
Date: Sat, 19 Jul 2025 16:31:16 +0800
Message-Id: <20250719083119.1068811-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHERJIWXtorEYVAw--.20439S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUO-7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I2
	1c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0w
	CF04k20xvY0x0EwIxGrwCF54CYxVAaw2AFwI0_Jrv_JF1l4c8EcI0Ec7CjxVAaw2AFwI0_
	GFv_Wryl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYuc_UUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

v2: No new exported interfaces are introduced.

Li Nan (3):
  md: prevent adding disks with larger logical_block_size to active
    arrays
  md: allow configuring logical_block_size
  md: Fix the return value of mddev_stack_new_rdev

 drivers/md/md.h                |  1 +
 include/uapi/linux/raid/md_p.h |  6 ++-
 drivers/md/md-linear.c         |  1 +
 drivers/md/md.c                | 74 +++++++++++++++++++++++++++++++++-
 drivers/md/raid0.c             |  1 +
 drivers/md/raid1.c             |  1 +
 drivers/md/raid10.c            |  1 +
 drivers/md/raid5.c             |  1 +
 8 files changed, 83 insertions(+), 3 deletions(-)

-- 
2.39.2

