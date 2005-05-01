From: John McMonagle <johnm@advocap.org>
Subject: Re: Raid 1 fails on every reboot?
Date: Sun, 01 May 2005 08:48:18 -0500
Message-ID: <4274DE22.3@advocap.org>
References: <42744609.10101@advocap.org> <4274AF2E.2060003@gw.unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4274AF2E.2060003@gw.unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@gw.unix-scripts.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Laurent CARON wrote:

> John McMonagle a =E9crit :
>
>> I cloned a system with 2 drives and 2 raid 1 partitions.
>>
>> I took a drive out of the old system.
>> Recreated the raids to get a new uuids.
>> Partitioned a new drive and added the partitions.
>> There were a couple other problems that I'm pretty sure was caused b=
y=20
>> a bad sata controller but think I have that under control.
>>
>> So here is my problem.
>> Any time I reboot only the partitions on the first drive are active.
>> If I switch drives it's always the first one that is active.
>>
>> Here is my mdadm.conf
>> DEVICE  /dev/sd*
>> ARRAY /dev/md0 level=3Draid1 num-devices=3D2=20
>> UUID=3D647381d7:fb84da16:f43e8c51:3695f234
>> ARRAY /dev/md1 level=3Draid1 num-devices=3D2=20
>> UUID=3D90b9e6d2:c78b1827:77f469ad:0f8997ed
>>
>> This is all after reboot:
>> cat /proc/mdstat
>> Personalities : [raid1]
>> md0 : active raid1 sda1[1]
>>      586240 blocks [2/1] [_U]
>>
>> md1 : active raid1 sda2[1]
>>      194771968 blocks [2/1] [_U]
>>
>> mdadm -E /dev/sda1
>> /dev/sda1:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 647381d7:fb84da16:f43e8c51:3695f234
>>  Creation Time : Sat Apr 30 06:02:47 2005
>>     Raid Level : raid1
>>   Raid Devices : 2
>>  Total Devices : 1
>> Preferred Minor : 0
>>
>>    Update Time : Sat Apr 30 21:47:22 2005
>>          State : clean
>> Active Devices : 1
>> Working Devices : 1
>> Failed Devices : 0
>>  Spare Devices : 0
>>       Checksum : b8e8e847 - correct
>>         Events : 0.4509
>>
>>
>>      Number   Major   Minor   RaidDevice State
>> this     1       8        1        1      active sync   /dev/sda1
>>
>>   0     0       0        0        0      removed
>>   1     1       8        1        1      active sync   /dev/sda1
>>
>> mdadm -E /dev/sdb1
>> /dev/sdb1:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 647381d7:fb84da16:f43e8c51:3695f234
>>  Creation Time : Sat Apr 30 06:02:47 2005
>>     Raid Level : raid1
>>   Raid Devices : 2
>>  Total Devices : 2
>> Preferred Minor : 0
>>
>>    Update Time : Sat Apr 30 21:26:07 2005
>>          State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>>  Spare Devices : 0
>>       Checksum : b8e8e1d8 - correct
>>         Events : 0.4303
>>
>>
>>      Number   Major   Minor   RaidDevice State
>> this     0       8       17        0      active sync   /dev/sdb1
>>
>>   0     0       8       17        0      active sync   /dev/sdb1
>>   1     1       8        1        1      active sync   /dev/sda1
>>
>> After adding /dev/sdb1 to md0:
>>
>> cat /proc/mdstat
>> Personalities : [raid1]
>> md0 : active raid1 sdb1[0] sda1[1]
>>      586240 blocks [2/2] [UU]
>>
>> md1 : active raid1 sda2[1]
>>      194771968 blocks [2/1] [_U]
>>
>> unused devices: <none>
>> mdadm -E /dev/sda1
>> /dev/sda1:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 647381d7:fb84da16:f43e8c51:3695f234
>>  Creation Time : Sat Apr 30 06:02:47 2005
>>     Raid Level : raid1
>>   Raid Devices : 2
>>  Total Devices : 2
>> Preferred Minor : 0
>>
>>    Update Time : Sat Apr 30 21:51:11 2005
>>          State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>>  Spare Devices : 0
>>       Checksum : b8e8e99a - correct
>>         Events : 0.4551
>>
>>
>>      Number   Major   Minor   RaidDevice State
>> this     1       8        1        1      active sync   /dev/sda1
>>
>>   0     0       8       17        0      active sync   /dev/sdb1
>>   1     1       8        1        1      active sync   /dev/sda1
>> mdadm -E /dev/sdb1
>> /dev/sdb1:
>>          Magic : a92b4efc
>>        Version : 00.90.00
>>           UUID : 647381d7:fb84da16:f43e8c51:3695f234
>>  Creation Time : Sat Apr 30 06:02:47 2005
>>     Raid Level : raid1
>>   Raid Devices : 2
>>  Total Devices : 2
>> Preferred Minor : 0
>>
>>    Update Time : Sat Apr 30 21:51:43 2005
>>          State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>>  Spare Devices : 0
>>       Checksum : b8e8e9d0 - correct
>>         Events : 0.4555
>>
>>
>>      Number   Major   Minor   RaidDevice State
>> this     0       8       17        0      active sync   /dev/sdb1
>>
>>   0     0       8       17        0      active sync   /dev/sdb1
>>   1     1       8        1        1      active sync   /dev/sda1
>>
>>
>> Any Idea what is wrong?
>>
>> John
>>
>>
>
> what does fdisk -l says?
>
neebackup:~# fdisk -l

Disk /dev/sda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          73      586341   fd  Linux raid=20
autodetect
/dev/sda2              74       24321   194772060   fd  Linux raid=20
autodetect

Disk /dev/sdb: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          73      586341   fd  Linux raid=20
autodetect
/dev/sdb2              74       24321   194772060   fd  Linux raid=20
autodetect

Also a lttle more info.

It's debian sarge.

It's a SATA150 TX4 sata controler that had been in use for months.
neebackup:~# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Apr 30 06:02:47 2005
     Raid Level : raid1
     Array Size : 586240 (572.50 MiB 600.31 MB)
    Device Size : 586240 (572.50 MiB 600.31 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun May  1 08:40:40 2005
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 647381d7:fb84da16:f43e8c51:3695f234
         Events : 0.4875

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        -      removed

There are no disk error messages.

I booted with a fedora 3 rescue cd and md0 started properly so I assume=
=20
it's something in the  startup.

I rebuilt the initrd a couple times. Is there anything in it that could=
=20
cause this problem?

John


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
