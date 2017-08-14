From: Simon Kirby <sim@hostway.ca>
Subject: Re: raid1 lockups on 4.12.x
Date: Mon, 14 Aug 2017 00:08:44 -0700
Message-ID: <20170814070844.GA10721@hostway.ca>
References: <20170731183616.GD22429@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731183616.GD22429@hostway.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 31, 2017 at 11:36:16AM -0700, Simon Kirby wrote:

> Hello,
> 
> I recently upgraded two old boxes to 4.12.3 only to find that they
> started to lock up several times per day. I upgraded to 4.12.4 and the
> problem persisted. Downgrading to 4.11.11 seems to have stopped the
> issue.

I am still seeing this, even on 4.12.6, now also on a home server using
RAID 1, even with the "mddev->in_sync || !mddev->sync_checkers" condition
fixed to drop the '!':

[37795.380559] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [md0_raid1:214]
[37795.380581] Modules linked in: xt_conntrack xt_nat xt_recent xt_state xt_owner xt_REDIRECT nf_nat_redirect ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat_ftp iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack mxm_wmi nvidia_drm(O) nvidia_modeset(O) nvidia(O) drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea drm hid_logitech_hidpp firewire_ohci hid_logitech_dj usb_storage
[37795.380585] irq event stamp: 262
[37795.380585] hardirqs last  enabled at (261): [<ffffffff81a1108a>] _raw_spin_unlock_irqrestore+0x3a/0x60
[37795.380585] hardirqs last disabled at (262): [<ffffffff81a0b18e>] __schedule+0x9e/0x9f0
[37795.380585] softirqs last  enabled at (246): [<ffffffff810cddc6>] __do_softirq+0x366/0x470
[37795.380585] softirqs last disabled at (239): [<ffffffff810ce037>] irq_exit+0x87/0x90
[37795.380585] CPU: 3 PID: 214 Comm: md0_raid1 Tainted: G           O    4.12.6-flick+ #107
[37795.380585] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./990FXA-UD3, BIOS F4x 04/01/2016
[37795.380585] task: ffff8801374fbb40 task.stack: ffff88013770c000
[37795.380585] RIP: 0010:_raw_spin_unlock_irqrestore+0x3c/0x60
[37795.380585] RSP: 0018:ffff88013770fd68 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff10
[37795.380585] RAX: 0000000000000000 RBX: 0000000000000286 RCX: 0000000000000000
[37795.380585] RDX: ffffffff81108706 RSI: 0000000000000001 RDI: ffffffff81a1108a
[37795.380585] RBP: ffff88013770fd78 R08: 0000000000000000 R09: 0000000000000001
[37795.380585] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880137c7d3c8
[37795.380585] R13: 0000000000000000 R14: ffff8801374fbb40 R15: ffff8801374bba00
[37795.380585] FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
[37795.380585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37795.380585] CR2: 00007f79edc093a0 CR3: 000000012cfe9000 CR4: 00000000000006e0
[37795.380585] Call Trace:
[37795.380585]  __wake_up+0x46/0x60
[37795.380585]  md_check_recovery+0x147/0x4b0
[37795.380585]  raid1d+0x39/0x870
[37795.380585]  ? irq_exit+0xa/0x90
[37795.380585]  ? retint_kernel+0x10/0x10
[37795.380585]  md_thread+0x122/0x150
[37795.380585]  ? wake_bit_function+0x50/0x50
[37795.380585]  kthread+0x120/0x140
[37795.380585]  ? md_register_thread+0xe0/0xe0
[37795.380585]  ? kthread_create_on_node+0x40/0x40
[37795.380585]  ret_from_fork+0x27/0x40
[37795.380585] Code: 89 f3 4c 89 65 f8 be 01 00 00 00 49 89 fc 48 83 c7 18 e8 58 24 70 ff 4c 89 e7 e8 e0 4e 70 ff f6 c7 02 74 11 e8 c6 03 70 ff 53 9d <48> 8b 5d f0 4c 8b 65 f8 c9 c3 53 9d e8 03 dd 6f ff 48 8b 5d f0 

I'll try a build with a415c0f106279 and 4ad23a976413a reverted to see if
doing so stops these lockups. It appears perhaps something to do with the
spinlocks and IRQs...? At one point top was able to see the md0_raid1
thread spinning (typically I/O hangs and then the host needs rebooting).

Simon-
