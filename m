Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4972B3B8939;
	Mon, 21 Sep 2026 07:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975437; cv=none; b=GWQYiZTY7IZlXT3NgWp/47kaZ/mD2FWH8hs4m9EonswQnk0mhgiFLlPLdORlX+CEzDZzlPNK32ONG/u1wGnbgNsHOdMUiPCBbp/CDAJy4T9ImcsENbFdiu0kt3nY08rW2Xn1YiIcpN2JvzK9p60P9lO6Ufpt+3ceoC5DOa/l5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975437; c=relaxed/simple;
	bh=dUezfQ/yTDCfQhHSobhiYmgjAque3re0xS4R43wf6tw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qpghSotFi4l/gfPvG3YEZaxSz1Gv3gL3pQLNGw+dg5XSpFepOrjmrJTfo8HCnREMzz9YoC5ovYZGeeb/OWJLMT4VtjLZuBNs7IulGx7oT9ujHsdDhajZqjBGaWMyt8OzSZV8C7h1L5/CsQj1rYShF3JLLq+c3BUwANFBwfDGH6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=K4N6IRxs; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="K4N6IRxs"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=q2RGVJPNOoEoks8aAaWtb8od8gkNXIWnWWblok4byvY=;
	b=K4N6IRxs+Nleg3SVHB8+GgPAu9kAX9NIOzCKqUAK5NmpMfY8C9PSzNldD/7/ZssGFox7YrJsW
	PDKltjNxCenrUuIXDM5pIDyXvh7nt85mRUDqTmiEuRq3JQWVaHjE4qJjZohFTOngUrwdDTQHjhv
	Xp3s2NhlnZO4V4NztTJZQw4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hpDtV34F4zpSy4;
	Mon, 21 Sep 2026 15:11:46 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id A482540561;
	Mon, 21 Sep 2026 15:23:40 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 15:23:39 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 2/3] md/raid5: Don't free conf on raid5_run failure
Date: Mon, 21 Sep 2026 15:15:35 +0800
Message-ID: <20260921071537.2902362-3-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260921071537.2902362-1-chengzhihao1@huawei.com>
References: <20260921071537.2902362-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200011.china.huawei.com (7.152.185.179)

Set 'raid_disks' after raid5_run() failure will trigger an
null-ptr-deref problem:
 BUG: kernel NULL pointer dereference, address: 0000000000000038
 RIP: 0010:raid5_check_reshape+0xad
 Call Trace:
  update_raid_disks+0x124
  raid_disks_store+0x145
  md_attr_store+0xd7
  sysfs_kf_write+0x7c

The trigger process is simple:
 mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
 --force --assume-clean # create raid1
 echo 5 > /sys/block/md0/md/level
  level_store
   mddev->pers = pers
   mddev->private = priv
   raid5_run
    fail to abort (eg. raid5_create_ctx_pool fails)
    mddev->private = NULL
 echo 10 > /sys/block/md0/md/raid_disks
  raid_disks_store
   if (mddev->pers) // true
    update_raid_disks
     raid5_check_reshape
      conf = mddev->private
       conf->algorithm = mddev->new_layout // null-ptr-deref !
 // similar process in do_md_stop->__md_stop_writes->raid5_quiesce

Just like commit 35f20acaa358 ("md/raid0: don't free conf on raid0_run
failure") does, fix it by not free conf on raid5_run failure.

Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid5.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7e87e8a60f5f..913e5a709e35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8263,8 +8263,6 @@ static int raid5_run(struct mddev *mddev)
 abort:
 	md_unregister_thread(mddev, &mddev->thread);
 	print_raid5_conf(conf);
-	free_conf(conf);
-	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
 	return ret;
 }
-- 
2.52.0

