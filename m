From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Sun, 11 Sep 2016 19:48:31 +0100
Message-ID: <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, system up and running after MB was replaced however the arrays
remain inactive.

mdadm version is:
mdadm - v3.3.4 - 3rd August 2015

Here's the output from Phil's lsdrv:

[root@lamachine ~]# ./lsdrv
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation C600/X79 series
chipset 6-Port SATA AHCI Controller (rev 06)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD5000AAKS-0 {WD-WCASZ0505379}
=E2=94=82=E2=94=94sda 465.76g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 29.30g [8:1] MD raid10,near2 (1/2) (w/ sdf2) in_syn=
c
{9af006ca-8845-bbd3-bfe7-8010bc810f04}
=E2=94=82 =E2=94=82=E2=94=94md126 29.30g [9:126] MD v0.90 raid10,near2 (2) =
clean, 64k Chunk
{9af006ca:8845bbd3:bfe78010:bc810f04}
=E2=94=82 =E2=94=82 =E2=94=82                    PV LVM2_member 28.03g used=
, 1.26g free
{cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH}
=E2=94=82 =E2=94=82 =E2=94=94VG vg_bigblackbox 29.29g 1.26g free
{VWfuwI-5v2q-w8qf-FEbc-BdGW-3mKX-pZd7hR}
=E2=94=82 =E2=94=82  =E2=94=9Cdm-2 7.81g [253:2] LV LogVol_opt ext4
{b08d7f5e-f15f-4241-804e-edccecab6003}
=E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigblackbo=
x-LogVol_opt @ /opt
=E2=94=82 =E2=94=82  =E2=94=9Cdm-0 9.77g [253:0] LV LogVol_root ext4
{4dabd6b0-b1a3-464d-8ed7-0aab93fab6c3}
=E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigblackbo=
x-LogVol_root @ /
=E2=94=82 =E2=94=82  =E2=94=9Cdm-3 1.95g [253:3] LV LogVol_tmp ext4
{f6b46363-170b-4038-83bd-2c5f9f6a1973}
=E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigblackbo=
x-LogVol_tmp @ /tmp
=E2=94=82 =E2=94=82  =E2=94=94dm-1 8.50g [253:1] LV LogVol_var ext4
{ab165c61-3d62-4c55-8639-6c2c2bf4b021}
=E2=94=82 =E2=94=82   =E2=94=94Mounted as /dev/mapper/vg_bigblackbox-LogVol=
_var @ /var
=E2=94=82 =E2=94=9Csda2 244.14g [8:2] MD raid5 (2/3) (w/ sdb2,sdf3) in_sync
{2cff15d1-e411-447b-fd5d-472103e44022}
=E2=94=82 =E2=94=82=E2=94=94md2 488.28g [9:2] MD v0.90 raid5 (3) clean, 64k=
 Chunk
{2cff15d1:e411447b:fd5d4721:03e44022}
=E2=94=82 =E2=94=82 =E2=94=82                 ext4 {e9c1c787-496f-4e8f-b62e=
-35d5b1ff8311}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md2 @ /home
=E2=94=82 =E2=94=9Csda3 1.00k [8:3] Partitioned (dos)
=E2=94=82 =E2=94=9Csda5 30.00g [8:5] MD raid0 (2/3) (w/ sdb5,sdf5) in_sync
'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
=E2=94=82 =E2=94=82=E2=94=94md127 90.00g [9:127] MD v1.2 raid0 (3) clean, 5=
12k Chunk, None
(None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
=E2=94=82 =E2=94=82 =E2=94=82                    PV LVM2_member 86.00g used=
, 3.99g free
{VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
=E2=94=82 =E2=94=82 =E2=94=94VG libvirt_lvm 89.99g 3.99g free {t8GQck-f2Eu-=
iD2V-fnJQ-kBm6-QyKw-dR31PB}
=E2=94=82 =E2=94=82  =E2=94=9Cdm-6 8.00g [253:6] LV builder2 Partitioned (d=
os)
=E2=94=82 =E2=94=82  =E2=94=9Cdm-7 8.00g [253:7] LV builder3 Partitioned (d=
os)
=E2=94=82 =E2=94=82  =E2=94=9Cdm-9 8.00g [253:9] LV builder5.3 Partitioned =
(dos)
=E2=94=82 =E2=94=82  =E2=94=9Cdm-8 8.00g [253:8] LV builder5.6 Partitioned =
(dos)
=E2=94=82 =E2=94=82  =E2=94=9Cdm-5 8.00g [253:5] LV centos_updt Partitioned=
 (dos)
=E2=94=82 =E2=94=82  =E2=94=9Cdm-10 16.00g [253:10] LV f22lvm Partitioned (=
dos)
=E2=94=82 =E2=94=82  =E2=94=94dm-4 30.00g [253:4] LV win7 Partitioned (dos)
=E2=94=82 =E2=94=94sda6 3.39g [8:6] Empty/Unknown
=E2=94=9Cscsi 1:0:0:0 ATA      WDC WD5000AAKS-0 {WD-WCASY7694185}
=E2=94=82=E2=94=94sdb 465.76g [8:16] Partitioned (dos)
=E2=94=82 =E2=94=9Csdb2 244.14g [8:18] MD raid5 (1/3) (w/ sda2,sdf3) in_syn=
c
{2cff15d1-e411-447b-fd5d-472103e44022}
=E2=94=82 =E2=94=82=E2=94=94md2 488.28g [9:2] MD v0.90 raid5 (3) clean, 64k=
 Chunk
{2cff15d1:e411447b:fd5d4721:03e44022}
=E2=94=82 =E2=94=82                   ext4 {e9c1c787-496f-4e8f-b62e-35d5b1f=
f8311}
=E2=94=82 =E2=94=9Csdb3 7.81g [8:19] swap {9194f492-881a-4fc3-ac09-ca4e1cc2=
985a}
=E2=94=82 =E2=94=9Csdb4 1.00k [8:20] Partitioned (dos)
=E2=94=82 =E2=94=9Csdb5 30.00g [8:21] MD raid0 (1/3) (w/ sda5,sdf5) in_sync
'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
=E2=94=82 =E2=94=82=E2=94=94md127 90.00g [9:127] MD v1.2 raid0 (3) clean, 5=
12k Chunk, None
(None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
=E2=94=82 =E2=94=82                      PV LVM2_member 86.00g used, 3.99g =
free
{VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
=E2=94=82 =E2=94=94sdb6 3.39g [8:22] Empty/Unknown
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=94scsi 5:x:x:x [Empty]
PCI [ahci] 0a:00.0 SATA controller: Marvell Technology Group Ltd.
88SE9230 PCIe SATA 6Gb/s Controller (rev 11)
=E2=94=9Cscsi 6:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4NCWT13RF}
=E2=94=82=E2=94=94sdc 2.73t [8:32] Partitioned (PMBR)
=E2=94=9Cscsi 7:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4NPRDD6D7}
=E2=94=82=E2=94=94sdd 2.73t [8:48] Partitioned (gpt)
=E2=94=82 =E2=94=9Csdd1 2.00t [8:49] MD  (none/) spare 'lamachine:128'
{f2372cb9-d381-6fd6-ce86-d826882ec82e}
=E2=94=82 =E2=94=82=E2=94=94md128 0.00k [9:128] MD v1.2  () inactive, None =
(None) None
{f2372cb9:d3816fd6:ce86d826:882ec82e}
=E2=94=82 =E2=94=82                     Empty/Unknown
=E2=94=82 =E2=94=94sdd2 500.00g [8:50] MD  (none/) spare 'lamachine:129'
{895dae98-d1a4-96de-4f59-0b8bcb8ac12a}
=E2=94=82  =E2=94=94md129 0.00k [9:129] MD v1.2  () inactive, None (None) N=
one
{895dae98:d1a496de:4f590b8b:cb8ac12a}
=E2=94=82                       Empty/Unknown
=E2=94=9Cscsi 8:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4N1294906}
=E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (PMBR)
=E2=94=9Cscsi 9:0:0:0 ATA      WDC WD5000AAKS-0 {WD-WMAWF0085724}
=E2=94=82=E2=94=94sdf 465.76g [8:80] Partitioned (dos)
=E2=94=82 =E2=94=9Csdf1 199.00m [8:81] ext4 {4e51f903-37ca-4479-9197-fac7b2=
280557}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdf1 @ /boot
=E2=94=82 =E2=94=9Csdf2 29.30g [8:82] MD raid10,near2 (0/2) (w/ sda1) in_sy=
nc
{9af006ca-8845-bbd3-bfe7-8010bc810f04}
=E2=94=82 =E2=94=82=E2=94=94md126 29.30g [9:126] MD v0.90 raid10,near2 (2) =
clean, 64k Chunk
{9af006ca:8845bbd3:bfe78010:bc810f04}
=E2=94=82 =E2=94=82                      PV LVM2_member 28.03g used, 1.26g =
free
{cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH}
=E2=94=82 =E2=94=9Csdf3 244.14g [8:83] MD raid5 (0/3) (w/ sda2,sdb2) in_syn=
c
{2cff15d1-e411-447b-fd5d-472103e44022}
=E2=94=82 =E2=94=82=E2=94=94md2 488.28g [9:2] MD v0.90 raid5 (3) clean, 64k=
 Chunk
{2cff15d1:e411447b:fd5d4721:03e44022}
=E2=94=82 =E2=94=82                   ext4 {e9c1c787-496f-4e8f-b62e-35d5b1f=
f8311}
=E2=94=82 =E2=94=9Csdf4 1.00k [8:84] Partitioned (dos)
=E2=94=82 =E2=94=9Csdf5 30.00g [8:85] MD raid0 (0/3) (w/ sda5,sdb5) in_sync
'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
=E2=94=82 =E2=94=82=E2=94=94md127 90.00g [9:127] MD v1.2 raid0 (3) clean, 5=
12k Chunk, None
(None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
=E2=94=82 =E2=94=82                      PV LVM2_member 86.00g used, 3.99g =
free
{VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
=E2=94=82 =E2=94=94sdf6 3.39g [8:86] Empty/Unknown
=E2=94=9Cscsi 10:x:x:x [Empty]
=E2=94=9Cscsi 11:x:x:x [Empty]
=E2=94=94scsi 12:x:x:x [Empty]
PCI [isci] 05:00.0 Serial Attached SCSI controller: Intel Corporation
C602 chipset 4-Port SATA Storage Control Unit (rev 06)
=E2=94=94scsi 14:x:x:x [Empty]
[root@lamachine ~]#

Thanks in advance for any recommendations on what steps to take in
order to bring these arrays back online.

Regards,

Daniel


On 2 August 2016 at 11:45, Daniel Sanabria <sanabria.d@gmail.com> wrote:
> Thanks very much for the response Wol.
>
> It looks like the PSU is dead (server automatically powers off a few
> seconds after power on).
>
> I'm planning to order a PSU replacement to resume troubleshooting so
> please bear with me;  maybe the PSU was degraded and couldn't power
> some of drives?
>
> Cheers,
>
> Daniel
>
> On 2 August 2016 at 11:17, Wols Lists <antlists@youngman.org.uk> wrote:
>> Just a quick first response. I see md128 and md129 are both down, and
>> are both listed as one drive, raid0. Bit odd, that ...
>>
>> What version of mdadm are you using? One of them had a bug (3.2.3 era?)
>> that would split an array in two. Is it possible that you should have
>> one raid0 array with sdf1 and sdf2? But that's a bit of a weird setup...
>>
>> I notice also that md126 is raid10 across two drives. That's odd, too.
>>
>> How much do you know about what the setup should be, and why it was set
>> up that way?
>>
>> Download lspci by Phil Turmel (it requires python2.7, if your machine is
>> python3 a quick fix to the shebang at the start should get it to work).
>> Post the output from that here.
>>
>> Cheers,
>> Wol
>>
>> On 02/08/16 08:36, Daniel Sanabria wrote:
>>> Hi All,
>>>
>>> I have a box that I believe was not powered down correctly and after
>>> transporting it to a different location it doesn't boot anymore
>>> stopping at BIOS check "Verifying DMI Pool Data".
>>>
>>> The box have 6 drives and after instructing the BIOS to boot from the
>>> first drive I managed to boot the OS (Fedora 23) after commenting out
>>> 2 /etc/fstab entries , output for "uname -a; cat /etc/fstab" follows:
>>>
>>> [root@lamachine ~]# uname -a; cat /etc/fstab
>>> Linux lamachine 4.3.3-303.fc23.x86_64 #1 SMP Tue Jan 19 18:31:55 UTC
>>> 2016 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> #
>>> # /etc/fstab
>>> # Created by anaconda on Tue Mar 24 19:31:21 2015
>>> #
>>> # Accessible filesystems, by reference, are maintained under '/dev/disk=
'
>>> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more =
info
>>> #
>>> /dev/mapper/vg_bigblackbox-LogVol_root /                       ext4
>>> defaults        1 1
>>> UUID=3D4e51f903-37ca-4479-9197-fac7b2280557 /boot                   ext=
4
>>>    defaults        1 2
>>> /dev/mapper/vg_bigblackbox-LogVol_opt /opt                    ext4
>>> defaults        1 2
>>> /dev/mapper/vg_bigblackbox-LogVol_tmp /tmp                    ext4
>>> defaults        1 2
>>> /dev/mapper/vg_bigblackbox-LogVol_var /var                    ext4
>>> defaults        1 2
>>> UUID=3D9194f492-881a-4fc3-ac09-ca4e1cc2985a swap                    swa=
p
>>>    defaults        0 0
>>> /dev/md2 /home          ext4    defaults        1 2
>>> #/dev/vg_media/lv_media  /mnt/media      ext4    defaults        1 2
>>> #/dev/vg_virt_dir/lv_virt_dir1 /mnt/guest_images/ ext4 defaults 1 2
>>> [root@lamachine ~]#
>>>
>>> When checking mdstat I can see that 2 of the arrays are showing up as
>>> inactive, but not sure how to safely activate these so looking for
>>> some knowledgeable advice on how to proceed here.
>>>
>>> Thanks in advance,
>>>
>>> Daniel
>>>
>>> Below some more relevant outputs:
>>>
>>> [root@lamachine ~]# cat /proc/mdstat
>>> Personalities : [raid10] [raid6] [raid5] [raid4] [raid0]
>>> md127 : active raid0 sda5[0] sdc5[2] sdb5[1]
>>>       94367232 blocks super 1.2 512k chunks
>>>
>>> md2 : active raid5 sda3[0] sdc2[2] sdb2[1]
>>>       511999872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>>
>>> md128 : inactive sdf1[3](S)
>>>       2147352576 blocks super 1.2
>>>
>>> md129 : inactive sdf2[2](S)
>>>       524156928 blocks super 1.2
>>>
>>> md126 : active raid10 sda2[0] sdc1[1]
>>>       30719936 blocks 2 near-copies [2/2] [UU]
>>>
>>> unused devices: <none>
>>> [root@lamachine ~]# cat /etc/mdadm.conf
>>> # mdadm.conf written out by anaconda
>>> MAILADDR root
>>> AUTO +imsm +1.x -all
>>> ARRAY /dev/md2 level=3Draid5 num-devices=3D3
>>> UUID=3D2cff15d1:e411447b:fd5d4721:03e44022
>>> ARRAY /dev/md126 level=3Draid10 num-devices=3D2
>>> UUID=3D9af006ca:8845bbd3:bfe78010:bc810f04
>>> ARRAY /dev/md127 level=3Draid0 num-devices=3D3
>>> UUID=3Dacd5374f:72628c93:6a906c4b:5f675ce5
>>> ARRAY /dev/md128 metadata=3D1.2 spares=3D1 name=3Dlamachine:128
>>> UUID=3Df2372cb9:d3816fd6:ce86d826:882ec82e
>>> ARRAY /dev/md129 metadata=3D1.2 name=3Dlamachine:129
>>> UUID=3D895dae98:d1a496de:4f590b8b:cb8ac12a
>>> [root@lamachine ~]# mdadm --detail /dev/md1*
>>> /dev/md126:
>>>         Version : 0.90
>>>   Creation Time : Thu Dec  3 22:12:12 2009
>>>      Raid Level : raid10
>>>      Array Size : 30719936 (29.30 GiB 31.46 GB)
>>>   Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
>>>    Raid Devices : 2
>>>   Total Devices : 2
>>> Preferred Minor : 126
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Tue Aug  2 07:46:39 2016
>>>           State : clean
>>>  Active Devices : 2
>>> Working Devices : 2
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>          Layout : near=3D2
>>>      Chunk Size : 64K
>>>
>>>            UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
>>>          Events : 0.264152
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8        2        0      active sync set-A   /dev/sda2
>>>        1       8       33        1      active sync set-B   /dev/sdc1
>>> /dev/md127:
>>>         Version : 1.2
>>>   Creation Time : Tue Jul 26 19:00:28 2011
>>>      Raid Level : raid0
>>>      Array Size : 94367232 (90.00 GiB 96.63 GB)
>>>    Raid Devices : 3
>>>   Total Devices : 3
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Tue Jul 26 19:00:28 2011
>>>           State : clean
>>>  Active Devices : 3
>>> Working Devices : 3
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>      Chunk Size : 512K
>>>
>>>            Name : reading.homeunix.com:3
>>>            UUID : acd5374f:72628c93:6a906c4b:5f675ce5
>>>          Events : 0
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8        5        0      active sync   /dev/sda5
>>>        1       8       21        1      active sync   /dev/sdb5
>>>        2       8       37        2      active sync   /dev/sdc5
>>> /dev/md128:
>>>         Version : 1.2
>>>      Raid Level : raid0
>>>   Total Devices : 1
>>>     Persistence : Superblock is persistent
>>>
>>>           State : inactive
>>>
>>>            Name : lamachine:128  (local to host lamachine)
>>>            UUID : f2372cb9:d3816fd6:ce86d826:882ec82e
>>>          Events : 4154
>>>
>>>     Number   Major   Minor   RaidDevice
>>>
>>>        -       8       81        -        /dev/sdf1
>>> /dev/md129:
>>>         Version : 1.2
>>>      Raid Level : raid0
>>>   Total Devices : 1
>>>     Persistence : Superblock is persistent
>>>
>>>           State : inactive
>>>
>>>            Name : lamachine:129  (local to host lamachine)
>>>            UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
>>>          Events : 0
>>>
>>>     Number   Major   Minor   RaidDevice
>>>
>>>        -       8       82        -        /dev/sdf2
>>> [root@lamachine ~]# mdadm --detail /dev/md2
>>> /dev/md2:
>>>         Version : 0.90
>>>   Creation Time : Mon Feb 11 07:54:36 2013
>>>      Raid Level : raid5
>>>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>>>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>>>    Raid Devices : 3
>>>   Total Devices : 3
>>> Preferred Minor : 2
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Mon Aug  1 20:24:23 2016
>>>           State : clean
>>>  Active Devices : 3
>>> Working Devices : 3
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 64K
>>>
>>>            UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host la=
machine)
>>>          Events : 0.611
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8        3        0      active sync   /dev/sda3
>>>        1       8       18        1      active sync   /dev/sdb2
>>>        2       8       34        2      active sync   /dev/sdc2
>>> [root@lamachine ~]#
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
