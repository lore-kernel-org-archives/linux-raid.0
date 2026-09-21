Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4C3B8D41;
	Mon, 21 Sep 2026 07:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975436; cv=none; b=sH6AFVwRthThNL9DRDvcS3NcD+dYyzecOaS1UJX6g5pMRx7stWCkJ5ZMFg7dab9+W0AT2IpU+hQgcLkIEmY14cCFRx0x9SSOybyfIR/vXYaQOM/Pvfm75P2vTFbdaUNNGoRW7bxhoGORBJ+GfzaBcdPjbJETR3geXua8xE/ug0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975436; c=relaxed/simple;
	bh=KEUPBL54615weRyUwbUQob5rLs7Iwbct1zpw6tsonQU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sy5OBofGDVEUWsSPjryqkTBr0DomI8zp+/u1/JC6R3nsKseS4MgYwhsbUTEjZ4e+Oq66ARxlp7tTb/F29cAyDQfdVo+uVjQwRpRJ/OaOCypeLLxyu81Yr/w6dLw2LJAkJaEDJcZ06zdmVTenefFZ0BunVrEDr9EdRzST5F7NBvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4hFlw4Xt; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4hFlw4Xt"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oVi60O73/8T5TVpPXwgizHbL8pP8zx0+PMJEBZkQ/EI=;
	b=4hFlw4XtRGC28C4OFPTI9z9gqgZ3xbl8Bw2XvPq/J//bO2D1Nxc7ertOJe0GyxE5AZTq2RwHq
	m4/Or8zWvF0S3NxD9UK9nSVEoFxC4IksTI5PRDYuISSMOY9GN7E8MlHxaPWVdD7ujIkx23rFLdb
	ralqWO4E1w5IyVDlvZ7ONuk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hpDtW1KY3zpSy4;
	Mon, 21 Sep 2026 15:11:47 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 683424057F;
	Mon, 21 Sep 2026 15:23:41 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 15:23:40 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 3/3] md/raid10: Don't free conf on raid10_run failure
Date: Mon, 21 Sep 2026 15:15:36 +0800
Message-ID: <20260921071537.2902362-4-chengzhihao1@huawei.com>
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
 BUG: kernel NULL pointer dereference, address: 00000000000000dc
 RIP: 0010:_raw_spin_lock_irq+0x3d
 Call Trace:
  raise_barrier+0x3a
  raid10_quiesce+0x20
  __md_stop_writes+0x6c
  do_md_stop+0xaa

The trigger process is simple:
 mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sda /dev/sdb
 --force --assume-clean # create raid0
 echo 10 > /sys/block/md0/md/level
  level_store
   mddev->pers = pers
   mddev->private = priv
   raid10_run
   fail to out_free_conf (eg. enough fails)
    raid10_free_conf(conf)
    mddev->private = NULL
 echo inactive > /sys/block/md0/md/array_state
  array_state_store
   do_md_stop
    __md_stop_writes
     raid10_quiesce
      raise_barrier
       write_seqlock_irq(&conf->resync_lock) // null-ptr-deref !

Just like commit 35f20acaa358 ("md/raid0: don't free conf on raid0_run
failure") does, fix it by not free conf on raid10_run failure.

Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid10.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..9e4d4202f35c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3972,7 +3972,7 @@ static int raid10_run(struct mddev *mddev)
 		if (fc > 1 || fo > 0) {
 			pr_err("only near layout is supported by clustered"
 				" raid10\n");
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 	}
 
@@ -3989,11 +3989,11 @@ static int raid10_run(struct mddev *mddev)
 
 		if (test_bit(Replacement, &rdev->flags)) {
 			if (disk->replacement)
-				goto out_free_conf;
+				goto out_unregister_thread;
 			disk->replacement = rdev;
 		} else {
 			if (disk->rdev)
-				goto out_free_conf;
+				goto out_unregister_thread;
 			disk->rdev = rdev;
 		}
 		diff = (rdev->new_data_offset - rdev->data_offset);
@@ -4013,7 +4013,7 @@ static int raid10_run(struct mddev *mddev)
 
 		if (err) {
 			ret = err;
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 	}
 
@@ -4021,17 +4021,17 @@ static int raid10_run(struct mddev *mddev)
 	if (!enough(conf, -1)) {
 		pr_err("md/raid10:%s: not enough operational mirrors.\n",
 		       mdname(mddev));
-		goto out_free_conf;
+		goto out_unregister_thread;
 	}
 
 	if (conf->reshape_progress != MaxSector) {
 		/* must ensure that shape change is supported */
 		if (conf->geo.far_copies != 1 &&
 		    conf->geo.far_offset == 0)
-			goto out_free_conf;
+			goto out_unregister_thread;
 		if (conf->prev.far_copies != 1 &&
 		    conf->prev.far_offset == 0)
-			goto out_free_conf;
+			goto out_unregister_thread;
 	}
 
 	mddev->degraded = 0;
@@ -4081,7 +4081,7 @@ static int raid10_run(struct mddev *mddev)
 	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	if (md_integrity_register(mddev))
-		goto out_free_conf;
+		goto out_unregister_thread;
 
 	if (conf->reshape_progress != MaxSector) {
 		unsigned long before_length, after_length;
@@ -4094,7 +4094,7 @@ static int raid10_run(struct mddev *mddev)
 		if (max(before_length, after_length) > min_offset_diff) {
 			/* This cannot work */
 			pr_warn("md/raid10: offset difference not enough to continue reshape\n");
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 		conf->offset_diff = min_offset_diff;
 
@@ -4106,10 +4106,8 @@ static int raid10_run(struct mddev *mddev)
 
 	return 0;
 
-out_free_conf:
+out_unregister_thread:
 	md_unregister_thread(mddev, &mddev->thread);
-	raid10_free_conf(conf);
-	mddev->private = NULL;
 out:
 	return ret;
 }
-- 
2.52.0

