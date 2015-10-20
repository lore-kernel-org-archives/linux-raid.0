From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 07:34:35 +0900
Message-ID: <CA+LiH2qrrNXTByGtth5upf6JNrUCXfqoB6esUEck2+yVnedTGA@mail.gmail.com>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
	<5626464D.9000502@turmel.org>
	<3baf849321d819483c5d20c005a31844@tantosonline.com>
	<562660EE.9020504@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562660EE.9020504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Andras Tantos <andras@tantosonline.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,
Thanks for all the information shared by you over this thread.

It is really informative.

Regards
Anugraha

On Wed, Oct 21, 2015 at 12:42 AM, Phil Turmel <philip@turmel.org> wrote=
:
> Hi Andras,
>
> { Added linux-raid back -- convention on kernel.org is to reply-to-al=
l,
> trim replies, and either interleave or bottom post.  I'm trimming les=
s
> than normal this time so the list can see. }
>
> On 10/20/2015 10:48 AM, andras@tantosonline.com wrote:
>> On 2015-10-20 08:49, Phil Turmel wrote:
>
>>> Please supply all of you mdadm -E reports for the seven partitions =
and
>>> the lsdrv output I requests.  Just post the text inline in your rep=
ly.
>>>
>>> Do *not* do anything else.
>>>
>>> Phil
>
>> Thanks for all the help!
>>
>> Here's the output of lsdrv:
>>
>> PCI [pata_marvell] 04:00.1 IDE interface: Marvell Technology Group L=
td.
>> 88SE9128 IDE Controller (rev 11)
>> =E2=94=9Cscsi 0:x:x:x [Empty]
>> =E2=94=94scsi 2:x:x:x [Empty]
>> PCI [pata_jmicron] 05:00.1 IDE interface: JMicron Technology Corp.
>> JMB363 SATA/IDE Controller (rev 02)
>> =E2=94=9Cscsi 1:x:x:x [Empty]
>> =E2=94=94scsi 3:x:x:x [Empty]
>> PCI [ahci] 04:00.0 SATA controller: Marvell Technology Group Ltd.
>> 88SE9123 PCIe SATA 6.0 Gb/s controller (rev 11)
>> =E2=94=9Cscsi 4:0:0:0 ATA      ST2000DM001-1ER1 {Z4Z1JDN8}
>> =E2=94=82=E2=94=94sda 1.82t [8:0] Partitioned (dos)
>> =E2=94=82 =E2=94=94sda1 1.82t [8:1] Empty/Unknown
>> =E2=94=94scsi 5:0:0:0 ATA      ST2000DM001-1ER1 {Z4Z1H84Q}
>>  =E2=94=94sdb 1.82t [8:16] Partitioned (dos)
>>   =E2=94=94sdb1 1.82t [8:17] ext4 'data' {d1403616-a9c6-4cd9-8d92-1a=
abc81fe373}
>> PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH=
10
>> Family) 4 port SATA IDE Controller #1
>> =E2=94=9Cscsi 6:0:0:0 ATA      ST31500541AS     {6XW0BQL0}
>> =E2=94=82=E2=94=94sdc 1.36t [8:32] Partitioned (dos)
>> =E2=94=82 =E2=94=94sdc1 1.36t [8:33] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> =E2=94=9Cscsi 6:0:1:0 ATA      WDC WD20EARS-00M {WD-WMAZA0348342}
>> =E2=94=82=E2=94=94sdd 1.82t [8:48] Partitioned (dos)
>> =E2=94=82 =E2=94=9Csdd1 525.53m [8:49] ext4 'boot1' {a3a1cedc-3866-4=
d80-af18-a7a4db99d880}
>> =E2=94=82 =E2=94=9Csdd2 1.36t [8:50] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> =E2=94=82 =E2=94=94sdd3 465.24g [8:51] MD raid1 (3) inactive
>> {f89cbbf7-66e9-eb44-42ea-8b6c723593c7}
>> =E2=94=9Cscsi 7:0:0:0 ATA      ST31500541AS     {5XW05FFV}
>> =E2=94=82=E2=94=94sde 1.36t [8:64] Partitioned (dos)
>> =E2=94=82 =E2=94=94sde1 1.36t [8:65] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> =E2=94=94scsi 7:0:1:0 ATA      WDC WD20EARS-00M {WD-WMAZA0209553}
>>  =E2=94=94sdf 1.82t [8:80] Partitioned (dos)
>>   =E2=94=9Csdf1 525.53m [8:81] ext4 'boot2' {9b0e1e49-c736-47c0-89a1=
-4cac07c1d5ef}
>>   =E2=94=9Csdf2 1.36t [8:82] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>>   =E2=94=94sdf3 465.24g [8:83] MD raid1 (1/3) (w/ sdi3) in_sync
>> {f89cbbf7-66e9-eb44-42ea-8b6c723593c7}
>>    =E2=94=94md0 465.24g [9:0] MD v0.90 raid1 (3) clean DEGRADED
>> {f89cbbf7:66e9eb44:42ea8b6c:723593c7}
>>     =E2=94=82                 ext4 'root' {ceb15bfe-e082-484c-9015-1=
fcc8889b798}
>>     =E2=94=94Mounted as /dev/disk/by-uuid/ceb15bfe-e082-484c-9015-1f=
cc8889b798 @ /
>> PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH=
10
>> Family) 2 port SATA IDE Controller #2
>> =E2=94=9Cscsi 8:0:0:0 ATA      ST31500341AS     {9VS1EFFD}
>> =E2=94=82=E2=94=94sdg 1.36t [8:96] Partitioned (dos)
>> =E2=94=82 =E2=94=94sdg1 1.36t [8:97] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> =E2=94=94scsi 10:0:0:0 ATA      Hitachi HDS5C302 {ML2220F30TEBLE}
>>  =E2=94=94sdh 1.82t [8:112] Partitioned (dos)
>>   =E2=94=94sdh1 1.82t [8:113] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> PCI [ahci] 05:00.0 SATA controller: JMicron Technology Corp. JMB363
>> SATA/IDE Controller (rev 02)
>> =E2=94=9Cscsi 9:0:0:0 ATA      WDC WD2002FAEX-0 {WD-WMAY01975001}
>> =E2=94=82=E2=94=94sdi 1.82t [8:128] Partitioned (dos)
>> =E2=94=82 =E2=94=9Csdi1 525.53m [8:129] Empty/Unknown
>> =E2=94=82 =E2=94=9Csdi2 1.36t [8:130] MD raid6 (10) inactive
>> {5e57a17d-43eb-0786-42ea-8b6c723593c7}
>> =E2=94=82 =E2=94=94sdi3 465.24g [8:131] MD raid1 (2/3) (w/ sdf3) in_=
sync
>> {f89cbbf7-66e9-eb44-42ea-8b6c723593c7}
>> =E2=94=82  =E2=94=94md0 465.24g [9:0] MD v0.90 raid1 (3) clean DEGRA=
DED
>> {f89cbbf7:66e9eb44:42ea8b6c:723593c7}
>> =E2=94=82                     ext4 'root' {ceb15bfe-e082-484c-9015-1=
fcc8889b798}
>> =E2=94=94scsi 11:0:0:0 ATA      ST2000DM001-1ER1 {Z4Z1JCDE}
>>  =E2=94=94sdj 1.82t [8:144] Partitioned (dos)
>>   =E2=94=94sdj1 1.82t [8:145] Empty/Unknown
>> Other Block Devices
>> =E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
>> =E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
>> =E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
>> =E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
>> =E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
>> =E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
>> =E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
>> =E2=94=94loop7 0.00k [7:7] Empty/Unknown
>>
>>
>> mdadm output:
>>
>> mdadm -E /dev/sdb1 /dev/sda1 /dev/sdc1 /dev/sdd2 /dev/sde1 /dev/sdh1
>> /dev/sdg1 /dev/sdi2 /dev/sdj1 /dev/sdf2
>
>> mdadm: No md superblock detected on /dev/sdb1.
>
>> mdadm: No md superblock detected on /dev/sda1.
>
>> /dev/sdc1:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad60723 - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     4       8        1        4      active sync   /dev/sda1
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> /dev/sdd2:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad6072e - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     1       8       18        1      active sync
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> /dev/sde1:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad60741 - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     3       8       33        3      active sync   /dev/sdc1
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> /dev/sdh1:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad60775 - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     5       8       81        5      active sync   /dev/sdf1
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> /dev/sdg1:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad6075f - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     2       8       65        2      active sync   /dev/sde1
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> /dev/sdi2:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad60788 - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     6       8       98        6      active sync
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> mdadm: No md superblock detected on /dev/sdj1.
>
>> /dev/sdf2:
>>           Magic : a92b4efc
>>         Version : 0.91.00
>>            UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
>>   Creation Time : Sat Oct  2 07:21:53 2010
>>      Raid Level : raid6
>>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>>      Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
>>    Raid Devices : 10
>>   Total Devices : 10
>> Preferred Minor : 1
>>
>>   Reshape pos'n : 4096
>>   Delta Devices : 3 (7->10)
>>
>>     Update Time : Sat Oct 17 18:59:50 2015
>>           State : active
>>  Active Devices : 10
>> Working Devices : 10
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : fad6074c - correct
>>          Events : 2579239
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     0       8       50        0      active sync   /dev/sdd2
>>
>>    0     0       8       50        0      active sync   /dev/sdd2
>>    1     1       8       18        1      active sync
>>    2     2       8       65        2      active sync   /dev/sde1
>>    3     3       8       33        3      active sync   /dev/sdc1
>>    4     4       8        1        4      active sync   /dev/sda1
>>    5     5       8       81        5      active sync   /dev/sdf1
>>    6     6       8       98        6      active sync
>>    7     7       8      145        7      active sync   /dev/sdj1
>>    8     8       8      129        8      active sync   /dev/sdi1
>>    9     9       8      113        9      active sync   /dev/sdh1
>
>> Apparently my problems don't stop adding up: now SDD started develop=
ing
>> problems, so my root partition (md0) is now degraded. I will attempt=
 to
>> dd out whatever I can from that drive and continue...
>
> Don't.  You have another problem: green & desktop drives in a raid
> array.  They aren't built for it and will give you grief of one form =
or
> another.  Anyways, their problem with timeout mismatch can be worked
> around with long driver timeouts.  Before you do anything else, you
> *MUST* run this command:
>
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
>
> (Arrange for this to happen on every boot, and keep doing it manually
> until your boot scripts are fixed.)
>
> Then you can add your missing mirror and let MD fix it:
>
> mdadm /dev/md0 --add /dev/sdd3
>
> After that's done syncing, you can have MD fix any remaining UREs in
> that raid1 with:
>
> echo check >/sys/block/md0/md/sync_action
>
> While that's in progress, take the time to read through the links in =
the
> postscript -- the timeout mismatch problem and its impact on
> unrecoverable read errors has been hashed out on this list many times=
=2E
>
> Now to your big array.  It is vital that it also be cleaned of UREs
> after re-creation before you do anything else.  Which means it must
> *not* be created degraded (the redundancy is needed to fix UREs).
>
> According to lsdrv and your "mdadm -E" reports, the creation order yo=
u
> need is:
>
> raid device 0 /dev/sdf2 {WD-WMAZA0209553}
> raid device 1 /dev/sdd2 {WD-WMAZA0348342}
> raid device 2 /dev/sdg1 {9VS1EFFD}
> raid device 3 /dev/sde1 {5XW05FFV}
> raid device 4 /dev/sdc1 {6XW0BQL0}
> raid device 5 /dev/sdh1 {ML2220F30TEBLE}
> raid device 6 /dev/sdi2 {WD-WMAY01975001}
>
> Chunk size is 64k.
>
> Make sure your partially assembled array is stopped:
>
> mdadm --stop /dev/md1
>
> Re-create your array as follows:
>
> mdadm --create --assume-clean --verbose \
>     --metadata=3D1.0 --raid-devices=3D7 --chunk=3D64 --level=3D6 \
>     /dev/md1 /dev/sd{f2,d2,g1,e1,c1,h1,i2}
>
> Use "fsck -n" to check your array's filesystem (expect some damage at
> the very begining).  If it look reasonable, use fsck to fix any damag=
e.
>
> Then clean up any lingering UREs:
>
> echo check > /sys/block/md1/md/sync_action
>
> Now you can mount it and catch any critical backups. (You do know tha=
t
> raid !=3D backup, I hope.)
>
> Your array now has a new UUID, so you probably want to fix your
> mdadm.conf file and your initramfs.
>
> Finaly, go back and do your --grow, with the --backup-file.
>
> In the future, buy drives with raid ratings like the WD Red family, a=
nd
> make sure you have a cron job that regularly kicks off array scrubs. =
 I
> do mine weekly.
>
> HTH,
>
> Phil
>
> [1] http://marc.info/?l=3Dlinux-raid&m=3D139050322510249&w=3D2
> [2] http://marc.info/?l=3Dlinux-raid&m=3D135863964624202&w=3D2
> [3] http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1
> [4] http://marc.info/?l=3Dlinux-raid&m=3D133761065622164&w=3D2
> [5] http://marc.info/?l=3Dlinux-raid&m=3D132477199207506
> [6] http://marc.info/?l=3Dlinux-raid&m=3D133665797115876&w=3D2
> [7] https://www.marc.info/?l=3Dlinux-raid&m=3D142487508806844&w=3D3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
