From: Qian Cai <cai@lca.pw>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v4
Date: Mon, 3 Aug 2020 10:56:23 -0400
Message-ID: <20200803145622.GB4631@lca.pw>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 28, 2020 at 06:33:53PM +0200, Christoph Hellwig wrote:
> Hi Al and Linus,
> 
> currently a lot of the file system calls in the early in code (and the
> devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> This is one of the few last remaining places we need to deal with to kill
> off set_fs entirely, so this series adds new helpers that take kernel
> pointers.  These helpers are in init/ and marked __init and thus will
> be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> though unfortunately.

Reverting this series from next-20200803 fixed the crash below on shutdown.

[ 7303.287890][    T1] systemd-shutdown[1]: All loop devices detached.
[ 7303.287930][    T1] systemd-shutdown[1]: Detaching DM devices.
[ 7303.441674][    T1] printk: shutdown: 9 output lines suppressed due to ratelimiting
[ 7303.443999][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100
[ 7303.444027][    T1] CPU: 120 PID: 1 Comm: shutdown Not tainted 5.8.0-next-20200803 #2
[ 7303.444053][    T1] Call Trace:
[ 7303.444069][    T1] [c000000015d27b70] [c0000000006f3778] dump_stack+0xfc/0x174 (unreliable)
[ 7303.444103][    T1] [c000000015d27bc0] [c0000000000c9328] panic+0x214/0x4ac
[ 7303.444140][    T1] [c000000015d27c60] [c0000000000d4d28] do_exit+0xda8/0xee0
[ 7303.444178][    T1] [c000000015d27d60] [c0000000000d4f1c] do_group_exit+0x5c/0xd0
list_empty at include/linux/list.h:282
(inlined by) thread_group_empty at include/linux/sched/signal.h:671
(inlined by) do_group_exit at kernel/exit.c:888
[ 7303.444205][    T1] [c000000015d27da0] [c0000000000d4fac] sys_exit_group+0x1c/0x20
sys_exit_group at kernel/exit.c:914
[ 7303.444234][    T1] [c000000015d27dc0] [c00000000002c628] system_call_exception+0xf8/0x1d0
[ 7303.444262][    T1] [c000000015d27e20] [c00000000000d0a8] system_call_common+0xe8/0x218
[ 7304.936912][    T1] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100 ]---

> 
> The series sits on top of my previous
> 
>   "decruft the early init / initrd / initramfs code v2"
> 
> series.
> 
> 
> Git tree:
> 
>     git://git.infradead.org/users/hch/misc.git init_path
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/init_path
> 
> 
> Changes since v3:
>  - rename fs/for_init.c to fs/init.c
>  - document the purpose of the routines in fs/init.c with a comment
>  - don't mark devtmpfs __init as that will cause it to get overwritten
>    by initmem poisoning
>  - add an init_dup helper to make Al more happy than with the version
>    commit to the "decruft the early init / initrd / initramfs code v2"
>    series
> 
> Changes since v2:
>  - move to fs/for_init.c
>  - reuse the init routines in devtmpfs after refactoring devtmpfsd
>    (and thus the broken error handling in the previous version)
>  - actually use kern_path in a place where user_path_at sneaked back in
> 
> Changes since v1:
>  - avoid most core VFS changes
>  - renamed the functions and move them to init/ and devtmpfs
>  - drop a bunch of cleanups that can be submitted independently now
> 
> 
> Diffstat:
