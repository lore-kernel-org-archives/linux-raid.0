Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C557C433ED
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A3236054E
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbhDCQPo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhDCQPn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 12:15:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D39C0613E6
        for <linux-raid@vger.kernel.org>; Sat,  3 Apr 2021 09:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cAlF/KrWc/pMzeAt/hzNMNJI+b+BrYVrpeDSKqLKOtY=; b=KmqMi485D7q21u28HUGi3r99ol
        lbqIdErei3SkEwzMvIYk+sOEHb5u/+a+NrRDi+uyX404eh/gJixO7wXdPMM/2Wa5Sd9BsEMYzfJVB
        o8K1jb5eSEhQAJR2FTnrGEtNuWWpTFfiTmqPuzlJog/qRbOoWe0FxoEmWZO5eYP6Ppy24IlTNX97Y
        5wmXfGAwRbq89xpAjlA5d7aNQBA4lmczXa7ehov4ipcf13MsfnMgJUvEG418xEETfQjPO57YSdCHw
        Tmrs/DNh+8jGH5+UGfy6Vxr5/bXILPsuJb/Ps5i/WEox0wVVyPcvrwJncUeB8LNyDyuRi0zrkvFgY
        OsfFED6g==;
Received: from [2001:4bb8:180:7517:4144:afdd:43c5:e0fc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSivx-000PJ9-CE; Sat, 03 Apr 2021 16:15:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org, Zhao Heming <heming.zhao@suse.com>
Cc:     lidong.zhong@suse.com, linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md: split mddev_find
Date:   Sat,  3 Apr 2021 18:15:29 +0200
Message-Id: <20210403161529.659555-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210403161529.659555-1-hch@lst.de>
References: <20210403161529.659555-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Split mddev_find into a simple mddev_find that just finds an existing
mddev by the unit number, and a more complicated mddev_find that deals
with find or allocating a mddev.

This turns out to fix this bug reported by
Zhao Heming <heming.zhao@suse.com>:

------------------------------ snip ------------------------------
commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

*** env ***
kvm-qemu VM 2C1G with 2 iscsi luns
kernel should be non-preempt

*** script ***

about trigger 1 time with 10 tests

```
1  node1="15sp3-mdcluster1"
2  node2="15sp3-mdcluster2"
3
4  mdadm -Ss
5  ssh ${node2} "mdadm -Ss"
6  wipefs -a /dev/sda /dev/sdb
7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
   /dev/sdb --assume-clean
8
9  for i in {1..100}; do
10    echo ==== $i ====;
11
12    echo "test  ...."
13    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
14    sleep 1
15
16    echo "clean  ....."
17    ssh ${node2} "mdadm -Ss"
18 done
```

I use mdcluster env to trigger soft lockup, but it isn't mdcluster
speical bug. To stop md array in mdcluster env will do more jobs than
non-cluster array, which will leave enough time/gap to allow kernel to
run md_open.

*** stack ***

```
ID: 2831   TASK: ffff8dd7223b5040  CPU: 0   COMMAND: "mdadm"
 #0 [ffffa15d00a13b90] __schedule at ffffffffb8f1935f
 #1 [ffffa15d00a13ba8] exact_lock at ffffffffb8a4a66d
 #2 [ffffa15d00a13bb0] kobj_lookup at ffffffffb8c62fe3
 #3 [ffffa15d00a13c28] __blkdev_get at ffffffffb89273b9
 #4 [ffffa15d00a13c98] blkdev_get at ffffffffb8927964
 #5 [ffffa15d00a13cb0] do_dentry_open at ffffffffb88dc4b4
 #6 [ffffa15d00a13ce0] path_openat at ffffffffb88f0ccc
 #7 [ffffa15d00a13db8] do_filp_open at ffffffffb88f32bb
 #8 [ffffa15d00a13ee0] do_sys_open at ffffffffb88ddc7d
 #9 [ffffa15d00a13f38] do_syscall_64 at ffffffffb86053cb ffffffffb900008c

or:
[  884.226509]  mddev_put+0x1c/0xe0 [md_mod]
[  884.226515]  md_open+0x3c/0xe0 [md_mod]
[  884.226518]  __blkdev_get+0x30d/0x710
[  884.226520]  ? bd_acquire+0xd0/0xd0
[  884.226522]  blkdev_get+0x14/0x30
[  884.226524]  do_dentry_open+0x204/0x3a0
[  884.226531]  path_openat+0x2fc/0x1520
[  884.226534]  ? seq_printf+0x4e/0x70
[  884.226536]  do_filp_open+0x9b/0x110
[  884.226542]  ? md_release+0x20/0x20 [md_mod]
[  884.226543]  ? seq_read+0x1d8/0x3e0
[  884.226545]  ? kmem_cache_alloc+0x18a/0x270
[  884.226547]  ? do_sys_open+0x1bd/0x260
[  884.226548]  do_sys_open+0x1bd/0x260
[  884.226551]  do_syscall_64+0x5b/0x1e0
[  884.226554]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
```

*** rootcause ***

"mdadm -A" (or other array assemble commands) will start a daemon "mdadm
--monitor" by default. When "mdadm -Ss" is running, the stop action will
wakeup "mdadm --monitor". The "--monitor" daemon will immediately get
info from /proc/mdstat. This time mddev in kernel still exist, so
/proc/mdstat still show md device, which makes "mdadm --monitor" to open
/dev/md0.

The previously "mdadm -Ss" is removing action, the "mdadm --monitor"
open action will trigger md_open which is creating action. Racing is
happening.

```
<thread 1>: "mdadm -Ss"
md_release
  mddev_put deletes mddev from all_mddevs
  queue_work for mddev_delayed_delete
  at this time, "/dev/md0" is still available for opening

<thread 2>: "mdadm --monitor ..."
md_open
 + mddev_find can't find mddev of /dev/md0, and create a new mddev and
 |    return.
 + trigger "if (mddev->gendisk != bdev->bd_disk)" and return
      -ERESTARTSYS.
```

In non-preempt kernel, <thread 2> is occupying on current CPU. and
mddev_delayed_delete which was created in <thread 1> also can't be
schedule.

In preempt kernel, it can also trigger above racing. But kernel doesn't
allow one thread running on a CPU all the time. after <thread 2> running
some time, the later "mdadm -A" (refer above script line 13) will call
md_alloc to alloc a new gendisk for mddev. it will break md_open
statement "if (mddev->gendisk != bdev->bd_disk)" and return 0 to caller,
the soft lockup is broken.
------------------------------ snip ------------------------------

Fixes: d3374825ce57 ("md: make devices disappear when they are no longer needed.")
Reported-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5692427e78ba37..08d24177bbd4a4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -746,6 +746,22 @@ static struct mddev *mddev_find_locked(dev_t unit)
 }
 
 static struct mddev *mddev_find(dev_t unit)
+{
+	struct mddev *mddev;
+
+	if (MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	mddev = mddev_find_locked(unit);
+	if (mddev)
+		mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
+
+	return mddev;
+}
+
+static struct mddev *mddev_find_or_alloc(dev_t unit)
 {
 	struct mddev *mddev, *new = NULL;
 
@@ -5650,7 +5666,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find_or_alloc(dev);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6530,11 +6546,9 @@ static void autorun_devices(int part)
 
 		md_probe(dev);
 		mddev = mddev_find(dev);
-		if (!mddev || !mddev->gendisk) {
-			if (mddev)
-				mddev_put(mddev);
+		if (!mddev)
 			break;
-		}
+
 		if (mddev_lock(mddev))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
-- 
2.30.1

