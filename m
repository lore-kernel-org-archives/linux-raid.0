Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AAD156CA;
	Wed, 30 Jul 2025 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753861226; cv=none; b=RgQNwkk3Uwb8fvOiI0RKrfjcBBDnOJ39Kn3clZU7+KhnyuwhUVn2KxT8tQ36suxOksK7UDaq4jUxDI+FJ2d8Ie3OvoIwQDpvL0xfY4IImxieszmPYx6NaUgKK7pshbW5eBa/VJFA/bcItRERFicSgmKRy/kjfifH8W0ZKTurgr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753861226; c=relaxed/simple;
	bh=BTXi/F3yyZKriEG4vjo4oa52GNvOBnc3dZaZErGy21o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iQi+JyJWFVbKallnB/sy3FQHPoOSxJgr7nG9aI0eqYaUPcmM/fbw1/KOw1+MzrACyR82m4yHCRtFNptjtD2t0PHIbdobuJk8Z5ML2f4kMfm05YHLeZ5incKwGCHQGEvwCpjQUSs8FNL4C08JuyyjVgsRm269aUd0dHnVQG+Y3+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bsPJJ186GzKHMWJ;
	Wed, 30 Jul 2025 15:40:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C5B41A0F86;
	Wed, 30 Jul 2025 15:40:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBFazIlodfjhBw--.53526S4;
	Wed, 30 Jul 2025 15:40:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: contact@arnaud-lcm.com,
	hdanton@sina.com,
	song@kernel.org,
	yukuai3@huawei.com,
	xni@redhat.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH] md: fix create on open mddev lifetime regression
Date: Wed, 30 Jul 2025 15:33:21 +0800
Message-Id: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBFazIlodfjhBw--.53526S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW7Wry5tr4UAr4DCFWfKrg_yoW8Kr18pa
	yrJFs0yryUtFyfJ3yUt34DuFyrXwna9FZ2grW7Gwn8ua4fCw4UWw4S9r4qgr1DGayrJFs0
	v3Wjv3WkZFy0grUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Commit 9e59d609763f ("md: call del_gendisk in control path") move
setting MD_DELETED from __mddev_put() to do_md_stop(), however, for the
case create on open, mddev can be freed without do_md_stop():

1) open

md_probe
 md_alloc_and_put
  md_alloc
   mddev_alloc
   atomic_set(&mddev->active, 1);
   mddev->hold_active = UNTIL_IOCTL
  mddev_put
   atomic_dec_and_test(&mddev->active)
    if (mddev->hold_active)
    -> active is 0, hold_active is set
md_open
 mddev_get
  atomic_inc(&mddev->active);

2) ioctl that is not STOP_ARRAY, for example, GET_ARRAY_INFO:

md_ioctl
 mddev->hold_active = 0

3) close

md_release
 mddev_put(mddev);
  atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)
  __mddev_put
  -> hold_active is cleared, mddev will be freed
  queue_work(md_misc_wq, &mddev->del_work)

Now that MD_DELETED is not set, before mddev is freed by
mddev_delayed_delete(), md_open can still succeed and break mddev
lifetime, causing mddev->kobj refcount underflow or mddev uaf
problem.

Fix this problem by setting MD_DELETED before queuing del_work.

Reported-by: syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0012.GAE@google.com/
Reported-by: syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0013.GAE@google.com/
Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 046fe85c76fe..5289dcc3a6af 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -636,6 +636,12 @@ static void __mddev_put(struct mddev *mddev)
 	    mddev->ctime || mddev->hold_active)
 		return;
 
+	/*
+	 * If array is freed by stopping array, MD_DELETED is set by
+	 * do_md_stop(), MD_DELETED is still set here in cause mddev is freed
+	 * directly by closing a mddev that is created by create_on_open.
+	 */
+	set_bit(MD_DELETED, &mddev->flags);
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
-- 
2.39.2

