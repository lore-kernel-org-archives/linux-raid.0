Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FB8C77B70
	for <linux-raid@archiver.kernel.org>; Mon, 17 Apr 2023 14:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDQODw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Apr 2023 10:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDQODv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Apr 2023 10:03:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4A31FDE
        for <linux-raid@vger.kernel.org>; Mon, 17 Apr 2023 07:03:10 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [7.193.23.86])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q0TGd3xNyzrcH3;
        Mon, 17 Apr 2023 22:00:41 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 22:02:09 +0800
From:   Li Xiao Keng <lixiaokeng@huawei.com>
To:     <jes@trained-monkey.org>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     <miaoguanqin@huawei.com>, <louhongxiang@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: [PATCH] Fix race of "mdadm --add" and "mdadm --incremental"
Date:   Mon, 17 Apr 2023 22:01:44 +0800
Message-ID: <20230417140144.3013024-1-lixiaokeng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.170]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600010.china.huawei.com (7.193.23.86)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we add a new disk to a raid, it may return -EBUSY.

The main process of --add:
1. dev_open
2. store_super1(st, di->fd) in write_init_super1
3. fsync(di->fd) in write_init_super1
4. close(di->fd)
5. ioctl(ADD_NEW_DISK)

However, there will be some udev(change) event after step4. Then
"/usr/sbin/mdadm --incremental ..." will be run, and the new disk
will be add to md device. After that, ioctl will return -EBUSY.

Here we add map_lock before write_init_super in "mdadm --add"
to fix this race.

Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
---
 Assemble.c |  5 ++++-
 Manage.c   | 25 +++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 49804941..086890ed 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1479,8 +1479,11 @@ try_again:
 	 * to our list.  We flag them so that we don't try to re-add,
 	 * but can remove if they turn out to not be wanted.
 	 */
-	if (map_lock(&map))
+	if (map_lock(&map)) {
 		pr_err("failed to get exclusive lock on mapfile - continue anyway...\n");
+		return 1;
+	}
+
 	if (c->update == UOPT_UUID)
 		mp = NULL;
 	else
diff --git a/Manage.c b/Manage.c
index f54de7c6..6a101bae 100644
--- a/Manage.c
+++ b/Manage.c
@@ -703,6 +703,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	struct supertype *dev_st;
 	int j;
 	mdu_disk_info_t disc;
+	struct map_ent *map = NULL;
 
 	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
 		if (dv->disposition == 'M')
@@ -900,6 +901,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		disc.raid_disk = 0;
 	}
 
+	if (map_lock(&map)) {
+		pr_err("failed to get exclusive lock on mapfile when add disk\n");
+		return -1;
+	}
 	if (array->not_persistent==0) {
 		int dfd;
 		if (dv->disposition == 'j')
@@ -911,9 +916,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (tst->ss->add_to_super(tst, &disc, dfd,
 					  dv->devname, INVALID_SECTORS))
-			return -1;
+			goto unlock;
 		if (tst->ss->write_init_super(tst))
-			return -1;
+			goto unlock;
 	} else if (dv->disposition == 'A') {
 		/*  this had better be raid1.
 		 * As we are "--re-add"ing we must find a spare slot
@@ -971,14 +976,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			pr_err("add failed for %s: could not get exclusive access to container\n",
 			       dv->devname);
 			tst->ss->free_super(tst);
-			return -1;
+			goto unlock;
 		}
 
 		/* Check if metadata handler is able to accept the drive */
 		if (!tst->ss->validate_geometry(tst, LEVEL_CONTAINER, 0, 1, NULL,
 		    0, 0, dv->devname, NULL, 0, 1)) {
 			close(container_fd);
-			return -1;
+			goto unlock;
 		}
 
 		Kill(dv->devname, NULL, 0, -1, 0);
@@ -987,7 +992,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 					  dv->devname, INVALID_SECTORS)) {
 			close(dfd);
 			close(container_fd);
-			return -1;
+			goto unlock;
 		}
 		if (!mdmon_running(tst->container_devnm))
 			tst->ss->sync_metadata(tst);
@@ -998,7 +1003,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			       dv->devname);
 			close(container_fd);
 			tst->ss->free_super(tst);
-			return -1;
+			goto unlock;
 		}
 		sra->array.level = LEVEL_CONTAINER;
 		/* Need to set data_offset and component_size */
@@ -1013,7 +1018,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			pr_err("add new device to external metadata failed for %s\n", dv->devname);
 			close(container_fd);
 			sysfs_free(sra);
-			return -1;
+			goto unlock;
 		}
 		ping_monitor(devnm);
 		sysfs_free(sra);
@@ -1027,7 +1032,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			else
 				pr_err("add new device failed for %s as %d: %s\n",
 				       dv->devname, j, strerror(errno));
-			return -1;
+			goto unlock;
 		}
 		if (dv->disposition == 'j') {
 			pr_err("Journal added successfully, making %s read-write\n", devname);
@@ -1038,7 +1043,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	}
 	if (verbose >= 0)
 		pr_err("added %s\n", dv->devname);
+	map_unlock(&map);
 	return 1;
+unlock:
+	map_unlock(&map);
+	return -1;
 }
 
 int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
-- 
2.33.0

