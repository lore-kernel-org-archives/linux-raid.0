From: Matthew Tice <mjtice@gmail.com>
Subject: Re: Problems with raid after reboot.
Date: Mon, 25 Jul 2011 15:04:34 -0600
Message-ID: <CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
	<CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 22, 2011 at 9:12 PM, Matthew Tice <mjtice@gmail.com> wrote:
> On Wed, Jul 20, 2011 at 3:24 PM, Matthew Tice <mjtice@gmail.com> wrot=
e:
>> Hello,
>>
>> I had to shutdown my machine for moving - when I powered it back up =
my
>> raid-5 array is in a bad state:
>>
>> # mdadm -A -s
>> mdadm: no devices found for /dev/md0
>> mdadm: /dev/md/0 assembled from 2 drives - not enough to start the a=
rray.
>>
>> I ended up forcing the assembly:
>>
>> # mdadm -A -s -f
>> mdadm: no devices found for /dev/md0
>> mdadm: forcing event count in /dev/sde(1) from 177 upto 181
>> mdadm: clearing FAULTY flag for device 1 in /dev/md/0 for /dev/sde
>> mdadm: /dev/md/0 has been started with 3 drives (out of 4).
>>
>> Looking at the detailed output the missing disk (/dev/sdc) is "remov=
ed":
>>
>>
>> # mdadm --detail /dev/md0
>> /dev/md0:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90
>> =C2=A0Creation Time : Sat Mar 12 21:22:34 2011
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0 =C2=A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>> =C2=A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 3
>> Preferred Minor : 0
>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>
>> =C2=A0 =C2=A0Update Time : Tue Jul 19 20:44:45 2011
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, degraded
>> =C2=A0Active Devices : 3
>> Working Devices : 3
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 64K
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : daf06d5a:b80528b1:2e29483d=
:f114274d (local to host storage)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.181
>>
>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Stat=
e
>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 8=
0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdf
>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 6=
4 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sde
>> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 4=
8 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdd
>> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0removed
>>
>>
>> I can examine the disk but I'm unable to add it (I don't recall if i=
t
>> needs to be removed first or not):
>>
>> # mdadm --examine /dev/sdc
>> /dev/sdc:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : daf06d5a:b80528b1:2e29483d=
:f114274d (local to host storage)
>> =C2=A0Creation Time : Sat Mar 12 21:22:34 2011
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>> =C2=A0 =C2=A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>> =C2=A0 Raid Devices : 4
>> =C2=A0Total Devices : 3
>> Preferred Minor : 0
>>
>> =C2=A0 =C2=A0Update Time : Tue Jul 19 20:44:45 2011
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 3
>> Working Devices : 3
>> =C2=A0Failed Devices : 1
>> =C2=A0Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 Checksum : 22ac1229 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 181
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 64K
>>
>> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevi=
ce State
>> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 32 =
=C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /de=
v/sdc
>>
>> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 80 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdf
>> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty remove=
d
>> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 48 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdd
>> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 32 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sdc
>>
>> # mdadm --add /dev/md0 /dev/sdc
>> mdadm: Cannot open /dev/sdc: Device or resource busy
>>
>> So a couple questions.
>>
>> 1. Any thoughts on what would cause this? =C2=A0I seem to have bad l=
uck
>> with my raid arrays whenever I reboot.
>> 2. How do I fix? =C2=A0Everything *seems* to be as it should be . . =
=2E
>>
>> Here is the mdadm.conf:
>>
>> # cat /etc/mdadm/mdadm.conf =C2=A0| grep -v ^#
>>
>> DEVICE partitions
>> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>> HOMEHOST <system>
>> MAILADDR root
>> ARRAY /dev/md0 level=3Draid5 num-devices=3D4
>> UUID=3D11c1cdd8:60ec9a90:2e29483d:f114274d
>>
>> Any help is greatly appreciated.
>>
>> Matt
>>
>
> One thing I just noticed that seems kind of strange is that when I do
> the --examine /dev/sdc it shows the drive in the list and another is
> listed as faulty? =C2=A0Am I reading that right?
>
>
> # mdadm --examine /dev/sdc
> /dev/sdc:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : a92b4efc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : daf06d5a:b80528b1:2e29483d:=
f114274d (local to host storage)
> =C2=A0Creation Time : Sat Mar 12 21:22:34 2011
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
> =C2=A0 =C2=A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
> =C2=A0 Raid Devices : 4
> =C2=A0Total Devices : 3
> Preferred Minor : 0
>
> =C2=A0 =C2=A0Update Time : Tue Jul 19 20:44:45 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 3
> Working Devices : 3
> =C2=A0Failed Devices : 1
> =C2=A0Spare Devices : 0
> =C2=A0 =C2=A0 =C2=A0 Checksum : 22ac1229 - correct
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 181
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 64K
>
> =C2=A0 =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevic=
e State
> this =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 32 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc
>
> =C2=A0 0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
80 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdf
> =C2=A0 1 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0faulty removed
> =C2=A0 2 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
48 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd
> =C2=A0 3 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
32 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc
>

Well things are a lot different now - I'm unable to start the array
successfully.  I removed an older non-relevant drive that was giving
me smart errors - when I rebooted the drive assignments shifted (not
sure this really matters, though).

Now when I try to start the array I get:

# mdadm -A -f /dev/md0
mdadm: no devices found for /dev/md0

I can nudge it slightly with auto-detect:

# mdadm --auto-detect

Then I try to assemble the array with:

# mdadm -A -f /dev/md0 /dev/sd[bcde]
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has no superblock - assembly aborted

I ran Phil's lsdrv script (and an mdadm --examine /dev/sd[bcde] so
hopefully it can help:

# lsdrv

PCI [ata_piix] 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7
=46amily) IDE Controller (rev 01)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 LITE-ON COMBO SOHC-4836K {2006061700044=
437}
 =E2=94=82  =E2=94=94=E2=94=80sr0: [11:0] Empty/Unknown 1.00g
 =E2=94=94=E2=94=80scsi 1:x:x:x [Empty]
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation N10/ICH7
=46amily SATA IDE Controller (rev 01)
 =E2=94=9C=E2=94=80scsi 2:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 3:0:0:0 ATA HDS728080PLA380 {PFDB20S4SNLT6J}
    =E2=94=94=E2=94=80sda: [8:0] Partitioned (dos) 76.69g
       =E2=94=9C=E2=94=80sda1: [8:1] (ext4) 75.23g {960433b3-af56-41bd-=
bb9a-d0a0fb5ffb45}
       =E2=94=82  =E2=94=94=E2=94=80Mounted as
/dev/disk/by-uuid/960433b3-af56-41bd-bb9a-d0a0fb5ffb45 @ /
       =E2=94=9C=E2=94=80sda2: [8:2] Partitioned (dos) 1.00k
       =E2=94=94=E2=94=80sda5: [8:5] (swap) 1.46g {10c3b226-16d4-44ea-a=
d1e-6296bb92969d}
PCI [sata_sil24] 04:00.0 RAID bus controller: Silicon Image, Inc. SiI
3132 Serial ATA Raid II Controller (rev 01)
 =E2=94=9C=E2=94=80scsi 4:0:0:0 ATA WDC WD7500AADS-0 {WD-WCAV59574584}
 =E2=94=82  =E2=94=94=E2=94=80sdb: [8:16] MD raid5 (4) 698.64g inactive
{daf06d5a-b805-28b1-2e29-483df114274d}
 =E2=94=9C=E2=94=80scsi 4:1:0:0 ATA WDC WD7500AADS-0 {WD-WCAV59459025}
 =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] MD raid5 (4) 698.64g inactive
{daf06d5a-b805-28b1-2e29-483df114274d}
 =E2=94=9C=E2=94=80scsi 4:2:0:0 ATA Hitachi HDS72101 {JP9911HZ1SKHNU}
 =E2=94=82  =E2=94=94=E2=94=80sdd: [8:48] MD raid5 (4) 931.51g inactive
{daf06d5a-b805-28b1-2e29-483df114274d}
 =E2=94=9C=E2=94=80scsi 4:3:0:0 ATA Hitachi HDS72101 {JP9960HZ1VK96U}
 =E2=94=82  =E2=94=94=E2=94=80sde: [8:64] MD raid5 (none/4) 931.51g md_=
d0 inactive spare
{daf06d5a-b805-28b1-2e29-483df114274d}
 =E2=94=82     =E2=94=94=E2=94=80md_d0: [254:0] Empty/Unknown 0.00k
 =E2=94=94=E2=94=80scsi 7:x:x:x [Empty]
PCI [pata_via] 02:00.0 IDE interface: VIA Technologies, Inc. PATA IDE
Host Controller
 =E2=94=9C=E2=94=80scsi 5:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 6:x:x:x [Empty]
PCI [sata_sil24] 05:01.0 RAID bus controller: Silicon Image, Inc. SiI
3124 PCI-X Serial ATA Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 8:x:x:x [Empty]
 =E2=94=9C=E2=94=80scsi 9:x:x:x [Empty]
 =E2=94=9C=E2=94=80scsi 10:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 11:x:x:x [Empty]
Other Block Devices
 =E2=94=9C=E2=94=80ram0: [1:0] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram1: [1:1] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram2: [1:2] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram3: [1:3] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram4: [1:4] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram5: [1:5] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram6: [1:6] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram7: [1:7] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram8: [1:8] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram9: [1:9] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram10: [1:10] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram11: [1:11] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram12: [1:12] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram13: [1:13] Empty/Unknown 64.00m
 =E2=94=9C=E2=94=80ram14: [1:14] Empty/Unknown 64.00m
 =E2=94=94=E2=94=80ram15: [1:15] Empty/Unknown 64.00m


# mdadm --examine /dev/sd[bcde]

/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jul 25 14:08:30 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 22b3c880 - correct
         Events : 5593

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

   0     0       0        0        0      removed
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb
   3     3       8       64        3      active sync   /dev/sde
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jul 25 14:08:30 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 22b3c84e - correct
         Events : 5593

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       16        2      active sync   /dev/sdb

   0     0       0        0        0      removed
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb
   3     3       8       64        3      active sync   /dev/sde
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jul 25 14:08:30 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 22b3c85c - correct
         Events : 5593

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       0        0        0      removed
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb
   3     3       8       64        3      active sync   /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sun Jul 24 11:46:10 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 22b255fc - correct
         Events : 5591

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       80        0      active sync

   0     0       8       80        0      active sync
   1     1       8       64        1      active sync   /dev/sde
   2     2       8       48        2      active sync   /dev/sdd
   3     3       0        0        3      faulty removed

I've looked but I'm unable to find where the drive is in use.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
