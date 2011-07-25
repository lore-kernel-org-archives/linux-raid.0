From: Matthew Tice <mjtice@gmail.com>
Subject: Re: Problems with raid after reboot.
Date: Mon, 25 Jul 2011 15:55:02 -0600
Message-ID: <CA+taBv_UOKXk0Noh3T_=WYQhb+qCWy33ZmEHCnEKF3uwn7c_uQ@mail.gmail.com>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
	<CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
	<CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
	<20110725212107.GA6422@cthulhu.home.robinhill.me.uk>
	<CA+taBv8+KZguxmSTe7huntdMrnvANK3VRJKLpwZjXbymJ36-Ag@mail.gmail.com>
	<CA+taBv-sqRpCQ=AzEbXGAA2JZL3F6p8wPHTsnNnJjaqyHJEnmQ@mail.gmail.com>
	<CA+taBv-TWPpnJCxWeK7D-CCG2Xi87Wj3QJ_duU1ozdowzDncqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+taBv-TWPpnJCxWeK7D-CCG2Xi87Wj3QJ_duU1ozdowzDncqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 25, 2011 at 3:42 PM, Matthew Tice <mjtice@gmail.com> wrote:
> On Mon, Jul 25, 2011 at 3:33 PM, Matthew Tice <mjtice@gmail.com> wrot=
e:
>> On Mon, Jul 25, 2011 at 3:30 PM, Matthew Tice <mjtice@gmail.com> wro=
te:
>>> On Mon, Jul 25, 2011 at 3:21 PM, Robin Hill <robin@robinhill.me.uk>=
 wrote:
>>>> On Mon Jul 25, 2011 at 03:04:34PM -0600, Matthew Tice wrote:
>>>>
>>>>> Well things are a lot different now - I'm unable to start the arr=
ay
>>>>> successfully. =C2=A0I removed an older non-relevant drive that wa=
s giving
>>>>> me smart errors - when I rebooted the drive assignments shifted (=
not
>>>>> sure this really matters, though).
>>>>>
>>>>> Now when I try to start the array I get:
>>>>>
>>>>> # mdadm -A -f /dev/md0
>>>>> mdadm: no devices found for /dev/md0
>>>>>
>>>>> I can nudge it slightly with auto-detect:
>>>>>
>>>>> # mdadm --auto-detect
>>>>>
>>>>> Then I try to assemble the array with:
>>>>>
>>>>> # mdadm -A -f /dev/md0 /dev/sd[bcde]
>>>>> mdadm: cannot open device /dev/sde: Device or resource busy
>>>>> mdadm: /dev/sde has no superblock - assembly aborted
>>>>>
>>>> <- SNIP ->
>>>>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sde: [8:64] MD raid5 (non=
e/4) 931.51g md_d0 inactive spare
>>>> <- SNIP ->
>>>>>
>>>>> I've looked but I'm unable to find where the drive is in use.
>>>>
>>>> lsdrv shows that it's in use in array md_d0 - presumably this is a
>>>> part-assembled array (possibly auto-assembled by the kernel). Try
>>>> stopping that first, then doing the "mdadm -A -f /dev/md0 /dev/sd[=
bcde]"
>>>>
>>>
>>> Nice catch, thanks, Robin.
>>>
>>> I stopped /dev/md_d0 then started the array on /dev/md0
>>>
>>> # mdadm -A -f /dev/md0 /dev/sd[bcde]
>>> mdadm: /dev/md0 has been started with 3 drives (out of 4).
>>>
>>> It's only seeing the three drives. =C2=A0I did an fsck on it just i=
n case
>>> but it failed:
>>>
>>> # fsck -n /dev/md0
>>> fsck from util-linux-ng 2.17.2
>>> e2fsck 1.41.12 (17-May-2010)
>>> Superblock has an invalid journal (inode 8).
>>> Clear? no
>>>
>>> fsck.ext4: Illegal inode number while checking ext3 journal for /de=
v/md0
>>>
>>> Looks like /dev/sde is missing (as also noted above):
>>>
>>> # mdadm --detail /dev/md0
>>> /dev/md0:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90
>>> =C2=A0Creation Time : Sat Mar 12 21:22:34 2011
>>> =C2=A0 =C2=A0 Raid Level : raid5
>>> =C2=A0 =C2=A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>>> =C2=A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>>> =C2=A0 Raid Devices : 4
>>> =C2=A0Total Devices : 3
>>> Preferred Minor : 0
>>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>>
>>> =C2=A0 =C2=A0Update Time : Mon Jul 25 14:08:30 2011
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, degraded
>>> =C2=A0Active Devices : 3
>>> Working Devices : 3
>>> =C2=A0Failed Devices : 0
>>> =C2=A0Spare Devices : 0
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : daf06d5a:b80528b1:2e29483=
d:f114274d (local to host storage)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.5593
>>>
>>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Sta=
te
>>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0removed
>>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
48 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd
>>> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
32 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc
>>> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
16 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb
>>>
>>
>> One other strange thing I just noticed - /dev/sde keeps getting adde=
d
>> back into /dev/md_d0 (after I start the array on /dev/md0)
>>
>> # /usr/local/bin/lsdrv
>> **Warning** The following utility(ies) failed to execute:
>> =C2=A0pvs
>> =C2=A0lvs
>> Some information may be missing.
>>
>> PCI [ata_piix] 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7
>> Family) IDE Controller (rev 01)
>> =C2=A0=E2=94=9C=E2=94=80scsi 0:0:0:0 LITE-ON COMBO SOHC-4836K {20060=
61700044437}
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sr0: [11:0] Empty/Unknown 1.=
00g
>> =C2=A0=E2=94=94=E2=94=80scsi 1:x:x:x [Empty]
>> PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation N10/ICH7
>> Family SATA IDE Controller (rev 01)
>> =C2=A0=E2=94=9C=E2=94=80scsi 2:x:x:x [Empty]
>> =C2=A0=E2=94=94=E2=94=80scsi 3:0:0:0 ATA HDS728080PLA380 {PFDB20S4SN=
LT6J}
>> =C2=A0 =C2=A0=E2=94=94=E2=94=80sda: [8:0] Partitioned (dos) 76.69g
>> =C2=A0 =C2=A0 =C2=A0 =E2=94=9C=E2=94=80sda1: [8:1] (ext4) 75.23g {96=
0433b3-af56-41bd-bb9a-d0a0fb5ffb45}
>> =C2=A0 =C2=A0 =C2=A0 =E2=94=82 =C2=A0=E2=94=94=E2=94=80Mounted as
>> /dev/disk/by-uuid/960433b3-af56-41bd-bb9a-d0a0fb5ffb45 @ /
>> =C2=A0 =C2=A0 =C2=A0 =E2=94=9C=E2=94=80sda2: [8:2] Partitioned (dos)=
 1.00k
>> =C2=A0 =C2=A0 =C2=A0 =E2=94=94=E2=94=80sda5: [8:5] (swap) 1.46g {10c=
3b226-16d4-44ea-ad1e-6296bb92969d}
>> PCI [sata_sil24] 04:00.0 RAID bus controller: Silicon Image, Inc. Si=
I
>> 3132 Serial ATA Raid II Controller (rev 01)
>> =C2=A0=E2=94=9C=E2=94=80scsi 4:0:0:0 ATA WDC WD7500AADS-0 {WD-WCAV59=
574584}
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sdb: [8:16] MD raid5 (3/4) 6=
98.64g md0 clean in_sync
>> {daf06d5a-b805-28b1-2e29-483df114274d}
>> =C2=A0=E2=94=82 =C2=A0 =C2=A0 =E2=94=94=E2=94=80md0: [9:0] (ext3) 2.=
05t {a9a38e8e-d54d-407d-a786-31410ad6e17d}
>> =C2=A0=E2=94=9C=E2=94=80scsi 4:1:0:0 ATA WDC WD7500AADS-0 {WD-WCAV59=
459025}
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sdc: [8:32] MD raid5 (2/4) 6=
98.64g md0 clean in_sync
>> {daf06d5a-b805-28b1-2e29-483df114274d}
>> =C2=A0=E2=94=9C=E2=94=80scsi 4:2:0:0 ATA Hitachi HDS72101 {JP9911HZ1=
SKHNU}
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sdd: [8:48] MD raid5 (1/4) 9=
31.51g md0 clean in_sync
>> {daf06d5a-b805-28b1-2e29-483df114274d}
>> =C2=A0=E2=94=9C=E2=94=80scsi 4:3:0:0 ATA Hitachi HDS72101 {JP9960HZ1=
VK96U}
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sde: [8:64] MD raid5 (none/4=
) 931.51g md_d0 inactive spare
>> {daf06d5a-b805-28b1-2e29-483df114274d}
>> =C2=A0=E2=94=82 =C2=A0 =C2=A0 =E2=94=94=E2=94=80md_d0: [254:0] Empty=
/Unknown 0.00k
>> =C2=A0=E2=94=94=E2=94=80scsi 7:x:x:x [Empty]
>>
>
> Here is something interesting from syslog:
>
> 1. I stop /dev/md_d0
> Jul 25 15:38:56 localhost kernel: [ 4272.658244] md: md_d0 stopped.
> Jul 25 15:38:56 localhost kernel: [ 4272.658258] md: unbind<sde>
> Jul 25 15:38:56 localhost kernel: [ 4272.658271] md: export_rdev(sde)
>
> 2. I assemble /dev/md0 with:
> # mdadm -A /dev/md0 /dev/sd[bcde]
> mdadm: /dev/md0 has been started with 3 drives (out of 4).
>
> Jul 25 15:41:33 localhost kernel: [ 4429.537035] md: md0 stopped.
> Jul 25 15:41:33 localhost kernel: [ 4429.545447] md: bind<sde>
> Jul 25 15:41:33 localhost kernel: [ 4429.545644] md: bind<sdc>
> Jul 25 15:41:33 localhost kernel: [ 4429.545810] md: bind<sdb>
> Jul 25 15:41:33 localhost kernel: [ 4429.546827] md: bind<sdd>
> Jul 25 15:41:33 localhost kernel: [ 4429.546876] md: kicking non-fres=
h
> sde from array!
> Jul 25 15:41:33 localhost kernel: [ 4429.546883] md: unbind<sde>
> Jul 25 15:41:33 localhost kernel: [ 4429.546890] md: export_rdev(sde)
> Jul 25 15:41:33 localhost kernel: [ 4429.565035] md/raid:md0: device
> sdd operational as raid disk 1
> Jul 25 15:41:33 localhost kernel: [ 4429.565041] md/raid:md0: device
> sdb operational as raid disk 3
> Jul 25 15:41:33 localhost kernel: [ 4429.565045] md/raid:md0: device
> sdc operational as raid disk 2
> Jul 25 15:41:33 localhost kernel: [ 4429.565631] md/raid:md0: allocat=
ed 4222kB
> Jul 25 15:41:33 localhost kernel: [ 4429.573438] md/raid:md0: raid
> level 5 active with 3 out of 4 devices, algorithm 2
> Jul 25 15:41:33 localhost kernel: [ 4429.574754] RAID conf printout:
> Jul 25 15:41:33 localhost kernel: [ 4429.574757] =C2=A0--- level:5 rd=
:4 wd:3
> Jul 25 15:41:33 localhost kernel: [ 4429.574761] =C2=A0disk 1, o:1, d=
ev:sdd
> Jul 25 15:41:33 localhost kernel: [ 4429.574765] =C2=A0disk 2, o:1, d=
ev:sdc
> Jul 25 15:41:33 localhost kernel: [ 4429.574768] =C2=A0disk 3, o:1, d=
ev:sdb
> Jul 25 15:41:33 localhost kernel: [ 4429.574863] md0: detected
> capacity change from 0 to 2250468753408
> Jul 25 15:41:33 localhost kernel: [ 4429.575092] =C2=A0md0: unknown p=
artition table
> Jul 25 15:41:33 localhost kernel: [ 4429.626140] md: bind<sde>
>
> So /dev/sde is "non-fresh" and has an unknown partition table.
>

Okay, I was able to add it back in by stopping this /dev/md_d0 and then=
:
# mdadm /dev/md0 --add /dev/sde
mdadm: re-added /dev/sde

So now it's syncing:
# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jul 25 15:52:29 2011
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 0% complete

           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
         Events : 0.5599

    Number   Major   Minor   RaidDevice State
       4       8       64        0      spare rebuilding   /dev/sde
       1       8       48        1      active sync   /dev/sdd
       2       8       32        2      active sync   /dev/sdc
       3       8       16        3      active sync   /dev/sdb

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sde[4] sdd[1] sdb[3] sdc[2]
      2197723392 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
      [>....................]  recovery =3D  0.4% (3470464/732574464)
finish=3D365.0min speed=3D33284K/sec

unused devices: <none>


However, it's still failing an fsck - so does order matter when I
re-assemble the array?  I see conflicting answers online.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
