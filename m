From: Costin <costinel@gmail.com>
Subject: Windows LDM status?
Date: Tue, 22 Mar 2011 16:22:19 +0300
Message-ID: <AANLkTinE5r5gyn5byunDdx0w0E0j+=6av7OSvF90HPas@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
List-Id: linux-raid.ids

Hello,
I would like to be able to access from linux a native windows xp
3-disk raid 0 array, however either there's something that I am
missing from documentation or linux ldm support status needs a
clarification (attempting to read data fails)

root@sysresccd /root % grep -i ldm /var/log/messages
Mar 21 17:39:34 sysresccd kernel: [    3.436624]  sda: [LDM] sda1
Mar 21 17:39:34 sysresccd kernel: [    4.669583]  sdb: [LDM] sdb1
Mar 21 17:39:34 sysresccd kernel: [    6.478531]  sdc: [LDM] sdc1

root@sysresccd /root % egrep 'sda|sdb|sdc' /var/log/messages
Mar 21 17:39:34 sysresccd kernel: [    3.435539] sd 0:0:0:0: [sda]
488397168 512-byte logical blocks: (250 GB/232 GiB)
Mar 21 17:39:34 sysresccd kernel: [    3.436025] sd 0:0:0:0: [sda]
Write Protect is off
Mar 21 17:39:34 sysresccd kernel: [    3.436187] sd 0:0:0:0: [sda]
Mode Sense: 00 3a 00 00
Mar 21 17:39:34 sysresccd kernel: [    3.436207] sd 0:0:0:0: [sda]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 21 17:39:34 sysresccd kernel: [    3.436624]  sda: [LDM] sda1
Mar 21 17:39:34 sysresccd kernel: [    3.492877] sd 0:0:0:0: [sda]
Attached SCSI disk
Mar 21 17:39:34 sysresccd kernel: [    4.668474] sd 2:0:0:0: [sdb]
488397168 512-byte logical blocks: (250 GB/232 GiB)
Mar 21 17:39:34 sysresccd kernel: [    4.668969] sd 2:0:0:0: [sdb]
Write Protect is off
Mar 21 17:39:34 sysresccd kernel: [    4.669123] sd 2:0:0:0: [sdb]
Mode Sense: 00 3a 00 00
Mar 21 17:39:34 sysresccd kernel: [    4.669152] sd 2:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 21 17:39:34 sysresccd kernel: [    4.669583]  sdb: [LDM] sdb1
Mar 21 17:39:34 sysresccd kernel: [    4.758469] sd 2:0:0:0: [sdb]
Attached SCSI disk
Mar 21 17:39:34 sysresccd kernel: [    6.477459] sd 4:0:0:0: [sdc]
488397168 512-byte logical blocks: (250 GB/232 GiB)
Mar 21 17:39:34 sysresccd kernel: [    6.477949] sd 4:0:0:0: [sdc]
Write Protect is off
Mar 21 17:39:34 sysresccd kernel: [    6.478103] sd 4:0:0:0: [sdc]
Mode Sense: 00 3a 00 00
Mar 21 17:39:34 sysresccd kernel: [    6.478129] sd 4:0:0:0: [sdc]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 21 17:39:34 sysresccd kernel: [    6.478531]  sdc: [LDM] sdc1
Mar 21 17:39:34 sysresccd kernel: [    6.569781] sd 4:0:0:0: [sdc]
Attached SCSI disk

root@sysresccd /root % cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
unused devices: <none>

root@sysresccd /root % mdadm --build -l 0 -n 3 /dev/md0 /dev/sda1
/dev/sdb1 /dev/sdc1
mdadm: array /dev/md0 built and started.

root@sysresccd /root % parted /dev/md0 print
Error: /dev/md0: unrecognised disk label

root@sysresccd /root % mdadm --build -l 0 -n 3 /dev/md0 /dev/sda
/dev/sdb /dev/sdc
mdadm: array /dev/md0 built and started.

root@sysresccd /root % parted /dev/md0 print
Model: Linux Software RAID Array (md)
Disk /dev/md0: 750GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
 1      32.3kB  250GB  250GB  primary

ntfs-3g obviously will fail reading data which is only a third of what =
it needs:

root@sysresccd /root % ntfs-3g -o ro /dev/md0p1 /mnt/windows
NTFS signature is missing.
=46ailed to mount '/dev/md0p1': Invalid argument
The device '/dev/md0p1' doesn't seem to have a valid NTFS.
Maybe the wrong device is used? Or the whole disk instead of a
partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?

root@sysresccd /root % grep md /var/log/messages
Mar 21 17:39:34 sysresccd kernel: [   23.044505] md: linear
personality registered for level -1
Mar 21 17:39:34 sysresccd kernel: [   23.046248] md: multipath
personality registered for level -4
Mar 21 17:39:34 sysresccd kernel: [   23.047733] md: raid0 personality
registered for level 0
Mar 21 17:39:34 sysresccd kernel: [   23.050262] md: raid1 personality
registered for level 1
Mar 21 17:39:34 sysresccd kernel: [   23.233140] md: raid6 personality
registered for level 6
Mar 21 17:39:34 sysresccd kernel: [   23.233142] md: raid5 personality
registered for level 5
Mar 21 17:39:34 sysresccd kernel: [   23.233143] md: raid4 personality
registered for level 4
Mar 21 17:39:34 sysresccd kernel: [   23.237839] md: raid10
personality registered for level 10
Mar 21 17:39:38 sysresccd kernel: [  173.559060] md: Autodetecting RAID=
 arrays.
Mar 21 17:39:38 sysresccd kernel: [  173.559062] md: Scanned 0 and
added 0 devices.
Mar 21 17:39:38 sysresccd kernel: [  173.559064] md: autorun ...
Mar 21 17:39:38 sysresccd kernel: [  173.559065] md: ... autorun DONE.
Mar 22 14:52:19 sysresccd kernel: [76534.599922] md: nonpersistent
superblock ...
Mar 22 14:52:19 sysresccd kernel: [76534.599925] md: bind<sda>
Mar 22 14:52:19 sysresccd kernel: [76534.599948] md: nonpersistent
superblock ...
Mar 22 14:52:19 sysresccd kernel: [76534.599949] md: bind<sdb>
Mar 22 14:52:19 sysresccd kernel: [76534.600272] md: nonpersistent
superblock ...
Mar 22 14:52:19 sysresccd kernel: [76534.600275] md: bind<sdc>
Mar 22 14:52:19 sysresccd kernel: [76534.607604] md/raid0:md0: looking =
at sdc
Mar 22 14:52:19 sysresccd kernel: [76534.607607] md/raid0:md0:
comparing sdc(488397056) with sdc(488397056)
Mar 22 14:52:19 sysresccd kernel: [76534.607609] md/raid0:md0:   END
Mar 22 14:52:19 sysresccd kernel: [76534.607611] md/raid0:md0:   =3D=3D=
> UNIQUE
Mar 22 14:52:19 sysresccd kernel: [76534.607612] md/raid0:md0: 1 zones
Mar 22 14:52:19 sysresccd kernel: [76534.607614] md/raid0:md0: looking =
at sdb
Mar 22 14:52:19 sysresccd kernel: [76534.607616] md/raid0:md0:
comparing sdb(488397056) with sdc(488397056)
Mar 22 14:52:19 sysresccd kernel: [76534.607618] md/raid0:md0:   EQUAL
Mar 22 14:52:19 sysresccd kernel: [76534.607620] md/raid0:md0: looking =
at sda
Mar 22 14:52:19 sysresccd kernel: [76534.607621] md/raid0:md0:
comparing sda(488397056) with sdc(488397056)
Mar 22 14:52:19 sysresccd kernel: [76534.607624] md/raid0:md0:   EQUAL
Mar 22 14:52:19 sysresccd kernel: [76534.607625] md/raid0:md0: FINAL 1 =
zones
Mar 22 14:52:19 sysresccd kernel: [76534.607628] md/raid0:md0: done.
Mar 22 14:52:19 sysresccd kernel: [76534.607630] md/raid0:md0: md_size
is 1465191168 sectors.
Mar 22 14:52:19 sysresccd kernel: [76534.607632] ******* md0
configuration *********
Mar 22 14:52:19 sysresccd kernel: [76534.607648] md0: detected
capacity change from 0 to 750177878016
Mar 22 14:52:19 sysresccd kernel: [76534.609770] md0: detected
capacity change from 0 to 750177878016
Mar 22 14:52:19 sysresccd kernel: [76534.609778]  md0:
Mar 22 15:26:22 sysresccd kernel: [78577.652324] md0: detected
capacity change from 750177878016 to 0
Mar 22 15:26:22 sysresccd kernel: [78577.652329] md: md0 stopped.
Mar 22 15:26:22 sysresccd kernel: [78577.652333] md: unbind<sdc>
Mar 22 15:26:22 sysresccd kernel: [78577.655069] md: export_rdev(sdc)
Mar 22 15:26:22 sysresccd kernel: [78577.655081] md: unbind<sdb>
Mar 22 15:26:22 sysresccd kernel: [78577.655096] md: export_rdev(sdb)
Mar 22 15:26:22 sysresccd kernel: [78577.655107] md: unbind<sda>
Mar 22 15:26:22 sysresccd kernel: [78577.657053] md: export_rdev(sda)
Mar 22 15:27:17 sysresccd kernel: [78632.225970] md: nonpersistent
superblock ...
Mar 22 15:27:17 sysresccd kernel: [78632.225974] md: bind<sda1>
Mar 22 15:27:17 sysresccd kernel: [78632.225999] md: nonpersistent
superblock ...
Mar 22 15:27:17 sysresccd kernel: [78632.226001] md: bind<sdb1>
Mar 22 15:27:17 sysresccd kernel: [78632.226023] md: nonpersistent
superblock ...
Mar 22 15:27:17 sysresccd kernel: [78632.226025] md: bind<sdc1>
Mar 22 15:27:17 sysresccd kernel: [78632.228219] md/raid0:md0: looking =
at sdc1
Mar 22 15:27:17 sysresccd kernel: [78632.228221] md/raid0:md0:
comparing sdc1(488391936) with sdc1(488391936)
Mar 22 15:27:17 sysresccd kernel: [78632.228224] md/raid0:md0:   END
Mar 22 15:27:17 sysresccd kernel: [78632.228225] md/raid0:md0:   =3D=3D=
> UNIQUE
Mar 22 15:27:17 sysresccd kernel: [78632.228227] md/raid0:md0: 1 zones
Mar 22 15:27:17 sysresccd kernel: [78632.228229] md/raid0:md0: looking =
at sdb1
Mar 22 15:27:17 sysresccd kernel: [78632.228231] md/raid0:md0:
comparing sdb1(488391936) with sdc1(488391936)
Mar 22 15:27:17 sysresccd kernel: [78632.228233] md/raid0:md0:   EQUAL
Mar 22 15:27:17 sysresccd kernel: [78632.228235] md/raid0:md0: looking =
at sda1
Mar 22 15:27:17 sysresccd kernel: [78632.228237] md/raid0:md0:
comparing sda1(488391936) with sdc1(488391936)
Mar 22 15:27:17 sysresccd kernel: [78632.228239] md/raid0:md0:   EQUAL
Mar 22 15:27:17 sysresccd kernel: [78632.228241] md/raid0:md0: FINAL 1 =
zones
Mar 22 15:27:17 sysresccd kernel: [78632.228244] md/raid0:md0: done.
Mar 22 15:27:17 sysresccd kernel: [78632.228246] md/raid0:md0: md_size
is 1465175808 sectors.
Mar 22 15:27:17 sysresccd kernel: [78632.228248] ******* md0
configuration *********
Mar 22 15:27:17 sysresccd kernel: [78632.228264] md0: detected
capacity change from 0 to 750170013696
Mar 22 15:27:17 sysresccd kernel: [78632.229357] md0: detected
capacity change from 0 to 750170013696
Mar 22 15:27:17 sysresccd kernel: [78632.229364]  md0: unknown partitio=
n table
Mar 22 15:29:21 sysresccd kernel: [78756.740476] md0: detected
capacity change from 750170013696 to 0
Mar 22 15:29:21 sysresccd kernel: [78756.740481] md: md0 stopped.
Mar 22 15:29:21 sysresccd kernel: [78756.740485] md: unbind<sdc1>
Mar 22 15:29:21 sysresccd kernel: [78756.740503] md: export_rdev(sdc1)
Mar 22 15:29:21 sysresccd kernel: [78756.740515] md: unbind<sdb1>
Mar 22 15:29:21 sysresccd kernel: [78756.743149] md: export_rdev(sdb1)
Mar 22 15:29:21 sysresccd kernel: [78756.743161] md: unbind<sda1>
Mar 22 15:29:21 sysresccd kernel: [78756.743175] md: export_rdev(sda1)
Mar 22 16:02:04 sysresccd kernel: [80719.752982] md: nonpersistent
superblock ...
Mar 22 16:02:04 sysresccd kernel: [80719.752986] md: bind<sda1>
Mar 22 16:02:04 sysresccd kernel: [80719.753011] md: nonpersistent
superblock ...
Mar 22 16:02:04 sysresccd kernel: [80719.753013] md: bind<sdb1>
Mar 22 16:02:04 sysresccd kernel: [80719.753034] md: nonpersistent
superblock ...
Mar 22 16:02:04 sysresccd kernel: [80719.753036] md: bind<sdc1>
Mar 22 16:02:04 sysresccd kernel: [80719.755405] md/raid0:md0: looking =
at sdc1
Mar 22 16:02:04 sysresccd kernel: [80719.755408] md/raid0:md0:
comparing sdc1(488391936) with sdc1(488391936)
Mar 22 16:02:04 sysresccd kernel: [80719.755410] md/raid0:md0:   END
Mar 22 16:02:04 sysresccd kernel: [80719.755412] md/raid0:md0:   =3D=3D=
> UNIQUE
Mar 22 16:02:04 sysresccd kernel: [80719.755413] md/raid0:md0: 1 zones
Mar 22 16:02:04 sysresccd kernel: [80719.755415] md/raid0:md0: looking =
at sdb1
Mar 22 16:02:04 sysresccd kernel: [80719.755417] md/raid0:md0:
comparing sdb1(488391936) with sdc1(488391936)
Mar 22 16:02:04 sysresccd kernel: [80719.755419] md/raid0:md0:   EQUAL
Mar 22 16:02:04 sysresccd kernel: [80719.755421] md/raid0:md0: looking =
at sda1
Mar 22 16:02:04 sysresccd kernel: [80719.755423] md/raid0:md0:
comparing sda1(488391936) with sdc1(488391936)
Mar 22 16:02:04 sysresccd kernel: [80719.755426] md/raid0:md0:   EQUAL
Mar 22 16:02:04 sysresccd kernel: [80719.755427] md/raid0:md0: FINAL 1 =
zones
Mar 22 16:02:04 sysresccd kernel: [80719.755430] md/raid0:md0: done.
Mar 22 16:02:04 sysresccd kernel: [80719.755432] md/raid0:md0: md_size
is 1465175808 sectors.
Mar 22 16:02:04 sysresccd kernel: [80719.755434] ******* md0
configuration *********
Mar 22 16:02:04 sysresccd kernel: [80719.755451] md0: detected
capacity change from 0 to 750170013696
Mar 22 16:02:04 sysresccd kernel: [80719.757166] md0: detected
capacity change from 0 to 750170013696
Mar 22 16:02:04 sysresccd kernel: [80719.757173]  md0: unknown partitio=
n table
Mar 22 16:06:58 sysresccd kernel: [81013.212365] md0: detected
capacity change from 750170013696 to 0
Mar 22 16:06:58 sysresccd kernel: [81013.212370] md: md0 stopped.
Mar 22 16:06:58 sysresccd kernel: [81013.212375] md: unbind<sdc1>
Mar 22 16:06:58 sysresccd kernel: [81013.219008] md: export_rdev(sdc1)
Mar 22 16:06:58 sysresccd kernel: [81013.219020] md: unbind<sdb1>
Mar 22 16:06:58 sysresccd kernel: [81013.222008] md: export_rdev(sdb1)
Mar 22 16:06:58 sysresccd kernel: [81013.222018] md: unbind<sda1>
Mar 22 16:06:58 sysresccd kernel: [81013.226647] md: export_rdev(sda1)
Mar 22 16:07:28 sysresccd kernel: [81043.831869] md: nonpersistent
superblock ...
Mar 22 16:07:28 sysresccd kernel: [81043.831873] md: bind<sda1>
Mar 22 16:07:28 sysresccd kernel: [81043.832175] md: nonpersistent
superblock ...
Mar 22 16:07:28 sysresccd kernel: [81043.832177] md: bind<sdb1>
Mar 22 16:07:28 sysresccd kernel: [81043.832200] md: nonpersistent
superblock ...
Mar 22 16:07:28 sysresccd kernel: [81043.832202] md: bind<sdc1>
Mar 22 16:07:28 sysresccd kernel: [81043.833778] md/raid0:md0: looking =
at sdc1
Mar 22 16:07:28 sysresccd kernel: [81043.833781] md/raid0:md0:
comparing sdc1(488391936) with sdc1(488391936)
Mar 22 16:07:28 sysresccd kernel: [81043.833784] md/raid0:md0:   END
Mar 22 16:07:28 sysresccd kernel: [81043.833785] md/raid0:md0:   =3D=3D=
> UNIQUE
Mar 22 16:07:28 sysresccd kernel: [81043.833787] md/raid0:md0: 1 zones
Mar 22 16:07:28 sysresccd kernel: [81043.833788] md/raid0:md0: looking =
at sdb1
Mar 22 16:07:28 sysresccd kernel: [81043.833790] md/raid0:md0:
comparing sdb1(488391936) with sdc1(488391936)
Mar 22 16:07:28 sysresccd kernel: [81043.833793] md/raid0:md0:   EQUAL
Mar 22 16:07:28 sysresccd kernel: [81043.833794] md/raid0:md0: looking =
at sda1
Mar 22 16:07:28 sysresccd kernel: [81043.833796] md/raid0:md0:
comparing sda1(488391936) with sdc1(488391936)
Mar 22 16:07:28 sysresccd kernel: [81043.833799] md/raid0:md0:   EQUAL
Mar 22 16:07:28 sysresccd kernel: [81043.833800] md/raid0:md0: FINAL 1 =
zones
Mar 22 16:07:28 sysresccd kernel: [81043.833803] md/raid0:md0: done.
Mar 22 16:07:28 sysresccd kernel: [81043.833805] md/raid0:md0: md_size
is 1465175808 sectors.
Mar 22 16:07:28 sysresccd kernel: [81043.833807] ******* md0
configuration *********
Mar 22 16:07:28 sysresccd kernel: [81043.833823] md0: detected
capacity change from 0 to 750170013696
Mar 22 16:07:28 sysresccd kernel: [81043.835806] md0: detected
capacity change from 0 to 750170013696
Mar 22 16:07:28 sysresccd kernel: [81043.835813]  md0: unknown partitio=
n table
Mar 22 16:08:07 sysresccd kernel: [81082.737453] md0: detected
capacity change from 750170013696 to 0
Mar 22 16:08:07 sysresccd kernel: [81082.737457] md: md0 stopped.
Mar 22 16:08:07 sysresccd kernel: [81082.737461] md: unbind<sdc1>
Mar 22 16:08:07 sysresccd kernel: [81082.737479] md: export_rdev(sdc1)
Mar 22 16:08:07 sysresccd kernel: [81082.737491] md: unbind<sdb1>
Mar 22 16:08:07 sysresccd kernel: [81082.740149] md: export_rdev(sdb1)
Mar 22 16:08:07 sysresccd kernel: [81082.740160] md: unbind<sda1>
Mar 22 16:08:07 sysresccd kernel: [81082.740175] md: export_rdev(sda1)


Various sources indicate the following syntax to build a windows raid a=
rray:

"mdadm --build -l 0 -n <number of devices> -c 64 <md name>
<space-separated device list>"

with one source=B9 mentioning a successful build from scratch (which
unfortunately I cannot do right now)

in the linux source tree, Documentation/ldm.txt looks quite old and
also some aging files are present in linux-ntfs sourceforge download
area.

What is the official ldm status under current linux kernel?
And if raid 0 is supported, what am I doing wrong?
Thank you.
___
=B9 http://kubuntuforums.net/forums/index.php?topic=3D3103856.0
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
