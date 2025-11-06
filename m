Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007923254B5;
	Thu,  6 Nov 2025 12:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430886; cv=none; b=NG11iArE+uKRu6M00tk2czOAGsBo1FyK5zP71gg9rgf+uNSouGBF/NlC3H+NTSd2iJrLYVyBRjvH5HhSJuEWEqYlxJwLSrOyNmqla+SJYgt3TFgcIFUV8+DUWACjR8UVcxeV/qhlR5MAe08UWrZCrQEPbzd182nfXjjB+AteXNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430886; c=relaxed/simple;
	bh=ZM8fa5s1lZ6qjJgcgbaq2tubODL1edU9BFjlRgTvU1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kiDahfvUmuUzktjTQoQdDCC2f7QQqK0RGR/2dcmBQhc1Fa+VvN0DtKl8OEwYjvlqWrtEeI+7cGSKBGDokrj8y6jpFNCFG2nvLkw1AReZ0Yz51U5LBAaVkycGJNQUGodkQCcrZ7TL+WTLANnkwn8F3/I20TAzzI+BiJb89XsfzwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYC1myBzYQts6;
	Thu,  6 Nov 2025 20:07:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8E01F1A1CD4;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S4;
	Thu, 06 Nov 2025 20:07:59 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 00/11] cleanup and bugfix of sync
Date: Thu,  6 Nov 2025 19:59:24 +0800
Message-Id: <20251106115935.2148714-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S4
X-Coremail-Antispam: 1UD129KBjvJXoW7AFW8WFW5Wr1fCF13Ww43GFg_yoW8GFyUp3
	yfKry3Zw48CrW7Zr9xJFyUZayrC34xta42kr17t3ykXF15ZFWUGF4UXa18WFyDXry3Ka42
	qr1UGFZxGF18Ja7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
	WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUooGQ
	DUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

v2:
 - patch 1, 4, 8: new patches
 - patch 3: new cleanup patch for future fix, Link:
   https://lore.kernel.org/all/8136b746-50c9-51eb-483b-f2661e86d3eb@huaweicloud.com/
 - patch 5: do not change return value of narrow_write_error()
 - patch 6: add comment of removing MD_RECOVERY_INTR

Li Nan (11):
  md/raid1: simplify uptodate handling in end_sync_write
  md: factor error handling out of md_done_sync into helper
  md/raid1,raid10: return actual write status in narrow_write_error
  md/raid1,raid10: support narrow_write_error when badblocks is disabled
  md: mark rdev Faulty when badblocks setting fails
  md: remove MD_RECOVERY_ERROR handling and simplify resync_offset
    update
  md: factor out sync completion update into helper
  md: move finish_reshape to md_finish_sync()
  md/raid10: fix any_working flag handling in raid10_sync_request
  md/raid10: cleanup skip handling in raid10_sync_request
  md: remove recovery_disabled

 drivers/md/md.h     |  11 +--
 drivers/md/raid1.h  |   5 --
 drivers/md/raid10.h |   5 --
 drivers/md/raid5.h  |   1 -
 drivers/md/md.c     | 138 +++++++++++++++++------------------
 drivers/md/raid1.c  |  77 +++++++++-----------
 drivers/md/raid10.c | 171 ++++++++++++++------------------------------
 drivers/md/raid5.c  |  40 ++++-------
 8 files changed, 174 insertions(+), 274 deletions(-)

-- 
2.39.2

