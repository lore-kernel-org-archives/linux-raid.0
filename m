From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md: fix a potential deadlock
Date: Wed, 14 Sep 2016 14:26:54 -0700
Message-ID: <8ef93a9d6fcd27a78c58f80fe4932ab7c26a30f3.1473888282.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>
List-Id: linux-raid.ids

lockdep reports a potential deadlock. Fix this by droping the mutex
before md_import_device

[ 1137.126601] ======================================================
[ 1137.127013] [ INFO: possible circular locking dependency detected ]
[ 1137.127013] 4.8.0-rc4+ #538 Not tainted
[ 1137.127013] -------------------------------------------------------
[ 1137.127013] mdadm/16675 is trying to acquire lock:
[ 1137.127013]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81243cf3>] __blkdev_get+0x63/0x450
[ 1137.127013]
but task is already holding lock:
[ 1137.127013]  (detected_devices_mutex){+.+.+.}, at: [<ffffffff81a5138c>] md_ioctl+0x2ac/0x1f50
[ 1137.127013]
which lock already depends on the new lock.

[ 1137.127013]
the existing dependency chain (in reverse order) is:
[ 1137.127013]
-> #1 (detected_devices_mutex){+.+.+.}:
[ 1137.127013]        [<ffffffff810b6f19>] lock_acquire+0xb9/0x220
[ 1137.127013]        [<ffffffff81c51647>] mutex_lock_nested+0x67/0x3d0
[ 1137.127013]        [<ffffffff81a4eeaf>] md_autodetect_dev+0x3f/0x90
[ 1137.127013]        [<ffffffff81595be8>] rescan_partitions+0x1a8/0x2c0
[ 1137.127013]        [<ffffffff81590081>] __blkdev_reread_part+0x71/0xb0
[ 1137.127013]        [<ffffffff815900e5>] blkdev_reread_part+0x25/0x40
[ 1137.127013]        [<ffffffff81590c4b>] blkdev_ioctl+0x51b/0xa30
[ 1137.127013]        [<ffffffff81242bf1>] block_ioctl+0x41/0x50
[ 1137.127013]        [<ffffffff81214c96>] do_vfs_ioctl+0x96/0x6e0
[ 1137.127013]        [<ffffffff81215321>] SyS_ioctl+0x41/0x70
[ 1137.127013]        [<ffffffff81c56825>] entry_SYSCALL_64_fastpath+0x18/0xa8
[ 1137.127013]
-> #0 (&bdev->bd_mutex){+.+.+.}:
[ 1137.127013]        [<ffffffff810b6af2>] __lock_acquire+0x1662/0x1690
[ 1137.127013]        [<ffffffff810b6f19>] lock_acquire+0xb9/0x220
[ 1137.127013]        [<ffffffff81c51647>] mutex_lock_nested+0x67/0x3d0
[ 1137.127013]        [<ffffffff81243cf3>] __blkdev_get+0x63/0x450
[ 1137.127013]        [<ffffffff81244307>] blkdev_get+0x227/0x350
[ 1137.127013]        [<ffffffff812444f6>] blkdev_get_by_dev+0x36/0x50
[ 1137.127013]        [<ffffffff81a46d65>] lock_rdev+0x35/0x80
[ 1137.127013]        [<ffffffff81a49bb4>] md_import_device+0xb4/0x1b0
[ 1137.127013]        [<ffffffff81a513d6>] md_ioctl+0x2f6/0x1f50
[ 1137.127013]        [<ffffffff815909b3>] blkdev_ioctl+0x283/0xa30
[ 1137.127013]        [<ffffffff81242bf1>] block_ioctl+0x41/0x50
[ 1137.127013]        [<ffffffff81214c96>] do_vfs_ioctl+0x96/0x6e0
[ 1137.127013]        [<ffffffff81215321>] SyS_ioctl+0x41/0x70
[ 1137.127013]        [<ffffffff81c56825>] entry_SYSCALL_64_fastpath+0x18/0xa8
[ 1137.127013]
other info that might help us debug this:

[ 1137.127013]  Possible unsafe locking scenario:

[ 1137.127013]        CPU0                    CPU1
[ 1137.127013]        ----                    ----
[ 1137.127013]   lock(detected_devices_mutex);
[ 1137.127013]                                lock(&bdev->bd_mutex);
[ 1137.127013]                                lock(detected_devices_mutex);
[ 1137.127013]   lock(&bdev->bd_mutex);
[ 1137.127013]
 *** DEADLOCK ***

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cd6797b..457b538 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8882,7 +8882,9 @@ static void autostart_arrays(int part)
 		list_del(&node_detected_dev->list);
 		dev = node_detected_dev->dev;
 		kfree(node_detected_dev);
+		mutex_unlock(&detected_devices_mutex);
 		rdev = md_import_device(dev,0, 90);
+		mutex_lock(&detected_devices_mutex);
 		if (IS_ERR(rdev))
 			continue;
 
-- 
2.8.0.rc2

