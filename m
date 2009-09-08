From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm /dev/md0 --detail returns nothing / no LUKS partition
Date: Wed, 9 Sep 2009 07:13:10 +1000 (EST)
Message-ID: <1e068e85fdd495e55ba8c55bc21f386f.squirrel@neil.brown.name>
References: <20090908204525.GE2324@freigeist.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090908204525.GE2324@freigeist.org>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes 'fish' Ziemke <fish@freigeist.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, September 9, 2009 6:45 am, Johannes 'fish' Ziemke wrote:
> Hi,
>
> i'v moved my four raid5 discs from one system to another. There is a
> dmcrypt/luks encrypted xfs on it.
>
> mdadm seems to autodetect everything correctly:
>
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[1] sdc1[3] sdb1[0] sda1[2]
>       4395407808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>
>
> mdadm /dev/md0
> /dev/md0: 4191.79GiB raid5 4 devices, 0 spares. Use mdadm --detail for
> more detail.
>
>
> But 'mdadm /dev/md0 --detail' outputs nothing.

You want
   mdadm --detail /dev/md0

I guess I should fix that.

> The last lines of strace are:
>
> open("/dev/md0", O_RDWR)                = 3
> fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
> ioctl(3, 0x800c0910, 0x7fff923a4a40)    = 0
> close(3)                                = 0
> exit_group(0)                           = ?
>
>
> And luksOpen fails:
>
> ryptsetup luksOpen /dev/md0 data
> Enter LUKS passphrase for /dev/md0:
> Command failed: /dev/md0 is not a LUKS partition

I cannot help here, sorry.

NeilBrown


>
>
> fdisk looks ok but it cant find a partition table, but that might be
> normal for a raw dmcrypt disc:
>
> fdisk -l /dev/md0
>
> Disk /dev/md0: 4500.9 GB, 4500897595392 bytes
> 2 heads, 4 sectors/track, 1098851952 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0xc1f586ec
>
> Disk /dev/md0 doesn't contain a valid partition table
>
>
> Last but not least the relevant lines of dmesg:
>
> [    2.337382] sd 0:0:0:0: [sda] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.337454] sd 0:0:0:0: [sda] Write Protect is off
> [    2.337495] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.337526] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.337638] sd 0:0:0:0: [sda] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.337709] sd 0:0:0:0: [sda] Write Protect is off
> [    2.337750] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.337782] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.337840]  sda: sda1
> [    2.346341] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.347128] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HD154UI
> 1AG0 PQ: 0 ANSI: 5
> [    2.347329] sd 0:0:1:0: [sdb] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.347399] sd 0:0:1:0: [sdb] Write Protect is off
> [    2.347441] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.347472] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.347583] sd 0:0:1:0: [sdb] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.347652] sd 0:0:1:0: [sdb] Write Protect is off
> [    2.347694] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.347724] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.347782]  sdb: sdb1
> [    2.354690] sd 0:0:1:0: [sdb] Attached SCSI disk
> [    2.354852] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI
> 1AG0 PQ: 0 ANSI: 5
> [    2.355065] sd 1:0:0:0: [sdc] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.355135] sd 1:0:0:0: [sdc] Write Protect is off
> [    2.355176] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    2.355207] sd 1:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.355315] sd 1:0:0:0: [sdc] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.355385] sd 1:0:0:0: [sdc] Write Protect is off
> [    2.355426] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    2.355458] sd 1:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.355516]  sdc: sdc1
> [    2.359050] sd 1:0:0:0: [sdc] Attached SCSI disk
> [    2.359207] scsi 1:0:1:0: Direct-Access     ATA      SAMSUNG HD154UI
> 1AG0 PQ: 0 ANSI: 5
> [    2.359419] sd 1:0:1:0: [sdd] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.359488] sd 1:0:1:0: [sdd] Write Protect is off
> [    2.359530] sd 1:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [    2.359560] sd 1:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.359669] sd 1:0:1:0: [sdd] 2930277168 512-byte hardware sectors
> (1500302 MB)
> [    2.359739] sd 1:0:1:0: [sdd] Write Protect is off
> [    2.359780] sd 1:0:1:0: [sdd] Mode Sense: 00 3a 00 00
> [    2.359812] sd 1:0:1:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.359869]  sdd: sdd1
> [    2.371875] sd 1:0:1:0: [sdd] Attached SCSI disk
>
> ....
>
> [    2.483365] raid6: int64x1   1546 MB/s
> [    2.540031] raid6: int64x2   2087 MB/s
> [    2.596698] raid6: int64x4   1932 MB/s
> [    2.653362] raid6: int64x8   1374 MB/s
> [    2.710007] raid6: sse2x1    2547 MB/s
> [    2.766684] raid6: sse2x2    2934 MB/s
> [    2.823348] raid6: sse2x4    4818 MB/s
> [    2.823388] raid6: using algorithm sse2x4 (4818 MB/s)
> [    2.823430] md: raid6 personality registered for level 6
> [    2.823471] md: raid5 personality registered for level 5
> [    2.823512] md: raid4 personality registered for level 4
> [    2.823680] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
> initialised: dm-devel@redhat.com
>
> ....
>
> [    2.826163] md: Autodetecting RAID arrays.
> [    2.919851] md: Scanned 4 and added 4 devices.
> [    2.919898] md: autorun ...
> [    2.919941] md: considering sdd1 ...
> [    2.919998] md:  adding sdd1 ...
> [    2.920054] md:  adding sdc1 ...
> [    2.920102] md:  adding sdb1 ...
> [    2.920156] md:  adding sda1 ...
> [    2.920195] md: created md0
> [    2.920232] md: bind<sda1>
> [    2.920282] md: bind<sdb1>
> [    2.920327] md: bind<sdc1>
> [    2.920395] md: bind<sdd1>
> [    2.920441] md: running: <sdd1><sdc1><sdb1><sda1>
> [    2.920662] raid5: device sdd1 operational as raid disk 1
> [    2.920704] raid5: device sdc1 operational as raid disk 3
> [    2.920745] raid5: device sdb1 operational as raid disk 0
> [    2.920787] raid5: device sda1 operational as raid disk 2
> [    2.921299] raid5: allocated 4268kB for md0
> [    2.921339] raid5: raid level 5 set md0 active with 4 out of 4
> devices, algorithm 2
> [    2.921394] RAID5 conf printout:
> [    2.921432]  --- rd:4 wd:4
> [    2.921470]  disk 0, o:1, dev:sdb1
> [    2.921509]  disk 1, o:1, dev:sdd1
> [    2.921548]  disk 2, o:1, dev:sda1
> [    2.921587]  disk 3, o:1, dev:sdc1
> [    2.921703] md: ... autorun DONE.
>
>
> Any ideas how I could debug that further?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

