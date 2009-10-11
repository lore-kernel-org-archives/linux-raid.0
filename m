From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: [BUG] Soft lockups in 2.6.32-rc3
Date: Sun, 11 Oct 2009 22:19:55 +0200
Message-ID: <20091011201955.GA19308@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've just upgraded from 2.6.31-rc8 to 2.6.32-rc3, and I thought I would turn
on the new multicore RAID-5 processing. I did, it booted up and started
syncing RAIDs (since the last shutdown before that was not clean), and
started syncing at the minimum speed (1000 K/sec). I've seen this before, so
I upped it in /proc to about 100MB/sec minimum (which is well below what I've
seen from that RAID; six 7200rpm SATA drives connected by SAS).

However, it never wanted to go above about 8-10MB/sec, and md4_raid5 used
100% CPU while I/O was extremely slow. Suddenly the serial console flashed:

[ 4086.665047] BUG: soft lockup - CPU#2 stuck for 61s! [md4_raid5:2771]
[ 4086.668016] Modules linked in: ipt_REJECT iptable_filter ip_tables af_packet tun ext2 ext4 jbd2 crc16 coretemp w83627ehf hwmon_vid ide_generic ide_gd_mod ide_cd_mod cdrom forcedeth psmouse i2c_i801 serio_raw pcspkr i2c_core evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq raid1 md_mod ide_pci_generic ide_core e1000e uhci_hcd ehci_hcd sd_mod unix [last unloaded: scsi_wait_scan]
[ 4086.712870] CPU 2:
[ 4086.712870] Modules linked in: ipt_REJECT iptable_filter ip_tables af_packet tun ext2 ext4 jbd2 crc16 coretemp w83627ehf hwmon_vid ide_generic ide_gd_mod ide_cd_mod cdrom forcedeth psmouse i2c_i801 serio_raw pcspkr i2c_core evdev ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq raid1 md_mod ide_pci_generic ide_core e1000e uhci_hcd ehci_hcd sd_mod unix [last unloaded: scsi_wait_scan]
[ 4086.748896] Pid: 2771, comm: md4_raid5 Not tainted 2.6.32-rc3 #1 C2SBC-Q
[ 4086.748896] RIP: 0010:[<ffffffff813007e8>]  [<ffffffff813007e8>] _spin_unlock_irqrestore+0x8/0xa
[ 4086.748896] RSP: 0018:ffff88023c73fcf0  EFLAGS: 00000286
[ 4086.748896] RAX: ffffffff814ef398 RBX: ffff88023c73fcf0 RCX: ffff88023f924000
[ 4086.789991] RDX: 0000000000000003 RSI: 0000000000000286 RDI: ffffffff814ef390
[ 4086.798950] RBP: ffffffff8100b8ae R08: ffffffff814ef380 R09: 000000b93cb10e6c
[ 4086.798950] R10: ffff88002838de40 R11: 0000000300000000 R12: 0000000200000000
[ 4086.810818] R13: ffffffff8103ad30 R14: ffff88023c73fca0 R15: 0000000000000046
[ 4086.816887] FS:  0000000000000000(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
[ 4086.816887] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 4086.816887] CR2: 00000000006f4000 CR3: 000000022d188000 CR4: 00000000000006e0
[ 4086.838490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4086.849005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4086.849005] Call Trace:
[ 4086.849005]  [<ffffffff81030948>] ? __wake_up+0x43/0x50
[ 4086.849005]  [<ffffffffa00e28a1>] ? __process_stripe+0x0/0x1d [raid456]
[ 4086.849005]  [<ffffffff8105b247>] ? __async_schedule+0x13e/0x14d
[ 4086.849005]  [<ffffffff8105b25f>] ? async_schedule_domain+0x9/0xb
[ 4086.849005]  [<ffffffffa00e2cc2>] ? raid5d+0x404/0x44c [raid456]
[ 4086.888545]  [<ffffffff812feca1>] ? schedule_timeout+0x28/0x1df
[ 4086.888545]  [<ffffffffa0085ae3>] ? md_thread+0xf4/0x112 [md_mod]
[ 4086.901291]  [<ffffffff81055dfa>] ? autoremove_wake_function+0x0/0x38
[ 4086.901291]  [<ffffffffa00859ef>] ? md_thread+0x0/0x112 [md_mod]
[ 4086.913075]  [<ffffffff81055a88>] ? kthread+0x7d/0x85
[ 4086.913075]  [<ffffffff8100bdda>] ? child_rip+0xa/0x20
[ 4086.913075]  [<ffffffff81055a0b>] ? kthread+0x0/0x85
[ 4086.913075]  [<ffffffff8100bdd0>] ? child_rip+0x0/0x20

Eventually all I/O on the machine just died, and I had to hard reboot (I tried
for two hours to log in, so had to be pretty hard). It kept spitting out these
about once per minute until the boot, though. Fascinatingly enough, irssi was
active the entire time, so it was probably just the I/O that was bogus, not
the rest of the system.

Any ideas?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
