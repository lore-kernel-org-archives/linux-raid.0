From: Anssi Kolehmainen <anssi@aketzu.net>
Subject: BUG: Bad page state in process md1_resync  pfn:50ab4
Date: Sun, 3 May 2009 10:44:29 +0300
Message-ID: <20090503074429.GA3436@aketzu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last night one server died apparently while doing resync of 1.5Tb md
raid1 array. Syslog [1] contained messages about BUG: Bad page state but
something else killed the system. Too bad the start of the stack trace
didn't fit in the monitor [2] so I don't know the exact cause for the
final freeze.

The machine is rather old desktop PC serving disks over NFS and Samba.
Apart from failing Seagate drives everything has worked fine for few
weeks and this is the first time this occured. Any thoughts of the BUG
or is there anything else you would like to know?

Please keep me cc'd because I'm not on the lists.

Linux version 2.6.29-1-amd64 (Debian 2.6.29-2) (waldi@debian.org) (gcc
version 4.3.3 (Debian 4.3.3-5) ) #1 SMP Sat Apr 4 16:54:07 UTC 2009

BUG: Bad page state in process md1_resync  pfn:03d5e
page:ffffe200000d6c90 flags:010000000001000c count:0 mapcount:0 mapping:ffff880021ea19c0 index:1f518
Pid: 6612, comm: md1_resync Not tainted 2.6.29-1-amd64 #1
Call Trace:
 [<ffffffff802936d1>] bad_page+0x102/0x113
 [<ffffffff80294840>] free_pages_check+0x9d/0xbe
 [<ffffffff8029499f>] free_hot_cold_page+0x3c/0x114
 [<ffffffffa0153cbd>] r1buf_pool_alloc+0x121/0x16f [raid1]
 [<ffffffff80291724>] mempool_alloc+0x3f/0xf5
 [<ffffffff8047a8f9>] _spin_lock_irq+0xd/0xf
 [<ffffffffa015354c>] raise_barrier+0x179/0x18f [raid1]
 [<ffffffff8023e601>] try_to_wake_up+0x1b0/0x1c2
 [<ffffffffa0081d68>] scsi_request_fn+0x41b/0x4e9 [scsi_mod]
 [<ffffffffa0153f14>] sync_request+0x195/0x519 [raid1]
 [<ffffffffa013de5e>] is_mddev_idle+0xa3/0xf5 [md_mod]
 [<ffffffffa013e480>] md_do_sync+0x5d0/0x9bb [md_mod]
 [<ffffffff80257052>] autoremove_wake_function+0x0/0x2e
 [<ffffffffa013ece8>] md_thread+0xe5/0x103 [md_mod]
 [<ffffffff8023750c>] __wake_up_common+0x44/0x73
 [<ffffffffa013ec03>] md_thread+0x0/0x103 [md_mod]
 [<ffffffffa013ec03>] md_thread+0x0/0x103 [md_mod]
 [<ffffffff80256cd1>] kthread+0x47/0x73
 [<ffffffff8021231a>] child_rip+0xa/0x20
 [<ffffffff80229035>] flat_send_IPI_mask+0x0/0x5
 [<ffffffff80256c8a>] kthread+0x0/0x73
 [<ffffffff80212310>] child_rip+0x0/0x20

1: http://kelvin.aketzu.net/~akolehma/syslog-resync-bug.txt
2: http://kelvin.aketzu.net/~akolehma/panic.jpg

-- 
Anssi Kolehmainen
