From: Shaohua Li <shli@kernel.org>
Subject: Re: Triggering WARN_ON_ONCE in drivers/md/md.c::set_in_sync()
Date: Tue, 25 Jul 2017 15:13:25 -0700
Message-ID: <20170725221325.z6ozo6vmos3edwse@kernel.org>
References: <1e68d380-762c-fbb4-73f9-842bd0fa7093@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e68d380-762c-fbb4-73f9-842bd0fa7093@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Kinard <kumba@gentoo.org>, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 23, 2017 at 09:11:39PM -0400, Joshua Kinard wrote:
> Hi,
> 
> I'm testing out a netboot installer image on an old SGI MIPS machine,
> which has two disks (/dev/sda, /dev/sdb) in an md raid1 setup, all
> filesystems using XFS V5.  root filesystem is on /dev/md0 and /dev/md2
> is where /usr will mount, but /usr is in the middle of a resync.  The
> remaining md devices are synced and have bitmaps enabled.
> 
> If I attempt to mount the root filesystem, I trigger these messages on
> the console:
>     [  147.156932] XFS (md0): Mounting V5 Filesystem
>     [  148.545726] ------------[ cut here ]------------
>     [  148.550522] WARNING: CPU: 0 PID: 258 at drivers/md/md.c:2273 set_in_sync+0x38/0xfc
>     [  148.558265] CPU: 0 PID: 258 Comm: md0_raid1 Not tainted 4.12.3-mipsgit-20170703 #1
>     [  148.565915] Stack : 0000000000000046 0000000000000000 0000000000000000 ffffffff9401fce1
>     [  148.574021]         0000000000000000 0000000000000000 0000000000000005 ffffffff8005a03c
>     [  148.582100]         ffffffff80726e57 ffffffff806b3060 980000005318d800 0000000000000102
>     [  148.590198]         ffffffff80b91f90 00000000000008e1 ffffffff806b0000 ffffffff80b70000
>     [  148.598298]         0000000000000000 ffffffff80096b5c 980000005355fbc8 ffffffff8002d170
>     [  148.606395]         ffffffff8046c974 ffffffff8005b03c 0000000000000007 ffffffff806b3060
>     [  148.614495]         0000000000000000 0000000000000000 0000000000000000 0000000000000000
>     [  148.622576]         0000000000000000 980000005355fb10 0000000000000000 ffffffff8002d3e0
>     [  148.630673]         0000000000000000 0000000000000000 ffffffff8046c974 0000000000000000
>     [  148.638773]         0000000000000000 ffffffff8000e81c 0000000000000000 ffffffff8002d3e0
>     [  148.646869]         ...
>     [  148.649354] Call Trace:
>     [  148.651878] [<ffffffff8000e81c>] show_stack+0x70/0x8c
>     [  148.657012] [<ffffffff8002d3e0>] __warn+0x108/0x110
>     [  148.661935] [<ffffffff8046c974>] set_in_sync+0x38/0xfc
>     [  148.667157] [<ffffffff80476990>] md_check_recovery+0x2fc/0x5c0
>     [  148.673080] [<ffffffff8044bba8>] raid1d+0x48/0x1298
>     [  148.678032] [<ffffffff8046c934>] md_thread+0x178/0x180
>     [  148.683235] [<ffffffff80047650>] kthread+0x140/0x148
>     [  148.688271] [<ffffffff80009260>] ret_from_kernel_thread+0x14/0x1c
>     [  148.694438] ---[ end trace d27f806e939dc049 ]---
>     [  149.210292] XFS (md0): Ending clean mount
> 
> Checking *(set_in_sync+0x38) in gdb yields:
>     (gdb) l *(set_in_sync+0x38)
>     0xffffffff8046c974 is in set_in_sync (drivers/md/md.c:2274).
>     2269    }
>     2270
>     2271    static bool set_in_sync(struct mddev *mddev)
>     2272    {
>     2273            WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
>     2274            if (!mddev->in_sync) {
>     2275                    mddev->sync_checkers++;
>     2276                    spin_unlock(&mddev->lock);
>     2277                    percpu_ref_switch_to_atomic_sync(&mddev->writes_pending);
>     2278                    spin_lock(&mddev->lock);
> 
> Everything is still usable after this point, but attempting to untar a
> large file onto the /usr mount (/dev/md2) will crash/panic the kernel,
> but those panic messages are marked as "tainted".  I'm currently
> waiting for the resync to finish now before proceeding further.  I'll
> add that this machine only has one CPU, so my understanding was all
> spinlocks compile out in that case (if PREEMPT is not enabled, which it
> isn't).  Thus I am a bit stumped why this is being triggered, especially
> when mounting an unrelated md device that is already fully resynced.

This isn't a big problem. spin_is_locked always returns 0, if you don't enable
CONFIG_SMP. We probably should change the code as:
WARN_ON_ONCE(!spin_is_locked(&mddev->lock) && defined(CONFIG_SMP));

Interesting is if I disable CONFIG_SMP, there are several bugs exposed, I can't
even boot my machine. Looks nobody tests UP case these days.

Thanks,
Shaohua
