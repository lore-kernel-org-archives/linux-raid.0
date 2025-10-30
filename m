Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB932572E;
	Thu, 30 Oct 2025 06:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806171; cv=none; b=f9m+sKN3KrVMofpCc+5bIrbWWB9GogoMx2XutRNKoNfuGzXMTFyVI9T4JOyhJbp3s8G6nUoBq01SuJXNTSUXTnPvCfMMyC6kqNHW/ZLFGw9ArFIgIPWSfpc487PxPzgif7Vvu3S29G6Udqi6QgQq0CCuSvZNSAJnx1fRQiaBXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806171; c=relaxed/simple;
	bh=gc8OQ64S0LmvlY3dIEdlZgf14NO1etxrNORsaAn4/LQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UkJjUHsKoSljh8LtQzjSHqbZ9rP/92nkGZH9OJHLsvNgdBytYHUyWH6ZJpIxbXA+0UpkSvOypNJX1Qrib1jiwmXAeNPto8R9yZEAx24Vid65F1ieZFRrrdWjE5oCxYjSJ7Z8M47/pDe7Y9CdTNDNAcR1UOOKCiVVUykgIlCWPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cxvVg0MCWzKHLv2;
	Thu, 30 Oct 2025 14:35:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 44A341A173C;
	Thu, 30 Oct 2025 14:36:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgDnPUZUBwNpEqJkCA--.9906S4;
	Thu, 30 Oct 2025 14:36:06 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	hare@suse.de,
	xni@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v8 0/4] make logical block size configurable
Date: Thu, 30 Oct 2025 14:28:03 +0800
Message-Id: <20251030062807.1515356-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnPUZUBwNpEqJkCA--.9906S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XFy5CFy8uFyUGw15uF1rJFb_yoWDGrbE9F
	4fXF9xtr1kWFy7Ca45Wr4SvFWUAFs7uFykZF9xKw45Zw1avr1UKF1ku345X3WUZryDZr15
	Aw18WFy8Ar4agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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

v8:
 - Path 2: remove unnecessary bioset_initialized() check.
 - Path 3: remove the max(blksize, ...)
 - Path 4: set MD_SB_CHANGE_DEVS instead of call md_update_sb().

v7:
 - Add three prerequisite patch to fix some config lbs related issues
 - Update sb when lbs configuration is done
 - This feature should support raid0, update documentation accordingly

Li Nan (4):
  md: delete md_redundancy_group when array is becoming inactive
  md: init bioset in mddev_init
  md/raid0: Move queue limit setup before r0conf initialization
  md: allow configuring logical block size

 Documentation/admin-guide/md.rst |   7 ++
 drivers/md/md.h                  |   1 +
 include/uapi/linux/raid/md_p.h   |   3 +-
 drivers/md/md-linear.c           |   1 +
 drivers/md/md.c                  | 150 +++++++++++++++++++++++--------
 drivers/md/raid0.c               |  17 ++--
 drivers/md/raid1.c               |   1 +
 drivers/md/raid10.c              |   1 +
 drivers/md/raid5.c               |   1 +
 9 files changed, 136 insertions(+), 46 deletions(-)

-- 
2.39.2

