From: Nicolas Jungers <nicolas@jungers.net>
Subject: bug in kernel 3.2 (up to date Debian wheezy)
Date: Thu, 27 Jun 2013 19:22:10 +0200
Message-ID: <51CC74C2.6010608@jungers.net>
Reply-To: Nicolas Jungers <nicolas@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Assembling a raid 10 array on Debian Wheezy I got the following messages:


#-----------
uname -a
Linux ha1 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1 x86_64 GNU/Linux
mdadm --version
mdadm - v3.2.5 - 18th May 2012
#-----------

The operation was:

mdadm -C /dev/md0 -l10 -pf2  -n4 -x1 --assume-clean -b internal 
/dev/sd[abcde]1

I got the messages in the console:
mdadm: /dev/sda1 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Thu Jun 27 19:02:41 2013
mdadm: /dev/sdb1 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Thu Jun 27 19:02:41 2013
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Thu Jun 27 19:02:41 2013
mdadm: /dev/sdd1 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Thu Jun 27 19:02:41 2013
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Thu Jun 27 19:02:41 2013
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
Segmentation fault

kern.log contains:

Jun 27 19:05:10 ha1 kernel: [89178.413826] md: bind<sda1>
Jun 27 19:05:10 ha1 kernel: [89178.414011] md: bind<sdb1>
Jun 27 19:05:10 ha1 kernel: [89178.414267] md: bind<sdc1>
Jun 27 19:05:10 ha1 kernel: [89178.414538] md: bind<sdd1>
Jun 27 19:05:10 ha1 kernel: [89178.414806] md: bind<sde1>
Jun 27 19:05:10 ha1 kernel: [89178.418512] bio: create slab <bio-1> at 1
Jun 27 19:05:10 ha1 kernel: [89178.418778] md/raid10:md0: active with 4 
out of 4 devices
Jun 27 19:05:10 ha1 kernel: [89178.419042] ------------[ cut here 
]------------
Jun 27 19:05:10 ha1 kernel: [89178.419060] kernel BUG at 
/build/linux-s5x2oE/linux-3.2.46/drivers/md/bitmap.c:1769!
Jun 27 19:05:10 ha1 kernel: [89178.419075] invalid opcode: 0000 [#1] SMP
Jun 27 19:05:10 ha1 kernel: [89178.419088] CPU 1
Jun 27 19:05:10 ha1 kernel: [89178.419094] Modules linked in: raid10 
loop edac_mce_amd edac_core sp5100_tco radeon ttm drm_kms_helper drm 
power_supply i2c_algo_bit powernow_k8 i2c_piix4 snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec psmouse joydev serio_raw pcspkr evdev mperf 
k10temp i2c_core snd_hwdep snd_pcm snd_page_alloc snd_timer snd 
soundcore shpchp button processor wmi thermal_sys ext4 crc16 jbd2 
mbcache md_mod usb_storage sg sd_mod crc_t10dif ata_generic usbhid hid 
ahci libahci pata_atiixp ohci_hcd e1000e r8169 mii ehci_hcd libata 
scsi_mod usbcore usb_common [last unloaded: scsi_wait_scan]
Jun 27 19:05:10 ha1 kernel: [89178.419272]
Jun 27 19:05:10 ha1 kernel: [89178.419281] Pid: 2832, comm: mdadm Not 
tainted 3.2.0-4-amd64 #1 Debian 3.2.46-1 To Be Filled By O.E.M. To Be 
Filled By O.E.M./790GX Pro
Jun 27 19:05:10 ha1 kernel: [89178.419308] RIP: 
0010:[<ffffffffa00df19d>]  [<ffffffffa00df19d>] 
bitmap_create+0x50b/0x5bc [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.419343] RSP: 0018:ffff880213c61c88 
EFLAGS: 00010257
Jun 27 19:05:10 ha1 kernel: [89178.419354] RAX: 0000000000000000 RBX: 
ffff880214143580 RCX: 0000000000000011
Jun 27 19:05:10 ha1 kernel: [89178.419367] RDX: 0000000000000000 RSI: 
ffff8802167f0114 RDI: ffff880215a4a008
Jun 27 19:05:10 ha1 kernel: [89178.419380] RBP: ffff8802167f0000 R08: 
ffff8802167f0000 R09: ffffffff8168f0e0
Jun 27 19:05:10 ha1 kernel: [89178.419396] R10: 0000000000000200 R11: 
ffffea00074bc030 R12: 0000000000000000
Jun 27 19:05:10 ha1 kernel: [89178.419411] R13: 0000000000000000 R14: 
00000000000004e2 R15: 0000000000000000
Jun 27 19:05:10 ha1 kernel: [89178.419428] FS:  00007fe730148700(0000) 
GS:ffff88021fc40000(0000) knlGS:0000000000000000
Jun 27 19:05:10 ha1 kernel: [89178.419448] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
Jun 27 19:05:10 ha1 kernel: [89178.419461] CR2: 00007f2dc9a0a670 CR3: 
0000000215a02000 CR4: 00000000000006e0
Jun 27 19:05:10 ha1 kernel: [89178.419477] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jun 27 19:05:10 ha1 kernel: [89178.419493] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jun 27 19:05:10 ha1 kernel: [89178.419509] Process mdadm (pid: 2832, 
threadinfo ffff880213c60000, task ffff880213e571e0)
Jun 27 19:05:10 ha1 kernel: [89178.419527] Stack:
Jun 27 19:05:10 ha1 kernel: [89178.419535]  ffff8802167f0000 
ffff880214143380 ffff8802167f0000 0000000000000000
Jun 27 19:05:10 ha1 kernel: [89178.419561]  ffff8802167f0018 
ffff8802167f0000 0000000000000000 ffff8802167f0018
Jun 27 19:05:10 ha1 kernel: [89178.419585]  ffff8802167f0018 
ffffffffa00e0a42 ffff8802159b7000 ffffffffa00dac32
Jun 27 19:05:10 ha1 kernel: [89178.419610] Call Trace:
Jun 27 19:05:10 ha1 kernel: [89178.419634]  [<ffffffffa00dac32>] ? 
md_run+0x596/0x771 [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.419659]  [<ffffffffa00df5f6>] ? 
add_new_disk+0xef/0x45f [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.419679]  [<ffffffff810d02f1>] ? 
unmap_vmas+0x5fa/0x6ca
Jun 27 19:05:10 ha1 kernel: [89178.419703]  [<ffffffffa00dae18>] ? 
do_md_run+0xb/0x7b [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.419728]  [<ffffffffa00dc54d>] ? 
md_ioctl+0xc11/0xe93 [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.419746]  [<ffffffff810cf1a4>] ? 
free_pgtables+0xa5/0xbd
Jun 27 19:05:10 ha1 kernel: [89178.419764]  [<ffffffff8119e4ef>] ? 
blkdev_ioctl+0x5e6/0x5fb
Jun 27 19:05:10 ha1 kernel: [89178.419782]  [<ffffffff811213a0>] ? 
block_ioctl+0x38/0x3c
Jun 27 19:05:10 ha1 kernel: [89178.419799]  [<ffffffff81121368>] ? 
bdgrab+0x12/0x12
Jun 27 19:05:10 ha1 kernel: [89178.419816]  [<ffffffff81107721>] ? 
do_vfs_ioctl+0x459/0x49a
Jun 27 19:05:10 ha1 kernel: [89178.419833]  [<ffffffff810d4146>] ? 
remove_vma+0x64/0x6b
Jun 27 19:05:10 ha1 kernel: [89178.419850]  [<ffffffff810d5304>] ? 
do_munmap+0x2da/0x2f3
Jun 27 19:05:10 ha1 kernel: [89178.419867]  [<ffffffff811077ad>] ? 
sys_ioctl+0x4b/0x72
Jun 27 19:05:10 ha1 kernel: [89178.419884]  [<ffffffff8100ee82>] ? 
math_state_restore+0x4b/0x55
Jun 27 19:05:10 ha1 kernel: [89178.419901]  [<ffffffff81353b52>] ? 
system_call_fastpath+0x16/0x1b
Jun 27 19:05:10 ha1 kernel: [89178.419915] Code: 48 0f bc c9 48 89 4b 20 
48 8b 80 48 03 00 00 83 e9 09 48 c1 e8 09 48 8d 44 02 ff 48 d3 e8 4c 8d 
a0 ff 07 00 00 49 c1 ec 0b 75 02 <0f> 0b 4c 89 e7 48 89 43 28 4c 89 63 
08 48 c1 e7 04 4c 89 63 10
Jun 27 19:05:10 ha1 kernel: [89178.420064] RIP  [<ffffffffa00df19d>] 
bitmap_create+0x50b/0x5bc [md_mod]
Jun 27 19:05:10 ha1 kernel: [89178.420094]  RSP <ffff880213c61c88>
Jun 27 19:05:10 ha1 kernel: [89178.420375] ---[ end trace 
d9689cf7d2b41c37 ]---

Is it a known bug? I plan to migrate to kernel 3.9 anyway.

Regards,
N.
