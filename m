From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Mon, 28 Mar 2011 13:02:19 +0200
Message-ID: <201103281302.20219.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <20110328075937.GB16530@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110328075937.GB16530@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Tejun,

On Monday, 28. March 2011 09:59:37 Tejun Heo wrote:
> I don't think it's a reported problem.  How does it fail?  Things just
> stop?  As you wrote in the other mail, lockdep would definitely help.
> Another thing which can be helpful is sysrq-t and see where things are
> stuck.

It just stops. I enabled kernel debugging and the USB serial console.
Here are the gory details:

--------------------------------------------
BUG: soft lockup - CPU#0 stuck for 61s! [blkid:1113]
Modules linked in: ahci libahci libata ehci_hcd ohci_hcd dm_mod [last unloaded:
scsi_wait_scan]
irq event stamp: 2136355122
hardirqs last  enabled at (2136355121): [<c12c3532>] _raw_spin_unlock_irq+0x22/0
x30
hardirqs last disabled at (2136355122): [<c12c3d4b>] apic_timer_interrupt+0x2f/0
x3c
softirqs last  enabled at (2136337366): [<c103d98c>] __do_softirq+0xfc/0x150
softirqs last disabled at (2136337351): [<c1005624>] do_softirq+0xa4/0x100
Modules linked in: ahci libahci libata ehci_hcd ohci_hcd dm_mod [last unloaded:
scsi_wait_scan]

Pid: 1113, comm: blkid Not tainted 2.6.36+ #24 MS-7349/MS-7349
EIP: 0060:[<c12c3536>] EFLAGS: 00000202 CPU: 0
EIP is at _raw_spin_unlock_irq+0x26/0x30
EAX: 7f563131 EBX: f6407000 ECX: 00000006 EDX: f60e98f4
ESI: 00000000 EDI: f61ce9c0 EBP: f5641d24 ESP: f5641d20
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process blkid (pid: 1113, ti=f5640000 task=f60e9530 task.ti=f5640000)
Stack:
 f640b800 f5641d50 c104b646 001ce9f4 00000005 f61cea20 00000001 00000002
<0> f6407000 f61ce9c0 00000002 f5641d80 f5641df4 c104c990 00000000 00000002
<0> 00000000 c104c7e0 f60e9548 f60e98f4 00000010 f61ce9d0 f61cea30 00000001
Call Trace:
 [<c104b646>] ? flush_workqueue_prep_cwqs+0x106/0x200
 [<c104c990>] ? flush_workqueue+0x1b0/0x430
 [<c104c7e0>] ? flush_workqueue+0x0/0x430
 [<c1213fb6>] ? md_open+0x96/0xa0
 [<c10e4aa4>] ? __blkdev_get+0x74/0x310
 [<c10e4d4a>] ? blkdev_get+0xa/0x10
 [<c10e4e0e>] ? blkdev_open+0xbe/0x110
 [<c10b9c50>] ? __dentry_open+0xa0/0x260
 [<c10b9f01>] ? nameidata_to_filp+0x51/0x60
 [<c10e4d50>] ? blkdev_open+0x0/0x110
 [<c10c59a7>] ? do_last+0x327/0x600
 [<c10c7772>] ? do_filp_open+0x1a2/0x4c0
 [<c10a5eb7>] ? handle_mm_fault+0x137/0x8a0
 [<c12c35bd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d12c8>] ? alloc_fd+0xb8/0xf0
 [<c10b9a51>] ? do_sys_open+0x51/0x100
 [<c10b9b69>] ? sys_open+0x29/0x40
 [<c1002e9f>] ? sysenter_do_call+0x12/0x38
Code: 26 00 00 00 00 55 ba 01 00 00 00 89 e5 8b 4d 04 53 89 c3 8d 40 10 e8 7a 40
 da ff 89 d8 e8 b3 b7 e8 ff e8 be 11 da ff fb 66 66 90 <66> 90 5b 5d c3 90 8d 74
 26 00 55 89 e5 83 ec 08 8b 4d 04 89 1c
Call Trace:
 [<c104b646>] flush_workqueue_prep_cwqs+0x106/0x200
 [<c104c990>] flush_workqueue+0x1b0/0x430
 [<c104c7e0>] ? flush_workqueue+0x0/0x430
 [<c1213fb6>] md_open+0x96/0xa0
 [<c10e4aa4>] __blkdev_get+0x74/0x310
 [<c10e4d4a>] blkdev_get+0xa/0x10
 [<c10e4e0e>] blkdev_open+0xbe/0x110
 [<c10b9c50>] __dentry_open+0xa0/0x260
 [<c10b9f01>] nameidata_to_filp+0x51/0x60
 [<c10e4d50>] ? blkdev_open+0x0/0x110
 [<c10c59a7>] do_last+0x327/0x600
 [<c10c7772>] do_filp_open+0x1a2/0x4c0
 [<c10a5eb7>] ? handle_mm_fault+0x137/0x8a0
 [<c12c35bd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d12c8>] ? alloc_fd+0xb8/0xf0
 [<c10b9a51>] do_sys_open+0x51/0x100
 [<c10b9b69>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38
--------------------------------------------


Or a similar looking one:
--------------------------------------------
BUG: soft lockup - CPU#0 stuck for 63s! [blkid:1113]
Modules linked in: ahci libahci libata ehci_hcd ohci_hcd dm_mod [last unloaded:
scsi_wait_scan]
irq event stamp: 3897487660
hardirqs last  enabled at (3897487659): [<c12c15c4>] __mutex_unlock_slowpath+0xb
4/0x150
hardirqs last disabled at (3897487660): [<c12c3d4b>] apic_timer_interrupt+0x2f/0
x3c
softirqs last  enabled at (3897470978): [<c103d98c>] __do_softirq+0xfc/0x150
softirqs last disabled at (3897470965): [<c1005624>] do_softirq+0xa4/0x100
Modules linked in: ahci libahci libata ehci_hcd ohci_hcd dm_mod [last unloaded:
scsi_wait_scan]

Pid: 1113, comm: blkid Not tainted 2.6.36+ #24 MS-7349/MS-7349
EIP: 0060:[<c1067298>] EFLAGS: 00000246 CPU: 0
EIP is at lock_acquire+0x88/0xa0
EAX: 00000246 EBX: f60e9530 ECX: 00000000 EDX: c1823eb0
ESI: 00000000 EDI: f5dc5d08 EBP: f5641dd0 ESP: f5641da8
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process blkid (pid: 1113, ti=f5640000 task=f60e9530 task.ti=f5640000)
Stack:
 00000000 00000002 00000000 00000000 c10e4a5a 00000000 00000246 f5dc5cd0
<0> 00000000 f5dc5cd0 f5641e0c c12c1eb1 00000000 00000002 00000000 c10e4a5a
<0> f61c0800 f60e9530 00000000 f5641e2c f5dc5cd0 f5641e0c f5dc5cc0 f5520400
Call Trace:
 [<c10e4a5a>] ? __blkdev_get+0x2a/0x310
 [<c12c1eb1>] ? mutex_lock_nested+0x51/0x2f0
 [<c10e4a5a>] ? __blkdev_get+0x2a/0x310
 [<c10e4a5a>] ? __blkdev_get+0x2a/0x310
 [<c10e4d4a>] ? blkdev_get+0xa/0x10
 [<c10e4e0e>] ? blkdev_open+0xbe/0x110
 [<c10b9c50>] ? __dentry_open+0xa0/0x260
 [<c10b9f01>] ? nameidata_to_filp+0x51/0x60
 [<c10e4d50>] ? blkdev_open+0x0/0x110
 [<c10c59a7>] ? do_last+0x327/0x600
 [<c10c7772>] ? do_filp_open+0x1a2/0x4c0
 [<c10a5eb7>] ? handle_mm_fault+0x137/0x8a0
 [<c12c35bd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d12c8>] ? alloc_fd+0xb8/0xf0
 [<c10b9a51>] ? do_sys_open+0x51/0x100
 [<c10b9b69>] ? sys_open+0x29/0x40
 [<c1002e9f>] ? sysenter_do_call+0x12/0x38
Code: 01 83 e0 01 89 44 24 08 8b 45 0c 89 44 24 04 8b 45 08 89 04 24 89 f8 e8 77
 e7 ff ff c7 83 a8 03 00 00 00 00 00 00 8b 45 f0 50 9d <66> 66 66 90 8b 5d f4 8b
 75 f8 8b 7d fc 89 ec 5d c3 8d b4 26 00
Call Trace:
 [<c10e4a5a>] ? __blkdev_get+0x2a/0x310
 [<c12c1eb1>] mutex_lock_nested+0x51/0x2f0
 [<c10e4a5a>] ? __blkdev_get+0x2a/0x310
 [<c10e4a5a>] __blkdev_get+0x2a/0x310
 [<c10e4d4a>] blkdev_get+0xa/0x10
 [<c10e4e0e>] blkdev_open+0xbe/0x110
 [<c10b9c50>] __dentry_open+0xa0/0x260
 [<c10b9f01>] nameidata_to_filp+0x51/0x60
 [<c10e4d50>] ? blkdev_open+0x0/0x110
 [<c10c59a7>] do_last+0x327/0x600
 [<c10c7772>] do_filp_open+0x1a2/0x4c0
 [<c10a5eb7>] ? handle_mm_fault+0x137/0x8a0
 [<c12c35bd>] ? _raw_spin_unlock+0x1d/0x20
 [<c10d12c8>] ? alloc_fd+0xb8/0xf0
 [<c10b9a51>] do_sys_open+0x51/0x100
 [<c10b9b69>] sys_open+0x29/0x40
 [<c1002e9f>] sysenter_do_call+0x12/0x38
--------------------------------------------

I'll try to reproduce the backtrace with 2.6.38
and see if it's any different.

Cheers,
Thomas
