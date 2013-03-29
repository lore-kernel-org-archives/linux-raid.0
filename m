From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Kernel panic after hot remove in raid1d
Date: Thu, 28 Mar 2013 19:33:56 -0600
Message-ID: <1364520836.2613.205.camel@148>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We have around 50 boxes running kernel 2.6.32-220.23.1.el6.x86_64 (mdadm
version 3.2.5-4) with RAID1 arrays built out of iscsi mounts - primarily
mounted as backup disks.  Last night as backups kicked off to use the
mirror 21 of them panicked with this stack (or very close to it):

Call Trace:
[<ffffffff814ecb34>] ? panic+0x78/0x143
[<ffffffff814f0cd4>] ? oops_end+0xe4/0x100
[<ffffffff810423fb>] ? no_context+0xe4/0x100
[<ffffffff810551f4>] ? find_busiest_group+0x244/0x9f0
[<ffffffff81042685>] ? __bad_area_nosemaphore+0x125/0x1e0
[<ffffffff81042753>] ? bad_area_no_semaphore+0x13/0x20
[<ffffffff81042e0d>] ? __do_page_fault+0x31d/0x480
[<ffffffff810098e2>] ? __switch_to+0x2c2/0x320
[<ffffffff814ed250>] ? thread_return+0x4e/0x76e
[<ffffffff814f2c8e>] ? do_page_fault+0x3e/0xa0
[<ffffffff814f0045>] ? page_fault+0x25/0x30
[<ffffffff813f5b7f>] ? bitmap_unplug+0x22f/0x250
[<ffffffff813eecad>] ? md_check_recovery+0x4d/0x6d0
[<ffffffffa006d66a>] ? flush_pending_writes+0x6a/0xc0 [raid1]
[<ffffffffa006e16d>] ? raid1d+0x8d/0x1050 [raid1]
[<ffffffff814ee0c5>] ? schedule_timeout+0x215/0x2e0
[<ffffffff813eba66>] ? md_thread+0x116/0x150
[<ffffffff81090d30>] ? autoremove_wake_function+0x0/0x40
[<ffffffff813eb950>] ? md_thread+0x0/0x150
[<ffffffff810909c6>] ? kthread+0x96/0xa0
[<ffffffff8100c14a>] ? child_rip+0xa/0x20
[<ffffffff81090930>] ? kthread+0x0/0xa0
[<ffffffff8100c140>] ? child_rip+0x0/0x20

Unfortunately I don't have console logs for what happened immediately
preceding it, but it seems safe to assume based on bitmap_unplug and the
synchronized nature of the panic we lost communication to one of the
iscsi targets.

Today playing around in my lab I was able to trigger it by doing:

mdadm --manage /dev/md/bigcarve --fail /dev/dm-0
mdadm --manage /dev/md/bigcarve --remove /dev/dm-0

and then doing an rm in the filesystem, but I can't duplicate it at
will.

I'd love to move to a 3.4 kernel but unfortunately I need a little more
to go on than a personal gut feeling to get the move approved.  I
realize it's a long shot, but does anyone have any insight into what may
have gone awry here and what could be done to address it?  Changes in
recovery / bitmaps / hot remove in later kernels?

Thanks in advance,

Tregaron

