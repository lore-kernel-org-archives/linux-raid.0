From: Andrew Lutomirski <luto@mit.edu>
Subject: md lockdep warning
Date: Thu, 13 May 2010 13:59:59 -0400
Message-ID: <AANLkTinSyowa-i2QvQmxtoMJ7sCM6ps76YLEQ4fhjKF-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got this warning on 2.6.34-rc7 (actually cea0d767c2 in -linus)
running mdadm --stop /dev/md0 when /dev/md0 was an improperly
assembled imsm array.  See
https://bugzilla.redhat.com/show_bug.cgi?id=592030 for how I got into
this state in the first place.


md: md0 stopped.
md: unbind<sda>
md: export_rdev(sda)

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.34-rc7 #1
-------------------------------------------------------
udisks-part-id/1152 is trying to acquire lock:
 (events){+.+.+.}, at: [<ffffffff81059342>] flush_workqueue+0x0/0xb9

but task is already holding lock:
 (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81132f31>] __blkdev_get+0x91/0x3a8

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&bdev->bd_mutex){+.+.+.}:
       [<ffffffff8106fa76>] __lock_acquire+0xb74/0xd22
       [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
       [<ffffffff81457feb>] __mutex_lock_common+0x4c/0x339
       [<ffffffff8145839c>] mutex_lock_nested+0x3e/0x43
       [<ffffffff81132f31>] __blkdev_get+0x91/0x3a8
       [<ffffffff81133258>] blkdev_get+0x10/0x12
       [<ffffffff811333ae>] open_by_devnum+0x2e/0x3f
       [<ffffffff81367df7>] lock_rdev+0x39/0xe4
       [<ffffffff8136d52a>] md_import_device+0xbe/0x27b
       [<ffffffff8136d805>] new_dev_store+0x11e/0x173
       [<ffffffff81367d9f>] md_attr_store+0x83/0xa2
       [<ffffffff81163687>] sysfs_write_file+0x108/0x144
       [<ffffffff8110c1db>] vfs_write+0xae/0x10b
       [<ffffffff8110c2f8>] sys_write+0x4a/0x6e
       [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b

-> #3 (&new->reconfig_mutex){+.+.+.}:
       [<ffffffff8106fa76>] __lock_acquire+0xb74/0xd22
       [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
       [<ffffffff81457feb>] __mutex_lock_common+0x4c/0x339
       [<ffffffff81458316>] mutex_lock_interruptible_nested+0x3e/0x43
       [<ffffffff81367cd9>] rdev_attr_store+0x65/0xa8
       [<ffffffff81163687>] sysfs_write_file+0x108/0x144
       [<ffffffff8110c1db>] vfs_write+0xae/0x10b
       [<ffffffff8110c2f8>] sys_write+0x4a/0x6e
       [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b

-> #2 (s_active#55){++++.+}:
       [<ffffffff8106fa76>] __lock_acquire+0xb74/0xd22
       [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
       [<ffffffff811642a2>] sysfs_deactivate+0xa0/0x109
       [<ffffffff81164ab9>] sysfs_addrm_finish+0x36/0x55
       [<ffffffff81164bbc>] sysfs_remove_dir+0x95/0xbe
       [<ffffffff812138d5>] kobject_del+0x16/0x37
       [<ffffffff813651eb>] md_delayed_delete+0x1d/0x29
       [<ffffffff81058a83>] worker_thread+0x266/0x35f
       [<ffffffff8105cb08>] kthread+0x9a/0xa2
       [<ffffffff81003a14>] kernel_thread_helper+0x4/0x10

-> #1 ((&rdev->del_work)){+.+...}:
       [<ffffffff8106fa76>] __lock_acquire+0xb74/0xd22
       [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
       [<ffffffff81058a7a>] worker_thread+0x25d/0x35f
       [<ffffffff8105cb08>] kthread+0x9a/0xa2
       [<ffffffff81003a14>] kernel_thread_helper+0x4/0x10

-> #0 (events){+.+.+.}:
       [<ffffffff8106f920>] __lock_acquire+0xa1e/0xd22
       [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
       [<ffffffff810593a5>] flush_workqueue+0x63/0xb9
       [<ffffffff81059410>] flush_scheduled_work+0x15/0x17
       [<ffffffff8136c00a>] md_open+0x3e/0x88
       [<ffffffff81132f85>] __blkdev_get+0xe5/0x3a8
       [<ffffffff81133258>] blkdev_get+0x10/0x12
       [<ffffffff811332d0>] blkdev_open+0x76/0xac
       [<ffffffff8110a5a5>] __dentry_open+0x1bf/0x32f
       [<ffffffff8110a7f9>] nameidata_to_filp+0x3f/0x50
       [<ffffffff81116110>] do_last+0x444/0x5b5
       [<ffffffff81117c3f>] do_filp_open+0x1e7/0x5da
       [<ffffffff8110a2b7>] do_sys_open+0x63/0x10f
       [<ffffffff8110a396>] sys_open+0x20/0x22
       [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by udisks-part-id/1152:
 #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81132f31>]
__blkdev_get+0x91/0x3a8

stack backtrace:
Pid: 1152, comm: udisks-part-id Not tainted 2.6.34-rc7 #1
Call Trace:
 [<ffffffff8106ead9>] print_circular_bug+0xae/0xbd
 [<ffffffff8106f920>] __lock_acquire+0xa1e/0xd22
 [<ffffffff8106fcf4>] lock_acquire+0xd0/0xf6
 [<ffffffff81059342>] ? flush_workqueue+0x0/0xb9
 [<ffffffff8106d08d>] ? lock_release_holdtime+0x34/0xe3
 [<ffffffff810593a5>] flush_workqueue+0x63/0xb9
 [<ffffffff81059342>] ? flush_workqueue+0x0/0xb9
 [<ffffffff81459d83>] ? _raw_spin_unlock+0x2b/0x2f
 [<ffffffff81059410>] flush_scheduled_work+0x15/0x17
 [<ffffffff8136c00a>] md_open+0x3e/0x88
 [<ffffffff81132f85>] __blkdev_get+0xe5/0x3a8
 [<ffffffff8113325a>] ? blkdev_open+0x0/0xac
 [<ffffffff8113325a>] ? blkdev_open+0x0/0xac
 [<ffffffff81133258>] blkdev_get+0x10/0x12
 [<ffffffff811332d0>] blkdev_open+0x76/0xac
 [<ffffffff8110a5a5>] __dentry_open+0x1bf/0x32f
 [<ffffffff811d3387>] ? security_inode_permission+0x21/0x23
 [<ffffffff8110a7f9>] nameidata_to_filp+0x3f/0x50
 [<ffffffff81116110>] do_last+0x444/0x5b5
 [<ffffffff81117c3f>] do_filp_open+0x1e7/0x5da
 [<ffffffff81459d83>] ? _raw_spin_unlock+0x2b/0x2f
 [<ffffffff8112112c>] ? alloc_fd+0x116/0x128
 [<ffffffff8110a2b7>] do_sys_open+0x63/0x10f
 [<ffffffff8110a396>] sys_open+0x20/0x22
 [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b
