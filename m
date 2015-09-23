From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Unable to assemble RAID6 after Ubuntu>Arch switch
Date: Wed, 23 Sep 2015 19:35:07 +0100
Message-ID: <CADNH=7E796sv+A4PDb2n=EJomAR8KPRoGt-=+52BYfrELBFZDg@mail.gmail.com>
References: <CADNH=7Hr6HXVPQP6-V8Jkr9aSwqHojoWApjA7ZKnQOPL0inUYw@mail.gmail.com>
 <CAETWcfsw2M3JkNmE3M3nsr0_M4N86ta+kaRo62OgK+Ft0J5iiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAETWcfsw2M3JkNmE3M3nsr0_M4N86ta+kaRo62OgK+Ft0J5iiw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Alexander,

I didn't try to grow the array or anything, just swapped out the OS.
When I boot back into Ubuntu it assembles fine.

This is from within Ubuntu (I did a mdadm --assemble --scan using
mdadm - v3.3.2-7-g21dc471 - 03th November 2014)

mdadm -D on RAID6
/dev/md0:
        Version : 1.2
  Creation Time : Thu Nov 20 23:52:58 2014
     Raid Level : raid6
     Array Size : 5856046080 (5584.76 GiB 5996.59 GB)
  Used Dev Size : 1952015360 (1861.59 GiB 1998.86 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Sep 20 19:47:50 2015
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : ion:0  (local to host ion)
           UUID : 4cae433f:a40afcf5:f9aba91d:d8217b69
         Events : 59736

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8        1        4      active sync   /dev/sda1


mdadm -D on RAID0
/dev/md1:
        Version : 1.2
  Creation Time : Thu Nov 20 23:53:48 2014
     Raid Level : raid0
     Array Size : 4098048 (3.91 GiB 4.20 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Thu Nov 20 23:53:48 2014
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : ion:1  (local to host ion)
           UUID : a20b70d4:7ee17e3f:abab74f8:dadb8cd8
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       50        1      active sync   /dev/sdd2
       2       8       66        2      active sync   /dev/sde2



lsdrv from within Ubuntu
PCI [megaraid_sas] 02:0e.0 RAID bus controller: LSI Logic / Symbios
Logic MegaRAID SAS 1068
=E2=94=9Cscsi 0:2:0:0 LSI      MegaRAID 84016E  {00ede206d4a731011c50ff=
5e02b00506}
=E2=94=82=E2=94=94sda 1.82t [8:0] MD raid6 (6) inactive 'ion:md0'
{0ad2603e-e432-83ee-0218-077398e716ef}
=E2=94=82 =E2=94=94sda1 1.82t [8:1] MD raid6 (4/5) (w/ sdb1,sdc1,sdd1,s=
de1) in_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
=E2=94=82  =E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 512k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
=E2=94=82                   ext4 '6TB_RAID6' {9e3c1fbe-8228-4b38-9047-6=
6a5e2429e5f}
=E2=94=94scsi 0:2:1:0 LSI      MegaRAID 84016E  {0036936cc4270000ff50ff=
5e02b00506}
 =E2=94=94sdb 1.82t [8:16] MD raid6 (6) inactive 'ion:md0'
{0ad2603e-e432-83ee-0218-077398e716ef}
  =E2=94=94sdb1 1.82t [8:17] MD raid6 (0/5) (w/ sda1,sdc1,sdd1,sde1) in=
_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
   =E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 512k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
                    ext4 '6TB_RAID6' {9e3c1fbe-8228-4b38-9047-66a5e2429=
e5f}
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 8 Series/C220
Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
=E2=94=9Cscsi 1:0:0:0 ATA      Corsair CSSD-F60 {10326505580009990027}
=E2=94=82=E2=94=94sdf 55.90g [8:80] Partitioned (dos)
=E2=94=82 =E2=94=9Csdf1 243.00m [8:81] ext2 {b45c13c8-4246-43ee-ac2c-f9=
bb5de099f8}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdf1 @ /boot
=E2=94=82 =E2=94=9Csdf2 1.00k [8:82] Partitioned (dos)
=E2=94=82 =E2=94=94sdf5 55.66g [8:85] PV LVM2_member 55.66g used, 0 fre=
e
{zZ5Dgy-E7v8-Y1Mi-EuqG-uXUb-DseW-s7goxG}
=E2=94=82  =E2=94=94VG ion 55.66g 0 free {XSaCyP-phLN-m4IH-2cJ7-1XXw-b3=
uh-qWBl8N}
=E2=94=82   =E2=94=9Cdm-0 52.41g [252:0] LV root ext4 {63342e0d-1b4f-44=
75-9835-d3a2a6610e8f}
=E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/ion-root @ /
=E2=94=82   =E2=94=94dm-1 3.25g [252:1] LV swap_1 Empty/Unknown
=E2=94=82    =E2=94=94dm-2 3.25g [252:2] swap {0c81625d-ee9e-4a7a-9613-=
410c1cf53e72}
=E2=94=9Cscsi 2:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JR0B501861}
=E2=94=82=E2=94=94sdc 1.82t [8:32] MD raid6 (6) inactive 'ion:md0'
{0ad2603e-e432-83ee-0218-077398e716ef}
=E2=94=82 =E2=94=9Csdc1 1.82t [8:33] MD raid6 (1/5) (w/ sda1,sdb1,sdd1,=
sde1) in_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
=E2=94=82 =E2=94=82=E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 51=
2k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
=E2=94=82 =E2=94=82                 ext4 '6TB_RAID6' {9e3c1fbe-8228-4b3=
8-9047-66a5e2429e5f}
=E2=94=82 =E2=94=94sdc2 1.30g [8:34] MD raid0 (0/3) (w/ sdd2,sde2) in_s=
ync 'ion:1'
{a20b70d4-7ee1-7e3f-abab-74f8dadb8cd8}
=E2=94=82  =E2=94=94md1 3.91g [9:1] MD v1.2 raid0 (3) clean, 512k Chunk=
, None (None)
None {a20b70d4:7ee17e3f:abab74f8:dadb8cd8}
=E2=94=82                   ext4 '4GB_RAID0' {c8327dd0-9d3f-4457-a73a-c=
9c7d5a0ee3f}
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=9Cscsi 5:0:0:0 ATA      WDC WD20EARS-00J {WD-WCAWZ2036074}
=E2=94=82=E2=94=94sdd 1.82t [8:48] MD raid6 (6) inactive 'ion:md0'
{0ad2603e-e432-83ee-0218-077398e716ef}
=E2=94=82 =E2=94=9Csdd1 1.82t [8:49] MD raid6 (2/5) (w/ sda1,sdb1,sdc1,=
sde1) in_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
=E2=94=82 =E2=94=82=E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 51=
2k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
=E2=94=82 =E2=94=82                 ext4 '6TB_RAID6' {9e3c1fbe-8228-4b3=
8-9047-66a5e2429e5f}
=E2=94=82 =E2=94=94sdd2 1.30g [8:50] MD raid0 (1/3) (w/ sdc2,sde2) in_s=
ync 'ion:1'
{a20b70d4-7ee1-7e3f-abab-74f8dadb8cd8}
=E2=94=82  =E2=94=94md1 3.91g [9:1] MD v1.2 raid0 (3) clean, 512k Chunk=
, None (None)
None {a20b70d4:7ee17e3f:abab74f8:dadb8cd8}
=E2=94=82                   ext4 '4GB_RAID0' {c8327dd0-9d3f-4457-a73a-c=
9c7d5a0ee3f}
=E2=94=94scsi 6:0:0:0 ATA      ST3000DM001-1CH1 {W1F2PZGH}
 =E2=94=94sde 2.73t [8:64] Partitioned (dos)
  =E2=94=9Csde1 1.82t [8:65] MD raid6 (3/5) (w/ sda1,sdb1,sdc1,sdd1) in=
_sync
'ion:0' {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
  =E2=94=82=E2=94=94md0 5.45t [9:0] MD v1.2 raid6 (5) clean, 512k Chunk
{4cae433f:a40afcf5:f9aba91d:d8217b69}
  =E2=94=82                 ext4 '6TB_RAID6' {9e3c1fbe-8228-4b38-9047-6=
6a5e2429e5f}
  =E2=94=9Csde2 1.30g [8:66] MD raid0 (2/3) (w/ sdc2,sdd2) in_sync 'ion=
:1'
{a20b70d4-7ee1-7e3f-abab-74f8dadb8cd8}
  =E2=94=82=E2=94=94md1 3.91g [9:1] MD v1.2 raid0 (3) clean, 512k Chunk=
, None (None)
None {a20b70d4:7ee17e3f:abab74f8:dadb8cd8}
  =E2=94=82                 ext4 '4GB_RAID0' {c8327dd0-9d3f-4457-a73a-c=
9c7d5a0ee3f}
  =E2=94=94sde3 184.98g [8:67] ext4 '198GB' {e4fc427a-4ec1-48dc-8d9b-bf=
cffe06d42f}
   =E2=94=94Mounted as /dev/sde3 @ /media/198GB
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cmd127 0.00k [9:127] MD vnone  () clear, None (None) None {None=
}
=E2=94=82                    Empty/Unknown
=E2=94=9Cram0 64.00m [1:0] Empty/Unknown
=E2=94=9Cram1 64.00m [1:1] Empty/Unknown
=E2=94=9Cram2 64.00m [1:2] Empty/Unknown
=E2=94=9Cram3 64.00m [1:3] Empty/Unknown
=E2=94=9Cram4 64.00m [1:4] Empty/Unknown
=E2=94=9Cram5 64.00m [1:5] Empty/Unknown
=E2=94=9Cram6 64.00m [1:6] Empty/Unknown
=E2=94=9Cram7 64.00m [1:7] Empty/Unknown
=E2=94=9Cram8 64.00m [1:8] Empty/Unknown
=E2=94=9Cram9 64.00m [1:9] Empty/Unknown
=E2=94=9Cram10 64.00m [1:10] Empty/Unknown
=E2=94=9Cram11 64.00m [1:11] Empty/Unknown
=E2=94=9Cram12 64.00m [1:12] Empty/Unknown
=E2=94=9Cram13 64.00m [1:13] Empty/Unknown
=E2=94=9Cram14 64.00m [1:14] Empty/Unknown
=E2=94=94ram15 64.00m [1:15] Empty/Unknown


/proc/mdstat on Ubuntu
Personalities : [raid6] [raid5] [raid4] [raid0]
md0 : active raid6 sdb1[0] sda1[4] sde1[3] sdd1[2] sdc1[1]
      5856046080 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5=
] [UUUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

md1 : active raid0 sdc2[0] sde2[2] sdd2[1]
      4098048 blocks super 1.2 512k chunks

Regards,
Mathias

On 23 September 2015 at 07:24, Alexander Afonyashin
<a.afonyashin@madnet-team.ru> wrote:
> Hi,
>
> I wonder why metainfo from /dev/sdf1 thinks that there're only 5
> devices in raid6. Did you try to grow your array recently?
> Show the output of mdadm -D /dev/mdX when array is assembled on Ubunt=
u.
> Can you assemble the array with 4 disks: /dev/sd[a-d]?
>
> P.S. According to mdadm output metainfo on /dev/sdf1 claims that it's
> from another md-array (check Array UUID field). You may need to zero
> metadata on /dev/sdf1 and re-add in to existing raid6 array.
>
> Regards,
> Alexander
>
> On Wed, Sep 23, 2015 at 12:30 AM, Mathias Bur=C3=A9n <mathias.buren@g=
mail.com> wrote:
>> Hi (please reply-all)
>>
>> I've a RAID6 array (sda sdb sdd sde sdf1) that I can't assemble unde=
r
>> Arch, but it worked fine under Ubuntu. mdadm - v3.3.4 - 3rd August
>> 2015, kernel 4.1.6
>>
>> Here is the mdadm --examine for each drive:
>>
>>
>>
>> [root@ion ~]# mdadm --examine /dev/sda
>> /dev/sda:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>>            Name : ion:md0  (local to host ion)
>>   Creation Time : Tue Feb  5 17:33:27 2013
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D18446744073706818=
560 sectors
>>           State : clean
>>     Device UUID : a09fc60d:5c4a27a5:4b89bc33:29b01582
>>
>>     Update Time : Tue Nov  4 21:43:49 2014
>>        Checksum : 528563ee - correct
>>          Events : 97557
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 3
>>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
>>
>> [root@ion ~]# mdadm --examine /dev/sdb
>> /dev/sdb:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>>            Name : ion:md0  (local to host ion)
>>   Creation Time : Tue Feb  5 17:33:27 2013
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D18446744073706818=
560 sectors
>>           State : clean
>>     Device UUID : 93568b01:632395bf:7d0082a5:db9b6ff9
>>
>>     Update Time : Tue Nov  4 21:43:49 2014
>>        Checksum : 49d756ca - correct
>>          Events : 97557
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 0
>>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
>>
>>
>> [root@ion ~]# mdadm --examine /dev/sdd
>> /dev/sdd:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>>            Name : ion:md0  (local to host ion)
>>   Creation Time : Tue Feb  5 17:33:27 2013
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D1200 sectors
>>           State : clean
>>     Device UUID : 78df2586:cb5649aa:e0b6d211:d92dc224
>>
>>     Update Time : Tue Nov  4 21:43:49 2014
>>        Checksum : 50c95b7c - correct
>>          Events : 97557
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 5
>>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
>>
>> [root@ion ~]# mdadm --examine /dev/sde
>> /dev/sde:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>>            Name : ion:md0  (local to host ion)
>>   Creation Time : Tue Feb  5 17:33:27 2013
>>      Raid Level : raid6
>>    Raid Devices : 6
>>
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D1200 sectors
>>           State : clean
>>     Device UUID : 41712f8c:255b0f3e:0e345f7b:e1504e42
>>
>>     Update Time : Tue Nov  4 21:43:49 2014
>>        Checksum : 71b191d6 - correct
>>          Events : 97557
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 1
>>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =
=3D=3D replacing)
>>
>> [root@ion ~]# mdadm --examine /dev/sdf1
>> /dev/sdf1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x1
>>      Array UUID : 4cae433f:a40afcf5:f9aba91d:d8217b69
>>            Name : ion:0  (local to host ion)
>>   Creation Time : Thu Nov 20 23:52:58 2014
>>      Raid Level : raid6
>>    Raid Devices : 5
>>
>>  Avail Dev Size : 3904030720 (1861.59 GiB 1998.86 GB)
>>      Array Size : 5856046080 (5584.76 GiB 5996.59 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262056 sectors, after=3D0 sectors
>>           State : clean
>>     Device UUID : eaa0dcba:d04a7c16:6c256916:67a491ae
>>
>> Internal Bitmap : 8 sectors from superblock
>>     Update Time : Sun Sep 20 19:47:50 2015
>>   Bad Block Log : 512 entries available at offset 72 sectors
>>        Checksum : b1f6f725 - correct
>>          Events : 59736
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 3
>>    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>>
>>
>>
>>
>>
>> Here is ldrv:
>>
>> [root@ion ~]# python2 lsdrv
>> PCI [megaraid_sas] 02:0e.0 RAID bus controller: LSI Logic / Symbios
>> Logic MegaRAID SAS 1068
>> =E2=94=9Cscsi 0:2:0:0 LSI      MegaRAID 84016E  {00ede206d4a731011c5=
0ff5e02b00506}
>> =E2=94=82=E2=94=94sda 1.82t [8:0] MD raid6 (6) inactive 'ion:md0'
>> {0ad2603e-e432-83ee-0218-077398e716ef}
>> =E2=94=94scsi 0:2:1:0 LSI      MegaRAID 84016E  {0036936cc4270000ff5=
0ff5e02b00506}
>>  =E2=94=94sdb 1.82t [8:16] MD raid6 (6) inactive 'ion:md0'
>> {0ad2603e-e432-83ee-0218-077398e716ef}
>> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 8 Series/C220
>> Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
>> =E2=94=9Cscsi 1:0:0:0 ATA      INTEL SSDSA2BW16 {BTPR2062006T160DGN}
>> =E2=94=82=E2=94=94sdc 149.05g [8:32] Partitioned (dos)
>> =E2=94=82 =E2=94=9Csdc1 256.00m [8:33] ext4 'boot' {f7727d21-646d-42=
f9-844b-50591b7f8358}
>> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdc1 @ /boot
>> =E2=94=82 =E2=94=94sdc2 140.00g [8:34] PV LVM2_member 40.00g used, 1=
00.00g free
>> {KGQ5TJ-mVvL-1Ccd-CKae-1QvS-6AFn-8jFQAw}
>> =E2=94=82  =E2=94=94VG ArchVG 140.00g 100.00g free {F2vaKY-XO4m-UEih=
-f9Fh-sHgX-cRsN-SLi3Oo}
>> =E2=94=82   =E2=94=9Cdm-1 32.00g [254:1] LV root ext4 'root'
>> {82fa2951-25c8-4e36-bf36-9f4f7747ac46}
>> =E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/ArchVG-root @ /
>> =E2=94=82   =E2=94=94dm-0 8.00g [254:0] LV swap swap {0e3f4596-fa50-=
4fed-875f-f8427084d9b5}
>> =E2=94=9Cscsi 2:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JR0B501861}
>> =E2=94=82=E2=94=94sdd 1.82t [8:48] MD raid6 (6) inactive 'ion:md0'
>> {0ad2603e-e432-83ee-0218-077398e716ef}
>> =E2=94=9Cscsi 3:x:x:x [Empty]
>> =E2=94=9Cscsi 4:x:x:x [Empty]
>> =E2=94=9Cscsi 5:0:0:0 ATA      WDC WD20EARS-00J {WD-WCAWZ2036074}
>> =E2=94=82=E2=94=94sde 1.82t [8:64] MD raid6 (6) inactive 'ion:md0'
>> {0ad2603e-e432-83ee-0218-077398e716ef}
>> =E2=94=94scsi 6:0:0:0 ATA      ST3000DM001-1CH1 {W1F2PZGH}
>>  =E2=94=94sdf 2.73t [8:80] Partitioned (dos)
>>   =E2=94=9Csdf1 1.82t [8:81] MD raid6 (5) inactive 'ion:0'
>> {4cae433f-a40a-fcf5-f9ab-a91dd8217b69}
>>   =E2=94=9Csdf2 1.30g [8:82] MD raid0 (3) inactive 'ion:1'
>> {a20b70d4-7ee1-7e3f-abab-74f8dadb8cd8}
>>   =E2=94=94sdf3 184.98g [8:83] ext4 '198GB' {e4fc427a-4ec1-48dc-8d9b=
-bfcffe06d42f}
>>
>>
>> If I try:
>>
>> [root@ion ~]# mdadm --assemble --scan
>> mdadm: /dev/md/0 assembled from 1 drive - not enough to start the ar=
ray.
>> mdadm: /dev/md/1 assembled from 1 drive - not enough to start the ar=
ray.
>>
>> From dmesg:
>>
>> [ 1227.671344]  sda: sda1
>> [ 1227.680392] md: sda does not have a valid v1.2 superblock, not im=
porting!
>> [ 1227.680414] md: md_import_device returned -22
>> [ 1227.680462] md: md0 stopped.
>> [ 1227.707969]  sdb: sdb1
>> [ 1227.718598] md: sdb does not have a valid v1.2 superblock, not im=
porting!
>> [ 1227.718611] md: md_import_device returned -22
>> [ 1227.718631] md: md0 stopped.
>> [ 1286.334542] md: md0 stopped.
>> [ 1286.338250] md: bind<sdf1>
>> [ 1286.338390] md: md0 stopped.
>> [ 1286.338400] md: unbind<sdf1>
>> [ 1286.348350] md: export_rdev(sdf1)
>> [ 1286.372268] md: bind<sdf1>
>> [ 1286.373390] md: md1 stopped.
>> [ 1286.373936] md: bind<sdf2>
>> [ 1286.373977] md: md1 stopped.
>> [ 1286.373983] md: unbind<sdf2>
>> [ 1286.388061] md: export_rdev(sdf2)
>> [ 1286.405140] md: bind<sdf2>
>>
>> [root@ion ~]# cat /proc/mdstat
>> Personalities :
>> md1 : inactive sdf2[2](S)
>>       1366104 blocks super 1.2
>>
>> md0 : inactive sdf1[3](S)
>>       1952015360 blocks super 1.2
>>
>> unused devices: <none>
>>
>>
>> If I try manually (I'm not sure of the order though):
>>
>> [root@ion ~]# mdadm --assemble --readonly --verbose /dev/md0 /dev/sd=
a
>> /dev/sdb /dev/sdd /dev/sde
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 5.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
>> mdadm: added /dev/sde to /dev/md0 as 1
>> mdadm: no uptodate device for slot 2 of /dev/md0
>> mdadm: failed to add /dev/sda to /dev/md0: Invalid argument
>> mdadm: no uptodate device for slot 4 of /dev/md0
>> mdadm: added /dev/sdd to /dev/md0 as 5
>> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
>> mdadm: /dev/md0 assembled from 2 drives - need 5 to start (use --run=
 to insist).
>>
>>
>> Any idea where I should start?
>>
>> Thanks
>> Mathias
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
