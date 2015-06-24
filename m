From: John Bridges <john.bridges@gmail.com>
Subject: Crash flood fills syslog
Date: Wed, 24 Jun 2015 10:52:50 -0400
Message-ID: <CAJ8DDcPwUqwebvA6yZSJ7igg2pB0VWUOjbcx0xfpb1e8PG_hFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Messages like this flooded my syslog ballooning it up to 90GB, and
causing other failures when the system drive had no free space left
(bad).

Distributor ID:    Ubuntu
Description:    Ubuntu 14.04.2 LTS
Release:    14.04
Codename:    trusty


Jun 23 08:25:08 monster kernel: [762785.217575] ------------[ cut here
]------------
Jun 23 08:25:08 monster kernel: [762785.217580] WARNING: CPU: 0 PID:
28173 at /build/buildd/linux-3.13.0/drivers/md/raid5.c:3856
handle_stripe+0x24e4/0x2500 [raid456]()
Jun 23 08:25:08 monster kernel: [762785.217581] Modules linked in:
pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF)
gpio_ich coretemp kvm_intel kvm serio_raw bnep rfcomm bluetooth
nvidia(POF) i3000_edac parport_pc drm lpc_ich ppdev lp shpchp mac_hid
edac_core parport xfs btrfs libcrc32c raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor usb_storage pata_acpi
ahci psmouse libahci e1000e raid6_pq ptp pps_core raid1 raid0
multipath sata_mv floppy linear
Jun 23 08:25:08 monster kernel: [762785.217612] CPU: 0 PID: 28173
Comm: md2_resync Tainted: PF       W  O 3.13.0-29-generic #53-Ubuntu
Jun 23 08:25:08 monster kernel: [762785.217613] Hardware name:
Supermicro PDSM4+/PDSM4+, BIOS 6.00 11/04/2008
Jun 23 08:25:08 monster kernel: [762785.217615]  0000000000000009
ffff88017e997af0 ffffffff8171a214 0000000000000000
Jun 23 08:25:08 monster kernel: [762785.217618]  ffff88017e997b28
ffffffff810676bd ffff88010d90a6b0 0000000000000009
Jun 23 08:25:08 monster kernel: [762785.217621]  0000000000000009
ffff8800369e8c00 000000000000000e ffff88017e997b38
Jun 23 08:25:08 monster kernel: [762785.217624] Call Trace:
Jun 23 08:25:08 monster kernel: [762785.217627]  [<ffffffff8171a214>]
dump_stack+0x45/0x56
Jun 23 08:25:08 monster kernel: [762785.217630]  [<ffffffff810676bd>]
warn_slowpath_common+0x7d/0xa0
Jun 23 08:25:08 monster kernel: [762785.217633]  [<ffffffff8106779a>]
warn_slowpath_null+0x1a/0x20
Jun 23 08:25:08 monster kernel: [762785.217637]  [<ffffffffa0108cd4>]
handle_stripe+0x24e4/0x2500 [raid456]
Jun 23 08:25:08 monster kernel: [762785.217640]  [<ffffffff8109a7b2>]
? default_wake_function+0x12/0x20
Jun 23 08:25:08 monster kernel: [762785.217644]  [<ffffffff810aaeb2>]
? autoremove_wake_function+0x12/0x40
Jun 23 08:25:08 monster kernel: [762785.217646]  [<ffffffff810aa7b8>]
? __wake_up_common+0x58/0x90
Jun 23 08:25:08 monster kernel: [762785.217651]  [<ffffffffa0104c1e>]
? get_active_stripe+0x58e/0x7c0 [raid456]
Jun 23 08:25:08 monster kernel: [762785.217656]  [<ffffffffa0109b9c>]
sync_request+0x17c/0x3e0 [raid456]
Jun 23 08:25:08 monster kernel: [762785.217658]  [<ffffffff815a40b1>]
? is_mddev_idle+0xd1/0x140
Jun 23 08:25:08 monster kernel: [762785.217661]  [<ffffffff815a7393>]
md_do_sync+0x993/0xdc0
Jun 23 08:25:08 monster kernel: [762785.217664]  [<ffffffff810aaea0>]
? prepare_to_wait_event+0x100/0x100
Jun 23 08:25:08 monster kernel: [762785.217667]  [<ffffffff815a3f48>]
md_thread+0x118/0x130
Jun 23 08:25:08 monster kernel: [762785.217670]  [<ffffffff815a3e30>]
? mddev_unlock+0xe0/0xe0
Jun 23 08:25:08 monster kernel: [762785.217673]  [<ffffffff8108b322>]
kthread+0xd2/0xf0
Jun 23 08:25:08 monster kernel: [762785.217676]  [<ffffffff8108b250>]
? kthread_create_on_node+0x1d0/0x1d0
Jun 23 08:25:08 monster kernel: [762785.217678]  [<ffffffff8172ab3c>]
ret_from_fork+0x7c/0xb0
Jun 23 08:25:08 monster kernel: [762785.217681]  [<ffffffff8108b250>]
? kthread_create_on_node+0x1d0/0x1d0
Jun 23 08:25:08 monster kernel: [762785.217683] ---[ end trace
518bf06a77e3600a ]---
Jun 23 08:25:08 monster kernel: [762785.217694] ------------[ cut here
]------------
