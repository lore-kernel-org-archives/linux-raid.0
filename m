Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8156DCE1;
	Mon, 30 Mar 2026 05:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849945; cv=none; b=TCq4Bn+NrFJaAXsEsaYaUv+rW4pxcB3eYDb5kzcBTDjuXsR6EpJ6LZ3cz/8Y8XRobcIY11b4+7hsPvPkYwc5BVuOGDAto0Paf763uJJMCC7UJ55Q2sYUF44NYp0IYjFoC/dYZ5KEN7ZlY9hBbGMn0X/I8oVAed2TQ44DKwbLkHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849945; c=relaxed/simple;
	bh=qKjwRyXt/7geCwmru+WKM8RvDVcGeV6+s985xeZSFs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=php9+AwDFDY7XWisFy4yA5pUdSsWhyCSdJw60+4qz4lUUvibf+9sX7IauOIxIRgw/tyvMlv4od794uFEgUOm9sX7kAEfhtd2OoraK0NIrKnrFPAWOahjUP904FzgmE20tJ7KWQLT2dfATm2hXZIj0LfMf8yhma8Vw5Hoqfp1zic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5248AC4CEF7;
	Mon, 30 Mar 2026 05:52:23 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md: fix array_state=clear sysfs deadlock
Date: Mon, 30 Mar 2026 13:52:13 +0800
Message-ID: <20260330055213.3976052-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

When "clear" is written to array_state, md_attr_store() breaks sysfs
active protection so the array can delete itself from its own sysfs
store method.

However, md_attr_store() currently drops the mddev reference before
calling sysfs_unbreak_active_protection(). Once do_md_stop(..., 0)
has made the mddev eligible for delayed deletion, the temporary
kobject reference taken by sysfs_break_active_protection() can become
the last kobject reference protecting the md kobject.

That allows sysfs_unbreak_active_protection() to drop the last
kobject reference from the current sysfs writer context. kobject
teardown then recurses into kernfs removal while the current sysfs
node is still being unwound, and lockdep reports recursive locking on
kn->active with kernfs_drain() in the call chain.

Reproducer on an existing level:
1. Create an md0 linear array and activate it:
   mknod /dev/md0 b 9 0
   echo none > /sys/block/md0/md/metadata_version
   echo linear > /sys/block/md0/md/level
   echo 1 > /sys/block/md0/md/raid_disks
   echo "$(cat /sys/class/block/sdb/dev)" > /sys/block/md0/md/new_dev
   echo "$(($(cat /sys/class/block/sdb/size) / 2))" > \
	/sys/block/md0/md/dev-sdb/size
   echo 0 > /sys/block/md0/md/dev-sdb/slot
   echo active > /sys/block/md0/md/array_state
2. Wait briefly for the array to settle, then clear it:
   sleep 2
   echo clear > /sys/block/md0/md/array_state

The warning looks like:

  WARNING: possible recursive locking detected
  bash/588 is trying to acquire lock:
  (kn->active#65) at __kernfs_remove+0x157/0x1d0
  but task is already holding lock:
  (kn->active#65) at sysfs_unbreak_active_protection+0x1f/0x40
  ...
  Call Trace:
   kernfs_drain
   __kernfs_remove
   kernfs_remove_by_name_ns
   sysfs_remove_group
   sysfs_remove_groups
   __kobject_del
   kobject_put
   md_attr_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write

Restore active protection before mddev_put() so the extra sysfs
kobject reference is dropped while the mddev is still held alive. The
actual md kobject deletion is then deferred until after the sysfs
write path has fully returned.

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 521d9b34cd9e..02efe9700256 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6130,10 +6130,16 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	}
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
-	mddev_put(mddev);
 
+	/*
+	 * For "array_state=clear", dropping the extra kobject reference from
+	 * sysfs_break_active_protection() can trigger md kobject deletion.
+	 * Restore active protection before mddev_put() so deletion happens
+	 * after the sysfs write path fully unwinds.
+	 */
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	mddev_put(mddev);
 
 	return rv;
 }
-- 
2.51.0

