Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098FA2DF706;
	Mon, 27 Oct 2025 07:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550635; cv=none; b=sh57L7FrSqIkiBbv3WOb1hqaJCUDnNdQYbkMatQc9D3yPiRzR28A32VSVa0K1jEONgaApEKtWGe+Pko3OjWP2qQ9RzPy/lUMasJpvmXPUFlD9WAwbpuzUz+56Hpf1/Vo1nK4OB8lYWCobE+fD7vvPCuhuocjVGPt6DfT4lLexew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550635; c=relaxed/simple;
	bh=3HwpgOEOC3gF3put2iqdQQD+9ZFq21eIOGrz5jmplg8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B21OgxRH31O4IB6ZRTLWs7chLaGvk71eQaHwIw1On9qSV6PxCJ28rOBl553MA42OC+fQ9TCOLHcPUjRkZW3gdDzvq/qezB8rahU1Sbx3BVeaElHRIgzPCvdWj0jAMqMFkyLTLczwAs15KgYl+9qCVwsDeB8s7WMVL6+SnMY0oYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=kMoW1y3V; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="kMoW1y3V"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y7HQy/x8hqZcaAq7f+oSEs4u0uGf4OTgzgEpYuVkks0=;
	b=kMoW1y3V+P8cZkxbIZL2hdYQjUbCb8Fry5k4yNgzqi/vE2aYTFMP8MYaRrb4Gs0YZtgLoyEY0
	RVEaI5qQG96jd6k/X6SqDTAp6G+Z6YglR6yXa55gPjal1iXhs+Jr76ZcN6GYgs0qebvxlmx+A5l
	LNIHv7vh+0gNco2ayK2ZdU0=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cw4zz6WYkzcZxv;
	Mon, 27 Oct 2025 15:35:43 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 03896180489;
	Mon, 27 Oct 2025 15:37:04 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Oct 2025 15:37:03 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 15:37:03 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai@fnnas.com>,
	<linan122@huawei.com>, <hare@suse.de>, <xni@redhat.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v7 1/4] md: delete md_redundancy_group when array is becoming inactive
Date: Mon, 27 Oct 2025 15:29:12 +0800
Message-ID: <20251027072915.3014463-2-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251027072915.3014463-1-linan122@huawei.com>
References: <20251027072915.3014463-1-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn500011.china.huawei.com (7.202.194.152)

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

