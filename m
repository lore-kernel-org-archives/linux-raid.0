Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0049275848;
	Thu, 16 Apr 2026 03:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311439; cv=none; b=OArOeCYO7f91hkkapdK0bnp46at0uegF9/FLUEs287ZnAbjmNK9W4J52Ca0RvkbqwfhaXvVGXGXRiPSoEDSY6LdSp7HnSCpSEPD2U724qX0/WsQCeEgtO0TMqjp1/EAnXjYl6HtuDMpPL1qE9C0K9YjYmFrlIcLAlNPmjjFUJuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311439; c=relaxed/simple;
	bh=rD2fWQvdg/F2u+50KxXMNBUcbeTl14dCNNXq75KL8ks=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NiyPyb9yTDJCm1Pncz/49VKVfq62tDn3DYbafzpkMWjwp9nMIup6eUDMTIkZ6hn9MvFodNNyKNogJBaJUGiFJU8n3OKYgEVUWmHP2FyFNfrkAl2rRflG7gMRItKb2frii/1JMm5QscqHG8ENAySQAg0jSOc2b+9R3LC5g6GFw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tw2Ql3zKHMKJ;
	Thu, 16 Apr 2026 11:50:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 0947A4056E;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S4;
	Thu, 16 Apr 2026 11:50:26 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 0/8] folio support for sync I/O in RAID
Date: Thu, 16 Apr 2026 11:37:53 +0800
Message-Id: <20260416033801.786415-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rurW7ZF18tryfAr45Awb_yoW8AFy7pa
	nxWr9xZ3yrGr4fGr9xJr4j9ry5Wa4rZ3yjyF13Z34xXF13ZFyj9r18ta95W3yDWr9xJFyx
	Xr4UGr4xWF1YkFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F
	4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbhL05UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

This patchset adds folio support to sync operations in raid1/10.
Previously, we used 16 * 4K pages for 64K sync I/O. With this change,
we'll use a single 64K folio instead. Using folios reduces
resync/recovery time by 20% on HDD.

This is the first step towards full folio support in RAID. Going forward,
I will replace the remaining page-based usage with folio.

The patchset was tested with mdadm. Additional fault injection stress tests
were run under file systems.

v3:
 - In patch 3/4/5, ntroduce safe_folio_put and use it for tmpfolio.
 - Merge Cleanup patch into patch 6.

v2:
 - Remove patch "md: use folio for bb_folio". It will be included in
   a later patch set
 - In patch 5:
    1) fix typo
    2) rewrite the logic of copying data in process_checks()
    3) rename resync_get_all_folio() to resync_get_folio()
    4) s/resync_pages *rps/resync_folio *rfs/g in
       raid1_alloc_init_r1buf() and raid10_alloc_init_r10buf()
 - Subsequent patches: Adapting conflicts caused by patch 5

Li Nan (8):
  md/raid1,raid10: clean up of RESYNC_SECTORS
  md: introduce sync_folio_io for folio support in RAID
  md: introduce safe_put_folio for folio support in RAID
  md/raid1: use folio for tmppage
  md/raid10: use folio for tmppage
  md/raid1,raid10: use folio for sync path IO
  md/raid1: fix IO error at logical block size granularity
  md/raid10: fix IO error at logical block size granularity

 drivers/md/md.h       |  10 +-
 drivers/md/raid1.h    |   2 +-
 drivers/md/raid10.h   |   2 +-
 drivers/md/md.c       |  17 ++-
 drivers/md/raid1-10.c |  81 ++++-------
 drivers/md/raid1.c    | 233 ++++++++++++++-----------------
 drivers/md/raid10.c   | 312 ++++++++++++++++++++----------------------
 7 files changed, 297 insertions(+), 360 deletions(-)

-- 
2.39.2

