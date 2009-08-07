From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
	of device.
Date: Fri, 7 Aug 2009 09:57:06 -0400
Message-ID: <170fa0d20908070657x1206f4ebp5f434ed63386b073@mail.gmail.com>
References: <20090802215444.4198.83094.stgit@notabene.brown>
	 <20090802215818.4198.77041.stgit@notabene.brown>
	 <4A7A0287.5010505@zytor.com>
	 <170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>
	 <4A7A2EA6.9020603@zytor.com> <19066.19060.95471.616532@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19066.19060.95471.616532@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 5, 2009 at 11:13 PM, Neil Brown<neilb@suse.de> wrote:
> On Wednesday August 5, hpa@zytor.com wrote:
>> On 08/05/2009 06:03 PM, Mike Snitzer wrote:
>> > On Wed, Aug 5, 2009 at 6:07 PM, H. Peter Anvin<hpa@zytor.com> wrot=
e:
>> >> On 08/02/2009 02:58 PM, NeilBrown wrote:
>> >>> As revalidate_disk calls check_disk_size_change, it will cause
>> >>> any capacity change of a gendisk to be propagated to the blockde=
v
>> >>> inode. =A0So use that instead of mucking about with locks and
>> >>> i_size_write.
>> >>>
>> >>> Also add a call to revalidate_disk in do_md_run and a few other =
places
>> >>> where the gendisk capacity is changed.
>> >>>
>> >> This patch causes my Fedora 11 system with all filesystems on RAI=
D-1 to
>> >> not boot (it hangs in early userspace, Ctrl-Alt-Del reboots the s=
ystem.)
>> >
>> > I reported similar findings, with some more detail, relative to
>> > Fedora's rawhide here:
>> > http://lkml.org/lkml/2009/8/5/275
>>
>> Sounds to be the same, yes.
>
> Thanks for the reports guys.
>
> I managed to reproduce the lockup and I think this patch should fix
> it.
> If you could review/test I would appreciate it.
>
> Thanks,
> NeilBrown
>
>
> From cf90cb85596d05d9595bb8ee4cadb7d4091212b5 Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 6 Aug 2009 13:10:43 +1000
> Subject: [PATCH] Remove deadlock potential in md_open
>
> A recent commit:
> =A0commit 449aad3e25358812c43afc60918c5ad3819488e7
>
> introduced the possibility of an A-B/B-A deadlock between
> bd_mutex and reconfig_mutex.
>
> __blkdev_get holds bd_mutex while calling md_open which takes
> =A0 reconfig_mutex,
> do_md_run is always called with reconfig_mutex held, and it now
> =A0 takes bd_mutex in the call the revalidate_disk.
>
> This potential deadlock was not caught by lockdep due to the
> use of mutex_lock_interruptible_nexted which was introduced
> by
> =A0 commit d63a5a74dee87883fda6b7d170244acaac5b05e8
> do avoid a warning of an impossible deadlock.
>
> It is quite possible to split reconfig_mutex in to two locks.
> One protects the array data structures while it is being
> reconfigured, the other ensures that an array is never even partially
> open while it is being deactivated.
>
> So create a new lock, open_mutex, just to ensure exclusion between
> 'open' and 'stop'.
>
> This avoids the deadlock and also avoid the lockdep warning mentioned
> in commit d63a5a74d
>
> Reported-by: "Mike Snitzer" <snitzer@gmail.com>
> Reported-by: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: NeilBrown <neilb@suse.de>

Neil,

I finally tested this with the LVM testsuite's
t-pvcreate-operation-md.sh script that I mentioned here:
http://lkml.org/lkml/2009/8/5/275

The test succeeds but unfortunately triggers the following lockdep warn=
ing:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible circular locking dependency detected ]
2.6.31-0.125.rc5.git2.snitm.x86_64 #1
-------------------------------------------------------
mdadm/1348 is trying to acquire lock:
 (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811809dc>]
bd_release_from_disk+0x49/0x113

but task is already holding lock:
 (&new->open_mutex){+.+...}, at: [<ffffffff81418ac7>] do_md_stop+0x3f/0=
x529

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&new->open_mutex){+.+...}:
       [<ffffffff8109ed70>] __lock_acquire+0x990/0xb29
       [<ffffffff810a0298>] lock_acquire+0xd5/0x115
       [<ffffffff8152e318>] __mutex_lock_common+0x5d/0x3b0
       [<ffffffff8152e6b8>] mutex_lock_interruptible_nested+0x4d/0x68
       [<ffffffff8141e683>] md_open+0x71/0xb3
       [<ffffffff81181821>] __blkdev_get+0xe1/0x37e
       [<ffffffff81181900>] __blkdev_get+0x1c0/0x37e
       [<ffffffff81181ae1>] blkdev_get+0x23/0x39
       [<ffffffff81181b7c>] blkdev_open+0x85/0xd1
       [<ffffffff8114f909>] __dentry_open+0x1af/0x303
       [<ffffffff81150da8>] nameidata_to_filp+0x55/0x7d
       [<ffffffff8115ecb1>] do_filp_open+0x504/0x960
       [<ffffffff8114f595>] do_sys_open+0x70/0x12e
       [<ffffffff8114f6c0>] sys_open+0x33/0x49
       [<ffffffff810141c2>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&bdev->bd_mutex/1){+.+...}:
       [<ffffffff8109ed70>] __lock_acquire+0x990/0xb29
       [<ffffffff810a0298>] lock_acquire+0xd5/0x115
       [<ffffffff8152e318>] __mutex_lock_common+0x5d/0x3b0
       [<ffffffff8152e789>] mutex_lock_nested+0x4d/0x6a
       [<ffffffff811817ce>] __blkdev_get+0x8e/0x37e
       [<ffffffff81181900>] __blkdev_get+0x1c0/0x37e
       [<ffffffff81181ae1>] blkdev_get+0x23/0x39
       [<ffffffff81181b7c>] blkdev_open+0x85/0xd1
       [<ffffffff8114f909>] __dentry_open+0x1af/0x303
       [<ffffffff81150da8>] nameidata_to_filp+0x55/0x7d
       [<ffffffff8115ecb1>] do_filp_open+0x504/0x960
       [<ffffffff8114f595>] do_sys_open+0x70/0x12e
       [<ffffffff8114f6c0>] sys_open+0x33/0x49
       [<ffffffff810141c2>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&bdev->bd_mutex){+.+.+.}:
       [<ffffffff8109ec64>] __lock_acquire+0x884/0xb29
       [<ffffffff810a0298>] lock_acquire+0xd5/0x115
       [<ffffffff8152e318>] __mutex_lock_common+0x5d/0x3b0
       [<ffffffff8152e789>] mutex_lock_nested+0x4d/0x6a
       [<ffffffff811809dc>] bd_release_from_disk+0x49/0x113
       [<ffffffff81415cd5>] unbind_rdev_from_array+0x5f/0x148
       [<ffffffff81416f96>] kick_rdev_from_array+0x25/0x48
       [<ffffffff81417011>] export_array+0x58/0xc2
       [<ffffffff81418d57>] do_md_stop+0x2cf/0x529
       [<ffffffff8141d7ab>] md_ioctl+0xa5e/0xffe
       [<ffffffff8128141f>] __blkdev_driver_ioctl+0x4b/0xa2
       [<ffffffff81281d9b>] blkdev_ioctl+0x881/0x8ee
       [<ffffffff81181f54>] block_ioctl+0x50/0x68
       [<ffffffff81161466>] vfs_ioctl+0x3e/0xa2
       [<ffffffff81161a03>] do_vfs_ioctl+0x499/0x500
       [<ffffffff81161ad5>] sys_ioctl+0x6b/0xa2
       [<ffffffff810141c2>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by mdadm/1348:
 #0:  (&new->reconfig_mutex){+.+.+.}, at: [<ffffffff81415e82>]
mddev_lock+0x2a/0x40
 #1:  (&new->open_mutex){+.+...}, at: [<ffffffff81418ac7>] do_md_stop+0=
x3f/0x529

stack backtrace:
Pid: 1348, comm: mdadm Tainted: G        W
2.6.31-0.125.rc5.git2.snitm.x86_64 #1
Call Trace:
 [<ffffffff8109e3c1>] print_circular_bug_tail+0x80/0x9f
 [<ffffffff8109ec64>] __lock_acquire+0x884/0xb29
 [<ffffffff811809dc>] ? bd_release_from_disk+0x49/0x113
 [<ffffffff81014d10>] ? restore_args+0x0/0x30
 [<ffffffff811809dc>] ? bd_release_from_disk+0x49/0x113
 [<ffffffff810a0298>] lock_acquire+0xd5/0x115
 [<ffffffff811809dc>] ? bd_release_from_disk+0x49/0x113
 [<ffffffff8152e318>] __mutex_lock_common+0x5d/0x3b0
 [<ffffffff811809dc>] ? bd_release_from_disk+0x49/0x113
 [<ffffffff811809dc>] ? bd_release_from_disk+0x49/0x113
 [<ffffffff810537e7>] ? need_resched+0x36/0x54
 [<ffffffff8152fbdf>] ? _spin_unlock_irq+0x46/0x61
 [<ffffffff8152e789>] mutex_lock_nested+0x4d/0x6a
 [<ffffffff811809dc>] bd_release_from_disk+0x49/0x113
 [<ffffffff81415cd5>] unbind_rdev_from_array+0x5f/0x148
 [<ffffffff81416f96>] kick_rdev_from_array+0x25/0x48
 [<ffffffff81082dd6>] ? flush_workqueue+0x0/0xd1
 [<ffffffff81417011>] export_array+0x58/0xc2
 [<ffffffff81418d57>] do_md_stop+0x2cf/0x529
 [<ffffffff8152e6b8>] ? mutex_lock_interruptible_nested+0x4d/0x68
 [<ffffffff8141d7ab>] md_ioctl+0xa5e/0xffe
 [<ffffffff8109e710>] ? __lock_acquire+0x330/0xb29
 [<ffffffff8103bd8f>] ? pvclock_clocksource_read+0x56/0xa6
 [<ffffffff8128141f>] __blkdev_driver_ioctl+0x4b/0xa2
 [<ffffffff8109bc58>] ? lock_release_holdtime+0x61/0x7c
 [<ffffffff81281d9b>] blkdev_ioctl+0x881/0x8ee
 [<ffffffff81246cb1>] ? __rcu_read_unlock+0x34/0x4a
 [<ffffffff812472c9>] ? avc_has_perm_noaudit+0x358/0x37d
 [<ffffffff8109d37a>] ? mark_lock+0x31/0x221
 [<ffffffff81247bee>] ? avc_has_perm+0x60/0x86
 [<ffffffff8103bd8f>] ? pvclock_clocksource_read+0x56/0xa6
 [<ffffffff812492b3>] ? inode_has_perm+0x7d/0xa0
 [<ffffffff815305e6>] ? _spin_unlock_irqrestore+0x5e/0x83
 [<ffffffff81181f54>] block_ioctl+0x50/0x68
 [<ffffffff81161466>] vfs_ioctl+0x3e/0xa2
 [<ffffffff81161a03>] do_vfs_ioctl+0x499/0x500
 [<ffffffff81161ad5>] sys_ioctl+0x6b/0xa2
 [<ffffffff810141c2>] system_call_fastpath+0x16/0x1b
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
