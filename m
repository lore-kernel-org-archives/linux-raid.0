Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A000414F90;
	Thu, 31 Oct 2024 03:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345673; cv=none; b=je2a37yMAcWUTpawlgS6m701WNTT/Kb6yQ6P4JrJuZ5Po0ydm7Wt9UKv8fpwaZDhbY8B98ZK5Hv0iuaow0CSZdR5cLBzZxT0yXVLrtNzdSMvzSfydrmOx0aFyrdTgo8S20RQT1sSM2vyI4TsTa8eZ2aZNfjiliNG85xNHmaicOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345673; c=relaxed/simple;
	bh=pnvS/E1BSjVpVZqHh/Cr5jGl9cgy4BF3pwhoUhBsjs4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UUvZzHrIsTZYLPK9oRGpyGvZG7vYg3uEI9OQ9mLhgEbdUFB9OAU8MZYJNgV/mYmQgEZEwlrooMx+iuky/VApWwqiKOBy+h+0itdH0uVVKRH0UOMR8HUe8SW2Jq9V+SYVAN0vC2sotyOO5Mhq0vQTSMzbZCkoPGK6mZjtxt0mrz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jk0rkrz4f3lfY;
	Thu, 31 Oct 2024 11:34:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A98BB1A0196;
	Thu, 31 Oct 2024 11:34:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S4;
	Thu, 31 Oct 2024 11:34:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 0/7] md: enhance faulty checking for blocked handling
Date: Thu, 31 Oct 2024 11:31:07 +0800
Message-Id: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1xJrWkCw1DJw1UAF1DJrb_yoWfZFg_tF
	93ZFy3Jr1xXFy5Aa42krnxZryYyw4DuF17X3Wrtr4Yqr13ur4UKr4qy3yrW3yfXFZxWrn5
	Jry8WF48Ar9rAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbSfO7UUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Why resend?
 - fix a wrong condition in patch 2;
 - the md-6.13 branch will have to update;

Changes in v2:
 - add more comments and commit message in patch 3;
 - fix some typo;


Yu Kuai (7):
  md: add a new helper rdev_blocked()
  md: don't wait faulty rdev in md_wait_for_blocked_rdev()
  md: don't record new badblocks for faulty rdev
  md/raid1: factor out helper to handle blocked rdev from
    raid1_write_request()
  md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid5: don't set Faulty rdev for blocked_rdev

 drivers/md/md.c     | 15 +++++++--
 drivers/md/md.h     | 24 +++++++++++++++
 drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
 drivers/md/raid10.c | 40 +++++++++++-------------
 drivers/md/raid5.c  | 13 ++++----
 5 files changed, 99 insertions(+), 68 deletions(-)

-- 
2.39.2

