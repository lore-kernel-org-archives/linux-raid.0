From: Clem Pryke <pryke@focus.uchicago.edu>
Subject: raid6 kernel error
Date: Thu, 22 Jan 2009 11:16:00 -0600
Message-ID: <200901221716.n0MHG01N026618@focus.uchicago.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: pryke@focus.uchicago.edu, Kenneth Aird <kenneth.aird@usap.gov>
List-Id: linux-raid.ids

I built a raid6 md array of 12x1.5TB disks. During the initial sync I got a
kernel error I've not seen before. The sync then
apparently completed successfully. How serious is this?

kernel is 2.6.18-92.1.13.el5. System is 16 core AMD. Here is /proc/mdstat
info after sync complete:

md6 : active raid6 sdci1[11] sdch1[10] sdcg1[9] sdcf1[8] sdce1[7] sdcd1[6] sdcc1[5] sdcb1[4] sdca1[3] sdbz1[2] sdby1[1] sdbx1[0]
      14651384320 blocks level 6, 256k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]

Here is /var/log/messages excerpt:

Jan 21 19:04:22 spt kernel: md: bind<sdbx1>
Jan 21 19:04:22 spt kernel: md: bind<sdby1>
Jan 21 19:04:22 spt kernel: md: bind<sdbz1>
Jan 21 19:04:22 spt kernel: md: bind<sdca1>
Jan 21 19:04:22 spt kernel: md: bind<sdcb1>
Jan 21 19:04:22 spt kernel: md: bind<sdcc1>
Jan 21 19:04:22 spt kernel: md: bind<sdcd1>
Jan 21 19:04:22 spt kernel: md: bind<sdce1>
Jan 21 19:04:22 spt kernel: md: bind<sdcf1>
Jan 21 19:04:22 spt kernel: md: bind<sdcg1>
Jan 21 19:04:22 spt kernel: md: bind<sdch1>
Jan 21 19:04:22 spt kernel: md: bind<sdci1>
Jan 21 19:04:22 spt kernel: md: md6: raid array is not clean -- starting background reconstruction
Jan 21 19:04:22 spt kernel: raid5: device sdci1 operational as raid disk 11
Jan 21 19:04:22 spt kernel: raid5: device sdch1 operational as raid disk 10
Jan 21 19:04:22 spt kernel: raid5: device sdcg1 operational as raid disk 9
Jan 21 19:04:22 spt kernel: raid5: device sdcf1 operational as raid disk 8
Jan 21 19:04:22 spt kernel: raid5: device sdce1 operational as raid disk 7
Jan 21 19:04:22 spt kernel: raid5: device sdcd1 operational as raid disk 6
Jan 21 19:04:22 spt kernel: raid5: device sdcc1 operational as raid disk 5
Jan 21 19:04:22 spt kernel: raid5: device sdcb1 operational as raid disk 4
Jan 21 19:04:22 spt kernel: raid5: device sdca1 operational as raid disk 3
Jan 21 19:04:22 spt kernel: raid5: device sdbz1 operational as raid disk 2
Jan 21 19:04:22 spt kernel: raid5: device sdby1 operational as raid disk 1
Jan 21 19:04:22 spt kernel: raid5: device sdbx1 operational as raid disk 0
Jan 21 19:04:22 spt kernel: raid5: allocated 12662kB for md6
Jan 21 19:04:22 spt kernel: raid5: raid level 6 set md6 active with 12 out of 12 devices, algorithm 2
Jan 21 19:04:22 spt kernel: RAID5 conf printout:
Jan 21 19:04:22 spt kernel:  --- rd:12 wd:12 fd:0
Jan 21 19:04:22 spt kernel:  disk 0, o:1, dev:sdbx1
Jan 21 19:04:23 spt kernel:  disk 1, o:1, dev:sdby1
Jan 21 19:04:23 spt kernel:  disk 2, o:1, dev:sdbz1
Jan 21 19:04:23 spt kernel:  disk 3, o:1, dev:sdca1
Jan 21 19:04:23 spt kernel:  disk 4, o:1, dev:sdcb1
Jan 21 19:04:23 spt kernel:  disk 5, o:1, dev:sdcc1
Jan 21 19:04:23 spt kernel:  disk 6, o:1, dev:sdcd1
Jan 21 19:04:23 spt kernel:  disk 7, o:1, dev:sdce1
Jan 21 19:04:23 spt kernel:  disk 8, o:1, dev:sdcf1
Jan 21 19:04:23 spt kernel:  disk 9, o:1, dev:sdcg1
Jan 21 19:04:23 spt kernel:  disk 10, o:1, dev:sdch1
Jan 21 19:04:23 spt kernel:  disk 11, o:1, dev:sdci1
Jan 21 19:04:23 spt kernel: md: syncing RAID array md6
Jan 21 19:04:23 spt kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Jan 21 19:04:23 spt kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstructio
n.
Jan 21 19:04:23 spt kernel: md: using 128k window, over a total of 1465138432 blocks.
Jan 21 21:01:05 spt kernel: kjournald starting.  Commit interval 5 seconds
Jan 21 21:01:05 spt kernel: EXT3 FS on md6, internal journal
Jan 21 21:01:05 spt kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jan 21 21:40:45 spt kernel: test.x[29286]: segfault at 00002ac729a09990 rip 0000000000401750 rsp 00007fff837ee3d8 error 4
Jan 22 00:59:52 spt kernel: BUG: soft lockup - CPU#6 stuck for 10s! [md6_raid5:25352]
Jan 22 00:59:52 spt kernel: CPU 6:
Jan 22 00:59:52 spt kernel: Modules linked in: nfsd exportfs lockd nfs_acl auth_rpcgss autofs4 w83627hf hwmon_vid hwmon eepro
m i2c_isa hidp l2cap bluetooth sunrpc ip_conntrack_netbios_ns ipt_REJECT xt_state ip_conntrack nfnetlink iptable_filter ip_ta
bles ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 xfrm_nalgo crypto_api dm_mirror dm_multipath dm_mod raid4
56 xor video sbs backlight i2c_ec button battery asus_acpi acpi_memhotplug ac parport_pc lp parport floppy st sr_mod cdrom mp
tsas i2c_nforce2 shpchp e1000 scsi_transport_sas serio_raw i2c_core sg pcspkr mptscsih mptbase sata_nv libata aic7xxx scsi_tr
ansport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Jan 22 00:59:52 spt kernel: Pid: 25352, comm: md6_raid5 Not tainted 2.6.18-92.1.13.el5 #1
Jan 22 00:59:52 spt kernel: RIP: 0010:[<ffffffff883017a8>]  [<ffffffff883017a8>] :raid456:raid6_sse24_gen_syndrome+0x1f7/0x36
0
Jan 22 00:59:52 spt kernel: RSP: 0018:ffff81173cfe1a40  EFLAGS: 00000206
Jan 22 00:59:52 spt kernel: RAX: ffff811d370ca000 RBX: ffff81173cfe1c00 RCX: ffff811d370ca9e0
Jan 22 00:59:52 spt kernel: RDX: ffff811d370ca9c0 RSI: 0000000000000005 RDI: ffff81173cfe1c28
Jan 22 00:59:52 spt kernel: RBP: ffff8108541b3860 R08: ffff81173cfe1ab0 R09: 00000000000009c0
Jan 22 00:59:52 spt kernel: R10: ffff8118d4a289c0 R11: ffff811e324f39c0 R12: 0000000000000003
Jan 22 00:59:52 spt kernel: R13: ffffffff8008a583 R14: ffff81085412a980 R15: ffffffff8008a74c
Jan 22 00:59:52 spt kernel: FS:  00002acf78a77330(0000) GS:ffff8108542101c0(0000) knlGS:00000000f7ee16c0
Jan 22 00:59:52 spt kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
Jan 22 00:59:52 spt kernel: CR2: 00002aab049a0000 CR3: 00000004fac6a000 CR4: 00000000000006e0
Jan 22 00:59:52 spt kernel: 
Jan 22 00:59:52 spt kernel: Call Trace:
Jan 22 00:59:52 spt kernel:  [<ffffffff882fc9fb>] :raid456:compute_parity6+0x29c/0x325
Jan 22 00:59:52 spt kernel:  [<ffffffff882fcc40>] :raid456:compute_block_1+0x1bc/0x1fd
Jan 22 00:59:52 spt kernel:  [<ffffffff8009dd6f>] keventd_create_kthread+0x0/0xc4
Jan 22 00:59:52 spt kernel:  [<ffffffff882fdc4c>] :raid456:handle_stripe+0xd97/0x24d4
Jan 22 00:59:52 spt kernel:  [<ffffffff800893bb>] __wake_up_common+0x3e/0x68
Jan 22 00:59:52 spt kernel:  [<ffffffff8002e29f>] __wake_up+0x38/0x4f
Jan 22 00:59:52 spt kernel:  [<ffffffff8009dd6f>] keventd_create_kthread+0x0/0xc4
Jan 22 00:59:52 spt kernel:  [<ffffffff8009dd6f>] keventd_create_kthread+0x0/0xc4
Jan 22 00:59:52 spt kernel:  [<ffffffff882ff4d6>] :raid456:raid5d+0x14d/0x17b
Jan 22 00:59:52 spt kernel:  [<ffffffff8003a932>] prepare_to_wait+0x34/0x5c
Jan 22 00:59:52 spt kernel:  [<ffffffff80202fb2>] md_thread+0xf8/0x10e
Jan 22 00:59:52 spt kernel:  [<ffffffff8009df87>] autoremove_wake_function+0x0/0x2e
Jan 22 00:59:52 spt kernel:  [<ffffffff80202eba>] md_thread+0x0/0x10e
Jan 22 00:59:52 spt kernel:  [<ffffffff80032588>] kthread+0xfe/0x132
Jan 22 00:59:52 spt kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Jan 22 00:59:52 spt kernel:  [<ffffffff8009dd6f>] keventd_create_kthread+0x0/0xc4
Jan 22 00:59:52 spt kernel:  [<ffffffff8003248a>] kthread+0x0/0x132
Jan 22 00:59:52 spt kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Jan 22 00:59:52 spt kernel: 
Jan 22 05:47:02 spt kernel: md: md6: sync done.
Jan 22 05:47:02 spt kernel: RAID5 conf printout:
Jan 22 05:47:02 spt kernel:  --- rd:12 wd:12 fd:0
Jan 22 05:47:02 spt kernel:  disk 0, o:1, dev:sdbx1
Jan 22 05:47:02 spt kernel:  disk 1, o:1, dev:sdby1
Jan 22 05:47:02 spt kernel:  disk 2, o:1, dev:sdbz1
Jan 22 05:47:02 spt kernel:  disk 3, o:1, dev:sdca1
Jan 22 05:47:02 spt kernel:  disk 4, o:1, dev:sdcb1
Jan 22 05:47:02 spt kernel:  disk 5, o:1, dev:sdcc1
Jan 22 05:47:02 spt kernel:  disk 6, o:1, dev:sdcd1
Jan 22 05:47:02 spt kernel:  disk 7, o:1, dev:sdce1
Jan 22 05:47:02 spt kernel:  disk 8, o:1, dev:sdcf1
Jan 22 05:47:02 spt kernel:  disk 9, o:1, dev:sdcg1
Jan 22 05:47:02 spt kernel:  disk 10, o:1, dev:sdch1
Jan 22 05:47:02 spt kernel:  disk 11, o:1, dev:sdci1

-- 
**********************************************************************
Clem Pryke - Assistant Professor - Astronomy and Astrophysics
University of Chicago,
Room 120, LASR, 933 East 56th Street, Chicago, Illinois 60637, USA
Tel: 773 702-7853  Fax: 773 702-6645  email: pryke@focus.uchicago.edu
**********************************************************************

