Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D393271F8;
	Thu, 30 Oct 2025 06:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806172; cv=none; b=WMrxTw36uYd1pu/jsFqNF+dHzyvOvc6dci3xM+poauLCNn81gq89zxzpHT6wsJbdbpocC+gJXnLVo0f2+SdqsaNHfW91uw9VAH9giGX4SM0aIy05+q46NS8ItWc7TaQ30MN8xlDX5uucXEIywz6Jjev9baiTGqxCkVOcF23T7lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806172; c=relaxed/simple;
	bh=3HwpgOEOC3gF3put2iqdQQD+9ZFq21eIOGrz5jmplg8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LPZBaHBxdP61yg+S0e9DBq92gE5xfWG+6YQbRVwUPI49wnACeeO0oEFcDw0vvpxTP2tqQN5EXIREJQAHz+ADZuZsDjc3oSm6UmX5ONax/CxSd07mdOFf1mrx009C/J6Edt+dHOe04jRvLnS6Syf4Ez0i4p80CFg/prwOpDAl1ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cxvVg10cKzKHMN6;
	Thu, 30 Oct 2025 14:35:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5AE391A0E99;
	Thu, 30 Oct 2025 14:36:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgDnPUZUBwNpEqJkCA--.9906S5;
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
Subject: [PATCH v8 1/4] md: delete md_redundancy_group when array is becoming inactive
Date: Thu, 30 Oct 2025 14:28:04 +0800
Message-Id: <20251030062807.1515356-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251030062807.1515356-1-linan666@huaweicloud.com>
References: <20251030062807.1515356-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnPUZUBwNpEqJkCA--.9906S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWktF4UJrW5CFy8Xr4rAFb_yoW8CF4Dpr
	Z5KryYkr15tw1Iyw4DZa48Wa45Aa1xXr9rXrZ7Cw1jva4xZw47CFWagFW0qr9rCFWxCFWr
	Xa1DAFZ8W3Z2kaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU46wtUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

'md_redundancy_group' are created in md_run() and deleted in del_gendisk(),
but these are not paired. Writing inactive/active to sysfs array_state can
trigger md_run() multiple times without del_gendisk(), leading to
duplicate creation as below:

 sysfs: cannot create duplicate filename '/devices/virtual/block/md0/md/sync_action'
 Call Trace:
  dump_stack_lvl+0x9f/0x120
  dump_stack+0x14/0x20
  sysfs_warn_dup+0x96/0xc0
  sysfs_add_file_mode_ns+0x19c/0x1b0
  internal_create_group+0x213/0x830
  sysfs_create_group+0x17/0x20
  md_run+0x856/0xe60
  ? __x64_sys_openat+0x23/0x30
  do_md_run+0x26/0x1d0
  array_state_store+0x559/0x760
  md_attr_store+0xc9/0x1e0
  sysfs_kf_write+0x6f/0xa0
  kernfs_fop_write_iter+0x141/0x2a0
  vfs_write+0x1fc/0x5a0
  ksys_write+0x79/0x180
  __x64_sys_write+0x1d/0x30
  x64_sys_call+0x2818/0x2880
  do_syscall_64+0xa9/0x580
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 md: cannot register extra attributes for md0

Creation of it depends on 'pers', its lifecycle cannot be aligned with
gendisk. So fix this issue by triggering 'md_redundancy_group' deletion
when the array is becoming inactive.

Fixes: 790abe4d77af ("md: remove/add redundancy group only in level change")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fa13eb02874e..f6fd55a1637b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6878,6 +6878,10 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (!md_is_rdwr(mddev))
 			set_disk_ro(disk, 0);
 
+		if (mode == 2 && mddev->pers->sync_request &&
+		    mddev->to_remove == NULL)
+			mddev->to_remove = &md_redundancy_group;
+
 		__md_stop_writes(mddev);
 		__md_stop(mddev);
 
-- 
2.39.2

