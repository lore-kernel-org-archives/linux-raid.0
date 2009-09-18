From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: BUG: soft lockup in [md4_raid5:21137]
Date: Fri, 18 Sep 2009 13:05:11 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello

I am using kernel.org kernel 2.6.31 and see the following errors in
/var/log/messages:

    Sep 18 03:49:06 hermes kernel: BUG: soft lockup - CPU#0 stuck for 61s! [md4_raid5:21137]
    Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unloaded: microcode]
    Sep 18 03:49:06 hermes kernel: CPU 0:
    Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unloaded: microcode]
    Sep 18 03:49:06 hermes kernel: Pid: 21137, comm: md4_raid5 Not tainted 2.6.31 #1 PRIMERGY RX300 S4
    Sep 18 03:49:06 hermes kernel: RIP: 0010:[<ffffffff8135a668>]  [<ffffffff8135a668>] raid6_sse24_gen_syndrome+0xf9/0x251
    Sep 18 03:49:06 hermes kernel: RSP: 0018:ffff88080d46bb50  EFLAGS: 00000246
    Sep 18 03:49:06 hermes kernel: RAX: 0000000000000e80 RBX: ffff88080d46bb90 RCX: ffff8807e49e8000
    Sep 18 03:49:06 hermes kernel: RDX: 0000000000000000 RSI: 0000000000000e80 RDI: ffff8807e49e9ea0
    Sep 18 03:49:06 hermes kernel: RBP: ffffffff8102c66e R08: ffff8807e49e9e80 R09: 0000000000000ea0
    Sep 18 03:49:06 hermes kernel: R10: 0000160000000000 R11: 6db6db6db6db6db7 R12: ffff88080d46bb40
    Sep 18 03:49:06 hermes kernel: R13: ffffffff8102c4ce R14: 0000000000000c31 R15: 00000000812c6623
    Sep 18 03:49:06 hermes kernel: FS:  0000000000000000(0000) GS:ffff880028035000(0000) knlGS:0000000000000000
    Sep 18 03:49:06 hermes kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
    Sep 18 03:49:06 hermes kernel: CR2: 000000000042e3a7 CR3: 0000000001001000 CR4: 00000000000426f0
    Sep 18 03:49:06 hermes kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Sep 18 03:49:06 hermes kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Sep 18 03:49:06 hermes kernel: Call Trace:
    Sep 18 03:49:06 hermes kernel: [<ffffffff8135d575>] ? compute_parity6+0x2d9/0x376
    Sep 18 03:49:06 hermes kernel: [<ffffffff8135d783>] ? compute_block_1+0x171/0x1c6
    Sep 18 03:49:06 hermes kernel: [<ffffffff8135f738>] ? handle_stripe+0xa85/0x1c24
    Sep 18 03:49:06 hermes kernel: [<ffffffff81360cbd>] ? raid5d+0x3e6/0x439
    Sep 18 03:49:06 hermes kernel: [<ffffffff8136aee5>] ? md_thread+0xfb/0x12d
    Sep 18 03:49:06 hermes kernel: [<ffffffff8107fbdb>] ? autoremove_wake_function+0x0/0x5a
    Sep 18 03:49:06 hermes kernel: [<ffffffff8136adea>] ? md_thread+0x0/0x12d
    Sep 18 03:49:06 hermes kernel: [<ffffffff8107f7b7>] ? kthread+0x9b/0xa3
    Sep 18 03:49:06 hermes kernel: [<ffffffff8102cbaa>] ? child_rip+0xa/0x20
    Sep 18 03:49:06 hermes kernel: [<ffffffff8107f71c>] ? kthread+0x0/0xa3
    Sep 18 03:49:06 hermes kernel: [<ffffffff8102cba0>] ? child_rip+0x0/0x20

This happens on fedora 11 on a data-check of RAID array md4. I get several
of these, but the system keeps on running. Another system with the same
setup and hardware seems to always lock up. md4 is a raid6 consisting of
8 disks. There is absolutly no load on this array and it has an empty
ext4 filesystem mounted.

Any idea what is causing it? What else can I provide or do to solve this?

Thanks,
Holger
