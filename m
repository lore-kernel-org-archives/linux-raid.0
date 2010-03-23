From: Randy Terbush <randy@terbush.org>
Subject: Re: Questions regarding startup of imsm container
Date: Tue, 23 Mar 2010 15:41:18 -0600
Message-ID: <7db987b31003231441j56733b15wd111c4aa22e9eccc@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	<e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the suggestions from Dan and others. I've managed to pin
the names of the raid devices. Getting closer to figuring out the
startup problem hopefully. kernel trace included below...

This is running on Gentoo with kernel 2.6.30.
Linux hifi 2.6.30-gentoo-r9 #1 SMP Mon Mar 22 08:25:58 MDT 2010 x86_64
Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux

Gentoo calls a bit of startup script that looks like this:

# Start software raid with mdadm (new school)
mdadm_conf=3D"/etc/mdadm/mdadm.conf"
[ -e /etc/mdadm.conf ] && mdadm_conf=3D"/etc/mdadm.conf"
if [ -x /sbin/mdadm -a -f "${mdadm_conf}" ] ; then
    devs=3D$(awk '/^[[:space:]]*ARRAY/ { print $2 }' "${mdadm_conf}")
    if [ -n "${devs}" ]; then
        ebegin "Starting up RAID devices"
        output=3D$(mdadm -As 2>&1)
        ret=3D$?
        [ ${ret} -ne 0 ] && echo "${output}"
        eend ${ret}
    fi
fi

that seems to exit without error

My mdadm.conf now looks like this:
ARRAY /dev/md/0 metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b=
7f0
ARRAY /dev/md/127 container=3D30223250:76fd248b:50280919:0836b7f0
member=3D0 bitmap=3D/boot/md/127-RAID5-bitmap
UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c

rc-logging shows me this:

rc default logging started at Tue Mar 23 15:28:05 2010

 * Checking local filesystems  ...
/dev/sda3: clean, 720743/9502720 files, 8557843/37997741 blocks
/dev/sda1: clean, 45/26104 files, 26216/104388 blocks
fsck.ext4: Device or resource busy while trying to open /dev/mapper/vg0=
-home
=46ilesystem mounted or opened exclusively by another program?
fsck.ext4: Device or resource busy while trying to open /dev/mapper/vg0=
-svn
=46ilesystem mounted or opened exclusively by another program?
fsck.ext4: Device or resource busy while trying to open /dev/mapper/vg0=
-archive
=46ilesystem mounted or opened exclusively by another program?
fsck.ext4: Device or resource busy while trying to open /dev/mapper/vg0=
-media
=46ilesystem mounted or opened exclusively by another program?
 * Operational error
 [ !! ]
 * Remounting root filesystem read/write ...
 [ ok ]
 * Updating /etc/mtab ...
 [ ok ]
 * Mounting local filesystems ...
mount: /dev/mapper/vg0-home already mounted or /home busy
mount: /dev/mapper/vg0-svn already mounted or /svn busy
mount: /dev/mapper/vg0-archive already mounted or /archive busy
mount: /dev/mapper/vg0-media already mounted or /mediaslice busy
 * Some local filesystem failed to mount

-----------------------------------------------------------------------=
----------------------------------------------------

And /proc/mdstat says:

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md127 : active (read-only) raid5 sdb[3] sdc[2] sdd[1] sde[0]
      2930280448 blocks super external:/md0/0 level 5, 64k chunk,
algorithm 0 [4/4] [UUUU]
        resync=3DPENDING

md0 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
      9028 blocks super external:imsm

unused devices: <none>

-----------------------------------------------------------------------=
-----------------------------------------------------------------

And a look at the kernel messages from dmesg says:

[   16.300609] md: md0 stopped.
[   16.319715] md: bind<sdd>
[   16.319787] md: bind<sdc>
[   16.319842] md: bind<sdb>
[   16.319895] md: bind<sde>
[   16.343621] md: md127 stopped.
[   16.343794] md: bind<sde>
[   16.343884] md: bind<sdd>
[   16.343965] md: bind<sdc>
[   16.344053] md: bind<sdb>
[   16.345115] raid5: device sdb operational as raid disk 0
[   16.345117] raid5: device sdc operational as raid disk 1
[   16.345119] raid5: device sdd operational as raid disk 2
[   16.345120] raid5: device sde operational as raid disk 3
[   16.345552] raid5: allocated 4270kB for md127
[   16.345591] raid5: raid level 5 set md127 active with 4 out of 4
devices, algorithm 0
[   16.345594] RAID5 conf printout:
[   16.345596]  --- rd:4 wd:4
[   16.345599]  disk 0, o:1, dev:sdb
[   16.345601]  disk 1, o:1, dev:sdc
[   16.345603]  disk 2, o:1, dev:sdd
[   16.345606]  disk 3, o:1, dev:sde
[   16.346507] md127: detected capacity change from 0 to 3000607178752
[   16.346510]  md127: unknown partition table
[   21.506666] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[   22.918983] ------------[ cut here ]------------
[   22.918986] kernel BUG at drivers/md/md.c:6139!
[   22.918988] invalid opcode: 0000 [#1] SMP
[   22.918990] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sd=
a/uevent
[   22.918992] CPU 0
[   22.918993] Modules linked in: dm_mod wanrouter sdladrv wctdm
dahdi_echocan_mg2 dahdi mxl5005s s5h1409 tuner_simple tuner_types
snd_hda_codec_analog cs5345 tuner cx18 dvb_core cx2341x snd_hda_intel
v4l2_common videodev snd_hda_codec nvidia(P) v4l1_compat
v4l2_compat_ioctl32 snd_hwdep ir_common snd_pcm snd_timer ir_core snd
snd_page_alloc tveeprom
[   22.919010] Pid: 2628, comm: fsck.ext4 Tainted: P
2.6.30-gentoo-r9 #1 P5K3 Deluxe
[   22.919012] RIP: 0010:[<ffffffff813c72b6>]  [<ffffffff813c72b6>]
md_write_start+0x22/0x14d
[   22.919019] RSP: 0018:ffff8802275799d8  EFLAGS: 00010246
[   22.919021] RAX: 0000000000000001 RBX: ffff88022c450400 RCX: 0000000=
0000000ff
[   22.919023] RDX: 00000000c8040180 RSI: ffff88022bde1b40 RDI: ffff880=
22c450400
[   22.919025] RBP: ffff880227579a28 R08: 0000000000001000 R09: ffff880=
22d8f3e60
[   22.919027] R10: 000000102ad44690 R11: 7fffffffffffffff R12: ffff880=
22c450400
[   22.919029] R13: ffff88022c4d0000 R14: 00000000c8040180 R15: 0000000=
00090007f
[   22.919032] FS:  00007f02a33fc760(0000) GS:ffff880028034000(0000)
knlGS:0000000000000000
[   22.919034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.919036] CR2: 00007f02a249beca CR3: 00000002279b6000 CR4: 0000000=
0000026e0
[   22.919038] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   22.919040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   22.919042] Process fsck.ext4 (pid: 2628, threadinfo
ffff880227578000, task ffff88022a8257c0)
[   22.919044] Stack:
[   22.919044]  0000000000000004 ffff88022d8f3e60 0000000000000001
0000000000000010
[   22.919047]  ffff880227579a48 ffffffff810f3913 ffff880227579a18
ffff88022bde1b40
[   22.919049]  ffff88022c450400 ffff88022c4d0000 ffff880227579ae8
ffffffff813c1707
[   22.919052] Call Trace:
[   22.919054]  [<ffffffff810f3913>] ? bio_alloc_bioset+0x48/0xbd
[   22.919058]  [<ffffffff813c1707>] make_request+0x4b/0x61b
[   22.919061]  [<ffffffffa0a8f9b6>] ? __map_bio+0xad/0x10c [dm_mod]
[   22.919069]  [<ffffffffa0a90497>] ?
__split_and_process_bio+0x400/0x40f [dm_mod]
[   22.919075]  [<ffffffff813c74ed>] md_make_request+0xb6/0xf4
[   22.919078]  [<ffffffff812436ef>] ? __up_read+0x8d/0x96
[   22.919081]  [<ffffffff8106a163>] ? up_read+0x9/0xb
[   22.919084]  [<ffffffff8122fe9e>] generic_make_request+0x213/0x25d
[   22.919087]  [<ffffffff8104def0>] ? try_to_wake_up+0x28f/0x2a1
[   22.919091]  [<ffffffff8122ffb7>] submit_bio+0xcf/0xd8
[   22.919093]  [<ffffffff810ef62b>] submit_bh+0xdd/0x100
[   22.919096]  [<ffffffff810f1907>] __block_write_full_page+0x1d3/0x2a=
e
[   22.919099]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.919101]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.919104]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.919106]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.919109]  [<ffffffff810f1a66>] block_write_full_page_endio+0x84/0=
x91
[   22.919112]  [<ffffffff810f1a83>] block_write_full_page+0x10/0x12
[   22.919114]  [<ffffffff810f482f>] blkdev_writepage+0x13/0x15
[   22.919117]  [<ffffffff810a6ec1>] __writepage+0x12/0x2b
[   22.919120]  [<ffffffff810a74ee>] write_cache_pages+0x244/0x3c1
[   22.919123]  [<ffffffff810a6eaf>] ? __writepage+0x0/0x2b
[   22.919126]  [<ffffffff812615bd>] ? do_output_char+0x92/0x1bd
[   22.919129]  [<ffffffff81067220>] ? remove_wait_queue+0x40/0x45
[   22.919133]  [<ffffffff810a768a>] generic_writepages+0x1f/0x21
[   22.919136]  [<ffffffff810a76b4>] do_writepages+0x28/0x37
[   22.919138]  [<ffffffff810a1a6f>] __filemap_fdatawrite_range+0x4b/0x=
4d
[   22.919141]  [<ffffffff810a2233>] filemap_fdatawrite+0x1a/0x1c
[   22.919144]  [<ffffffff810ee3ad>] vfs_fsync+0x51/0xa7
[   22.919146]  [<ffffffff810ee432>] do_fsync+0x2f/0x44
[   22.919148]  [<ffffffff810ee464>] sys_fsync+0xb/0xf
[   22.919150]  [<ffffffff81026ac2>] system_call_fastpath+0x16/0x1b
[   22.919154] Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41
54 53 48 89 fb 48 83 ec 38 f6 46 20 01 0f 84 28 01 00 00 8b 47 38 83
f8 01 75 04 <0f> 0b eb fe 45 31 e4 83 f8 02 75 2a c7 47 38 00 00 00 00
f0 80
[   22.919170] RIP  [<ffffffff813c72b6>] md_write_start+0x22/0x14d
[   22.919173]  RSP <ffff8802275799d8>
[   22.919184] ---[ end trace f4d0f953e0b63e69 ]---
[   22.950663] ------------[ cut here ]------------
[   22.950665] kernel BUG at drivers/md/md.c:6139!
[   22.950667] invalid opcode: 0000 [#2] SMP
[   22.950668] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sd=
a/uevent
[   22.950670] CPU 0
[   22.950671] Modules linked in: dm_mod wanrouter sdladrv wctdm
dahdi_echocan_mg2 dahdi mxl5005s s5h1409 tuner_simple tuner_types
snd_hda_codec_analog cs5345 tuner cx18 dvb_core cx2341x snd_hda_intel
v4l2_common videodev snd_hda_codec nvidia(P) v4l1_compat
v4l2_compat_ioctl32 snd_hwdep ir_common snd_pcm snd_timer ir_core snd
snd_page_alloc tveeprom
[   22.950686] Pid: 2629, comm: fsck.ext4 Tainted: P      D
2.6.30-gentoo-r9 #1 P5K3 Deluxe
[   22.950688] RIP: 0010:[<ffffffff813c72b6>]  [<ffffffff813c72b6>]
md_write_start+0x22/0x14d
[   22.950692] RSP: 0018:ffff8802279b59d8  EFLAGS: 00010246
[   22.950694] RAX: 0000000000000001 RBX: ffff88022c450400 RCX: 0000000=
0000000ff
[   22.950696] RDX: 00000000da840180 RSI: ffff88022bde1a80 RDI: ffff880=
22c450400
[   22.950698] RBP: ffff8802279b5a28 R08: 0000000000001000 R09: ffff880=
22d9d9ee0
[   22.950700] R10: 000000102acbbb10 R11: 7fffffffffffffff R12: ffff880=
22c450400
[   22.950702] R13: ffff88022c4d0000 R14: 00000000da840180 R15: 0000000=
00090007f
[   22.950705] FS:  00007f3acd410760(0000) GS:ffff880028034000(0000)
knlGS:0000000000000000
[   22.950707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.950709] CR2: 00007f3acc4afeca CR3: 0000000227009000 CR4: 0000000=
0000026e0
[   22.950711] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   22.950713] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   22.950715] Process fsck.ext4 (pid: 2629, threadinfo
ffff8802279b4000, task ffff88022a871d40)
[   22.950717] Stack:
[   22.950718]  0000000000000004 ffff88022d9d9ee0 0000000000000001
0000000000000010
[   22.950720]  ffff8802279b5a48 ffffffff810f3913 ffff8802279b5a18
ffff88022bde1a80
[   22.950722]  ffff88022c450400 ffff88022c4d0000 ffff8802279b5ae8
ffffffff813c1707
[   22.950725] Call Trace:
[   22.950726]  [<ffffffff810f3913>] ? bio_alloc_bioset+0x48/0xbd
[   22.950729]  [<ffffffff813c1707>] make_request+0x4b/0x61b
[   22.950732]  [<ffffffffa0a8f9b6>] ? __map_bio+0xad/0x10c [dm_mod]
[   22.950739]  [<ffffffffa0a90497>] ?
__split_and_process_bio+0x400/0x40f [dm_mod]
[   22.950745]  [<ffffffff813c74ed>] md_make_request+0xb6/0xf4
[   22.950748]  [<ffffffff812436ef>] ? __up_read+0x8d/0x96
[   22.950751]  [<ffffffff8106a163>] ? up_read+0x9/0xb
[   22.950753]  [<ffffffff8122fe9e>] generic_make_request+0x213/0x25d
[   22.950756]  [<ffffffff8104def0>] ? try_to_wake_up+0x28f/0x2a1
[   22.950759]  [<ffffffff8122ffb7>] submit_bio+0xcf/0xd8
[   22.950761]  [<ffffffff810ef62b>] submit_bh+0xdd/0x100
[   22.950764]  [<ffffffff810f1907>] __block_write_full_page+0x1d3/0x2a=
e
[   22.950766]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.950769]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.950772]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.950774]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.950777]  [<ffffffff810f1a66>] block_write_full_page_endio+0x84/0=
x91
[   22.950779]  [<ffffffff810f1a83>] block_write_full_page+0x10/0x12
[   22.950782]  [<ffffffff810f482f>] blkdev_writepage+0x13/0x15
[   22.950785]  [<ffffffff810a6ec1>] __writepage+0x12/0x2b
[   22.950787]  [<ffffffff810a74ee>] write_cache_pages+0x244/0x3c1
[   22.950790]  [<ffffffff810a6eaf>] ? __writepage+0x0/0x2b
[   22.950793]  [<ffffffff812615bd>] ? do_output_char+0x92/0x1bd
[   22.950796]  [<ffffffff81067220>] ? remove_wait_queue+0x40/0x45
[   22.950799]  [<ffffffff810a768a>] generic_writepages+0x1f/0x21
[   22.950801]  [<ffffffff810a76b4>] do_writepages+0x28/0x37
[   22.950804]  [<ffffffff810a1a6f>] __filemap_fdatawrite_range+0x4b/0x=
4d
[   22.950806]  [<ffffffff810a2233>] filemap_fdatawrite+0x1a/0x1c
[   22.950809]  [<ffffffff810ee3ad>] vfs_fsync+0x51/0xa7
[   22.950811]  [<ffffffff810ee432>] do_fsync+0x2f/0x44
[   22.950813]  [<ffffffff810ee464>] sys_fsync+0xb/0xf
[   22.950815]  [<ffffffff81026ac2>] system_call_fastpath+0x16/0x1b
[   22.950819] Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41
54 53 48 89 fb 48 83 ec 38 f6 46 20 01 0f 84 28 01 00 00 8b 47 38 83
f8 01 75 04 <0f> 0b eb fe 45 31 e4 83 f8 02 75 2a c7 47 38 00 00 00 00
f0 80
[   22.950834] RIP  [<ffffffff813c72b6>] md_write_start+0x22/0x14d
[   22.950837]  RSP <ffff8802279b59d8>
[   22.950839] ---[ end trace f4d0f953e0b63e6a ]---
[   22.990861] ------------[ cut here ]------------
[   22.990865] kernel BUG at drivers/md/md.c:6139!
[   22.990868] invalid opcode: 0000 [#3] SMP
[   22.990871] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sd=
a/uevent
[   22.990874] CPU 3
[   22.990876] Modules linked in: dm_mod wanrouter sdladrv wctdm
dahdi_echocan_mg2 dahdi mxl5005s s5h1409 tuner_simple tuner_types
snd_hda_codec_analog cs5345 tuner cx18 dvb_core cx2341x snd_hda_intel
v4l2_common videodev snd_hda_codec nvidia(P) v4l1_compat
v4l2_compat_ioctl32 snd_hwdep ir_common snd_pcm snd_timer ir_core snd
snd_page_alloc tveeprom
[   22.990900] Pid: 2631, comm: fsck.ext4 Tainted: P      D
2.6.30-gentoo-r9 #1 P5K3 Deluxe
[   22.990903] RIP: 0010:[<ffffffff813c72b6>]  [<ffffffff813c72b6>]
md_write_start+0x22/0x14d
[   22.990913] RSP: 0018:ffff8802275799d8  EFLAGS: 00010246
[   22.990915] RAX: 0000000000000001 RBX: ffff88022c450400 RCX: 0000000=
0000000ff
[   22.990919] RDX: 00000000e7040180 RSI: ffff88022c55be40 RDI: ffff880=
22c450400
[   22.990922] RBP: ffff880227579a28 R08: 0000000000001000 R09: ffff880=
22d877f20
[   22.990925] R10: 000000102acba990 R11: 7fffffffffffffff R12: ffff880=
22c450400
[   22.990928] R13: ffff88022c4d0000 R14: 00000000e7040180 R15: 0000000=
00090007f
[   22.990931] FS:  00007f1d01181760(0000) GS:ffff880028082000(0000)
knlGS:0000000000000000
[   22.990934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.990937] CR2: 00007f1d00220eca CR3: 00000002279b6000 CR4: 0000000=
0000026e0
[   22.990940] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   22.990943] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   22.990952] Process fsck.ext4 (pid: 2631, threadinfo
ffff880227578000, task ffff88022a870ea0)
[   22.990954] Stack:
[   22.990955]  0000000000000004 ffff88022d877f20 0000000000000001
0000000000000010
[   22.990957]  ffff880227579a48 ffffffff810f3913 ffff880227579a18
ffff88022c55be40
[   22.990960]  ffff88022c450400 ffff88022c4d0000 ffff880227579ae8
ffffffff813c1707
[   22.990962] Call Trace:
[   22.990964]  [<ffffffff810f3913>] ? bio_alloc_bioset+0x48/0xbd
[   22.990968]  [<ffffffff813c1707>] make_request+0x4b/0x61b
[   22.990972]  [<ffffffffa0a8f9b6>] ? __map_bio+0xad/0x10c [dm_mod]
[   22.990979]  [<ffffffffa0a90497>] ?
__split_and_process_bio+0x400/0x40f [dm_mod]
[   22.990986]  [<ffffffff813c74ed>] md_make_request+0xb6/0xf4
[   22.990988]  [<ffffffff812436ef>] ? __up_read+0x8d/0x96
[   22.990992]  [<ffffffff8106a163>] ? up_read+0x9/0xb
[   22.990995]  [<ffffffff8122fe9e>] generic_make_request+0x213/0x25d
[   22.990998]  [<ffffffff810df3d1>] ? pollwake+0x40/0x42
[   22.991001]  [<ffffffff8122ffb7>] submit_bio+0xcf/0xd8
[   22.991003]  [<ffffffff810ef62b>] submit_bh+0xdd/0x100
[   22.991006]  [<ffffffff810f1907>] __block_write_full_page+0x1d3/0x2a=
e
[   22.991009]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.991011]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.991014]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   22.991017]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   22.991019]  [<ffffffff810f1a66>] block_write_full_page_endio+0x84/0=
x91
[   22.991022]  [<ffffffff810f1a83>] block_write_full_page+0x10/0x12
[   22.991024]  [<ffffffff810f482f>] blkdev_writepage+0x13/0x15
[   22.991027]  [<ffffffff810a6ec1>] __writepage+0x12/0x2b
[   22.991031]  [<ffffffff810a74ee>] write_cache_pages+0x244/0x3c1
[   22.991034]  [<ffffffff810a6eaf>] ? __writepage+0x0/0x2b
[   22.991036]  [<ffffffff812615bd>] ? do_output_char+0x92/0x1bd
[   22.991040]  [<ffffffff81067220>] ? remove_wait_queue+0x40/0x45
[   22.991044]  [<ffffffff810a768a>] generic_writepages+0x1f/0x21
[   22.991047]  [<ffffffff810a76b4>] do_writepages+0x28/0x37
[   22.991049]  [<ffffffff810a1a6f>] __filemap_fdatawrite_range+0x4b/0x=
4d
[   22.991052]  [<ffffffff810a2233>] filemap_fdatawrite+0x1a/0x1c
[   22.991054]  [<ffffffff810ee3ad>] vfs_fsync+0x51/0xa7
[   22.991057]  [<ffffffff810ee432>] do_fsync+0x2f/0x44
[   22.991059]  [<ffffffff810ee464>] sys_fsync+0xb/0xf
[   22.991061]  [<ffffffff81026ac2>] system_call_fastpath+0x16/0x1b
[   22.991066] Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41
54 53 48 89 fb 48 83 ec 38 f6 46 20 01 0f 84 28 01 00 00 8b 47 38 83
f8 01 75 04 <0f> 0b eb fe 45 31 e4 83 f8 02 75 2a c7 47 38 00 00 00 00
f0 80
[   22.991081] RIP  [<ffffffff813c72b6>] md_write_start+0x22/0x14d
[   22.991084]  RSP <ffff8802275799d8>
[   22.991087] ---[ end trace f4d0f953e0b63e6b ]---
[   23.022827] ------------[ cut here ]------------
[   23.023001] kernel BUG at drivers/md/md.c:6139!
[   23.023176] invalid opcode: 0000 [#4] SMP
[   23.023381] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sd=
a/uevent
[   23.023381] CPU 3
[   23.023381] Modules linked in: dm_mod wanrouter sdladrv wctdm
dahdi_echocan_mg2 dahdi mxl5005s s5h1409 tuner_simple tuner_types
snd_hda_codec_analog cs5345 tuner cx18 dvb_core cx2341x snd_hda_intel
v4l2_common videodev snd_hda_codec nvidia(P) v4l1_compat
v4l2_compat_ioctl32 snd_hwdep ir_common snd_pcm snd_timer ir_core snd
snd_page_alloc tveeprom
[   23.023381] Pid: 2632, comm: fsck.ext4 Tainted: P      D
2.6.30-gentoo-r9 #1 P5K3 Deluxe
[   23.023381] RIP: 0010:[<ffffffff813c72b6>]  [<ffffffff813c72b6>]
md_write_start+0x22/0x14d
[   23.023381] RSP: 0018:ffff8802279b59d8  EFLAGS: 00010246
[   23.023381] RAX: 0000000000000001 RBX: ffff88022c450400 RCX: 0000000=
0000000ff
[   23.023381] RDX: 000000005d840180 RSI: ffff88022b56ecc0 RDI: ffff880=
22c450400
[   23.023381] RBP: ffff8802279b5a28 R08: 0000000000001000 R09: ffff880=
22780ae20
[   23.023381] R10: 000000102edd93b0 R11: 7fffffffffffffff R12: ffff880=
22c450400
[   23.023381] R13: ffff88022c4d0000 R14: 000000005d840180 R15: 0000000=
00090007f
[   23.023381] FS:  00007f2604bcc760(0000) GS:ffff880028082000(0000)
knlGS:0000000000000000
[   23.023381] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.023381] CR2: 00007f2603c6beca CR3: 0000000227041000 CR4: 0000000=
0000026e0
[   23.023381] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   23.023381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   23.023381] Process fsck.ext4 (pid: 2632, threadinfo
ffff8802279b4000, task ffff88022d9195f0)
[   23.023381] Stack:
[   23.023381]  0000000000000004 ffff88022780ae20 0000000000000001
0000000000000010
[   23.023381]  ffff8802279b5a48 ffffffff810f3913 ffff8802279b5a18
ffff88022b56ecc0
[   23.023381]  ffff88022c450400 ffff88022c4d0000 ffff8802279b5ae8
ffffffff813c1707
[   23.023381] Call Trace:
[   23.023381]  [<ffffffff810f3913>] ? bio_alloc_bioset+0x48/0xbd
[   23.023381]  [<ffffffff813c1707>] make_request+0x4b/0x61b
[   23.023381]  [<ffffffffa0a8f9b6>] ? __map_bio+0xad/0x10c [dm_mod]
[   23.023381]  [<ffffffffa0a90497>] ?
__split_and_process_bio+0x400/0x40f [dm_mod]
[   23.023381]  [<ffffffff813c74ed>] md_make_request+0xb6/0xf4
[   23.023381]  [<ffffffff812436ef>] ? __up_read+0x8d/0x96
[   23.023381]  [<ffffffff8106a163>] ? up_read+0x9/0xb
[   23.023381]  [<ffffffff8122fe9e>] generic_make_request+0x213/0x25d
[   23.023381]  [<ffffffff8104def0>] ? try_to_wake_up+0x28f/0x2a1
[   23.023381]  [<ffffffff8122ffb7>] submit_bio+0xcf/0xd8
[   23.023381]  [<ffffffff810ef62b>] submit_bh+0xdd/0x100
[   23.023381]  [<ffffffff810f1907>] __block_write_full_page+0x1d3/0x2a=
e
[   23.023381]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   23.023381]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   23.023381]  [<ffffffff810f1f34>] ? end_buffer_async_write+0x0/0x101
[   23.023381]  [<ffffffff810f3c75>] ? blkdev_get_block+0x0/0x5e
[   23.023381]  [<ffffffff810f1a66>] block_write_full_page_endio+0x84/0=
x91
[   23.023381]  [<ffffffff810f1a83>] block_write_full_page+0x10/0x12
[   23.023381]  [<ffffffff810f482f>] blkdev_writepage+0x13/0x15
[   23.023381]  [<ffffffff810a6ec1>] __writepage+0x12/0x2b
[   23.023381]  [<ffffffff810a74ee>] write_cache_pages+0x244/0x3c1
[   23.023381]  [<ffffffff810a6eaf>] ? __writepage+0x0/0x2b
[   23.023381]  [<ffffffff812615bd>] ? do_output_char+0x92/0x1bd
[   23.023381]  [<ffffffff81067220>] ? remove_wait_queue+0x40/0x45
[   23.023381]  [<ffffffff810a768a>] generic_writepages+0x1f/0x21
[   23.023381]  [<ffffffff810a76b4>] do_writepages+0x28/0x37
[   23.023381]  [<ffffffff810a1a6f>] __filemap_fdatawrite_range+0x4b/0x=
4d
[   23.023381]  [<ffffffff810a2233>] filemap_fdatawrite+0x1a/0x1c
[   23.023381]  [<ffffffff810ee3ad>] vfs_fsync+0x51/0xa7
[   23.023381]  [<ffffffff810ee432>] do_fsync+0x2f/0x44
[   23.023381]  [<ffffffff810ee464>] sys_fsync+0xb/0xf
[   23.023381]  [<ffffffff81026ac2>] system_call_fastpath+0x16/0x1b
[   23.023381] Code: 5c 41 5d 41 5e 41 5f c9 c3 55 48 89 e5 41 55 41
54 53 48 89 fb 48 83 ec 38 f6 46 20 01 0f 84 28 01 00 00 8b 47 38 83
f8 01 75 04 <0f> 0b eb fe 45 31 e4 83 f8 02 75 2a c7 47 38 00 00 00 00
f0 80
[   23.023381] RIP  [<ffffffff813c72b6>] md_write_start+0x22/0x14d
[   23.023381]  RSP <ffff8802279b59d8>
[   23.040045] ---[ end trace f4d0f953e0b63e6c ]---

On Tue, Mar 23, 2010 at 3:01 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Mon, Mar 22, 2010 at 8:56 PM, Randy Terbush <randy@terbush.org> wr=
ote:
>> Having a go at building a raid5 array using the new imsm support and
>> having good luck keeping drives in the array, etc. Nice work. I have=
 a
>> few questions though as I am having some trouble figuring out how to
>> properly start this container.
>>
>> # mdadm --version
>> mdadm - v3.1.2 - 10th March 2010
>>
>> # mdadm -Es
>> ARRAY metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b7f0
>> ARRAY /dev/md/Volume0 container=3D30223250:76fd248b:50280919:0836b7f=
0
>> member=3D0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>>
>> # ls -l /dev/md/
>> total 0
>> lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
>> lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>>
>> As you can see, the name for the link in /dev/md does not agree with
>> the name that the Examine is coming up with.
>
> It looks like your array was auto-assembled without the help of a
> configuration file (what distribution are you using?). =A0When there =
is
> no configuration file mdadm will append _<num> to indicate that this
> might be a foreign array (i.e. an array from another system). =A0The
> only way the imsm code knows that the array is local is by having an
> up to date mdadm.conf file with all your local arrays listed.
>
> If you add the following lines to your configuration file:
> ARRAY /dev/md0 UUID=3D30223250:76fd248b:50280919:0836b7f0
> ARRAY /dev/md/Volume0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>
> You should get the expected name. =A0Note that the arrays might be be=
ing
> assembled by your initramfs environment. =A0So you may need to re-run
> mkinitrd after modifying mdadm.conf.
>
>> Is it better to just forgo the ARRAY statements and go with an AUTO =
+imsm?
>
> If you don't mind the naming discrepancy then you can keep your curre=
nt setup.
>
>> And last, does the concept of a write-intent bitmap make sense on an
>> imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
>> -Gb internal on either device.
>
> That should be disallowed for imsm rather than segfault, I'll take a
> look at addressing that. =A0The current write-intent bitmap
> implementation is only compatible with native md-metadata for an
> internal bitmap. =A0However, you should still be able to use an exter=
nal
> bitmap with imsm. =A0The imsm internal equivalent "dirty-stripe journ=
al"
> is still on the to do list.
>
>> Thanks for your help
>
> Thanks for the report,
> Dan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
