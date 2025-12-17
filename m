Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74D32938B;
	Wed, 17 Dec 2025 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973480; cv=none; b=HP0NsNu2PdZ2yNmhJzY5TP3HVEhp6i2/w6LJtNw/UNiPivVp2UlwXcdaohpNVwUcPnzv1oPWCnfpJulmxYfgJo/2vr64ZXIqiI0MSuYAbzcW47/XRxsqaXb7Uyw0dy0nxgoMd7pFM5Efpb98nB7O+hv+yLaz0OQ9X7u114cb9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973480; c=relaxed/simple;
	bh=IcUM9ib/XXmLldiROSun6fXKAyVvGMoK4A2ORkE1ZKk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eXI6Znk7We5dwooKXxZncb4xAp6xwrQDC4dFo0qB2ddLyNzYZIyJFe92pMXbsCu+nju9hPz7INFMrIWt1pyCrmoVwjmTBx2yjmvrlFBlN2gAb0ln+obHlA+m35l1E7jSIO9R4esDaepvMEF0WIzakOFxWK+F1EzfCL4/jB3h/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh50hgmzKHN2n;
	Wed, 17 Dec 2025 20:11:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2F0FA40590;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S4;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 00/15] folio support for sync I/O in RAID
Date: Wed, 17 Dec 2025 19:59:58 +0800
Message-Id: <20251217120013.2616531-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rurW7ZF18tF4ktr17GFg_yoW8Wr43pa
	13Wr9xZw4rGr4xAr9xXw42vr1rJryrA345Aryay3yxXFnxZFy8Kw48JayrWrWDXryfJryU
	Wr1UKwsxWF15KFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBHqcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

This patchset adds folio support to sync operations in raid1/10.
Previously, we used 16 * 4K pages for 64K sync I/O. With this change,
we'll use a single 64K folio instead.

This is the first step towards full folio support in RAID. Going forward,
I will replace the remaining page-based usage with folio.

The patchset was tested with mdadm. Additional fault injection stress tests
were run under file systems.

Li Nan (15):
  md/raid1,raid10: clean up of RESYNC_SECTORS
  md: introduce sync_folio_io for folio support in RAID
  md: use folio for bb_folio
  md/raid1: use folio for tmppage
  md/raid10: use folio for tmppage
  md/raid1,raid10: use folio for sync path IO
  md: Clean up folio sync support related code
  md/raid1: clean up useless sync_blocks handling in raid1_sync_request
  md/raid1: fix IO error at logical block size granularity
  md/raid10: fix IO error at logical block size granularity
  md/raid1,raid10: clean up resync_fetch_folio
  md: clean up resync_free_folio
  md/raid1: clean up sync IO size calculation in raid1_sync_request
  md/raid10: clean up sync IO size calculation in raid10_sync_request
  md/raid1,raid10: fall back to smaller order if sync folio alloc fails

 drivers/md/md.h       |   5 +-
 drivers/md/raid1.h    |   2 +-
 drivers/md/raid10.h   |   2 +-
 drivers/md/md.c       |  54 ++++++--
 drivers/md/raid1-10.c |  81 ++++-------
 drivers/md/raid1.c    | 219 +++++++++++++-----------------
 drivers/md/raid10.c   | 303 ++++++++++++++++++++----------------------
 7 files changed, 310 insertions(+), 356 deletions(-)

-- 
2.39.2

