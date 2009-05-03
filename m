From: Anssi Kolehmainen <anssi@aketzu.net>
Subject: Re: BUG: Bad page state in process md1_resync  pfn:50ab4
Date: Sun, 3 May 2009 10:59:31 +0300
Message-ID: <20090503075931.GB3436@aketzu.net>
References: <20090503074429.GA3436@aketzu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090503074429.GA3436@aketzu.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 03, 2009 at 10:44:29AM +0300, Anssi Kolehmainen wrote:
> Last night one server died apparently while doing resync of 1.5Tb md
> raid1 array. Syslog [1] contained messages about BUG: Bad page state but
> something else killed the system. Too bad the start of the stack trace
> didn't fit in the monitor [2] so I don't know the exact cause for the
> final freeze.

And few seconds later looking at logs of second machine I spot nearly
the same [1]. This time however the machine survived (sort of). System
setup is somewhat same as in previous post (md raid1, debian, same
kernel) and the bug occured just when it tried to resync the array.

(Actually the machines sit just next to eachother so this might be some
hobgoblin doing dirty work.)

Linux version 2.6.29-1-amd64 (Debian 2.6.29-2) (waldi@debian.org) (gcc
version 4.3.3 (Debian 4.3.3-5) ) #1 SMP Sat Apr 4 19:27:24 UTC 2009

BUG: unable to handle kernel paging request at 0000000003ad6a1a
IP: [<ffffffff8029810a>] put_page+0xb/0xbb
PGD 5a549067 PUD 6d13c067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/virtual/block/md0/md/sync_action
CPU 1 
Modules linked in: inet_diag isofs zlib_inflate udf crc_itu_t nf_nat_ftp
nf_conntrack_ftp nls_utf8 cifs nls_base nfs lockd nfs_acl auth_rpcgss sunrpc
sch_sfq act_police cls_u32 sch_ingress sch_htb ip6table_filter ip6_tables
xt_time xt_connlimit xt_realm xt_hashlimit iptable_raw xt_comment xt_owner
xt_recent xt_iprange xt_policy xt_multiport ipt_ULOG ipt_TTL ipt_ttl ipt_REJECT
ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP
ipt_ah ipt_addrtype xt_tcpmss xt_pkttype xt_physdev xt_NFQUEUE xt_MARK xt_mark
xt_mac xt_limit xt_length xt_helper xt_dccp xt_conntrack xt_CONNMARK
xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_mangle nfnetlink iptable_filter ip_tables
x_tables ppdev lp bridge 8021q garp stp ipv6 it87 hwmon_vid eeprom fuse loop
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm i2c_i801 snd_timer pcspkr
serio_raw iTCO_wdt i2c_core snd soundcore snd_page_alloc rng_core ev intel_agp
parport_pc parport container button ext3 jbd mbcache dm_mirror dm_region_hash
dm_log dm_snapshot dm_mod raid1 md_mod sd_mod crc_t10dif ide_cd_mod cdrom
ata_generic usbhid hid ide_pci_generic usb_storage ata_piix floppy libata
scsi_mod piix ide_core uhci_hcd ehci_hcd tg3 libphy thermal processor fan
thermal_sys
Pid: 24234, comm: md0_resync Not tainted 2.6.29-1-amd64 #1 829673G
RIP: 0010:[<ffffffff8029810a>]  [<ffffffff8029810a>] put_page+0xb/0xbb
RSP: 0000:ffff880011cbbbe0  EFLAGS: 00010202
RAX: ffff880002e1e780 RBX: 0000000000000000 RCX: ffff880011cbbb30
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000003ad6a1a
RBP: 0000000003ad6a1a R08: 0000000000000004 R09: 0000000000000000
R10: 00000000000007ca R11: 0000000000000001 R12: ffff880040320cc0
R13: ffff8800379799c0 R14: 0000000000011200 R15: ffff880050cf4480
FS:  0000000000000000(0000) GS:ffff88007eadf740(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000003ad6a1a CR3: 000000006e298000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md0_resync (pid: 24234, threadinfo ffff880011cba000, task ffff88005a5ed870)
Stack:
 0000000000000000 0000000000000000 ffff880040320cc0 ffff8800379799c0
 0000000000011200 ffffffffa0191cbd ffff88006d157248 ffff88001f3f22c0
 ffff880011cbbe7c 0000000000011210 ffff880011cbbc60 ffff880011cbbc78
Call Trace:
 [<ffffffffa0191cbd>] ? r1buf_pool_alloc+0x121/0x16f [raid1]
 [<ffffffff80291724>] ? mempool_alloc+0x3f/0xf5
 [<ffffffff8047a8f9>] ? _spin_lock_irq+0xd/0xf
 [<ffffffffa019154c>] ? raise_barrier+0x179/0x18f [raid1]
 [<ffffffff8023e601>] ? try_to_wake_up+0x1b0/0x1c2
 [<ffffffffa008ad68>] ? scsi_request_fn+0x41b/0x4e9 [scsi_mod]
 [<ffffffffa0191f14>] ? sync_request+0x195/0x519 [raid1]
 [<ffffffffa017be5e>] ? is_mddev_idle+0xa3/0xf5 [md_mod]
 [<ffffffffa017c480>] ? md_do_sync+0x5d0/0x9bb [md_mod]
 [<ffffffffa017cce8>] ? md_thread+0xe5/0x103 [md_mod]
 [<ffffffff8023750c>] ? __wake_up_common+0x44/0x73
 [<ffffffffa017cc03>] ? md_thread+0x0/0x103 [md_mod]
 [<ffffffffa017cc03>] ? md_thread+0x0/0x103 [md_mod]
 [<ffffffff80256cd1>] ? kthread+0x47/0x73
 [<ffffffff8021231a>] ? child_rip+0xa/0x20
 [<ffffffff80256c8a>] ? kthread+0x0/0x73
 [<ffffffff80212310>] ? child_rip+0x0/0x20
Code: fe ff ff f0 80 23 fb eb 09 80 e1 04 75 04 f0 80 0b 04 5b c3 48 c7 c7 c4 7e 29 80 e9 5d c2 fb ff 41 56 41 55 41 54 55 48 89 fd 53 <48> 8b 07 f6 c4 60 74 2d f6 c4 40 74 04 48 8b 6f 10 48 8d 45 08 
RIP  [<ffffffff8029810a>] put_page+0xb/0xbb
 RSP <ffff880011cbbbe0>
CR2: 0000000003ad6a1a
---[ end trace 952b986a58ba0952 ]---

1: http://kelvin.aketzu.net/~akolehma/syslog-resync-bug2.txt

-- 
Anssi Kolehmainen
