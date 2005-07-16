From: Jim Radford <jradford@npl.com>
Subject: Re: md_import_device returned -16 raid1
Date: Sat, 16 Jul 2005 16:06:03 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0507161605230.8523@hoss.npl.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've got a 2.6.11 kernel which has 0.90.1 instead of 0.90.0 md driver in it, 
and the same errors occur. What version of the md driver is in 2.6.12/3?

Thanks
Jim

md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27

On Sat, 16 Jul 2005, Tyler wrote:
> Unless the mandrake kernel has backported patches in its kernel sources, I 
> would suggest trying a newer kernel... current is 2.6.12.2, and just about 
> 2.6.13.
> 
> Tyler.
> 
> Jim Radford wrote:
> 
>> Greetings all:
>> 
>> Having a bit of difficulty with raid1, I built the array lastnight with 
>> two new drives, and it built fine but when I rebooted I get the following 
>> error when trying to start the array:
>> 
>> I'm running Mandrake 10.1 kernel 2.6.8.1-12mdk
>> 
>> [root@localhost jradford]# mdadm --version
>> mdadm - v1.7.0 - 11 August 2004
>> 
>> [root@bengali jradford]# mdadm -A -s
>>> failed to add /dev/hdc to /dev/md0: Device or resource busy
>>> /dev/md0 has been started with 1 drive (out of 2).
>> 
>> The following error message shows up in dmesg:
>> 
>> [root@bengali jradford]# dmesg | grep md:
>>> md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
>>> Autodetecting RAID arrays.
>>> autorun ...
>>> ... autorun DONE.
>>> md0 stopped.
>>> could not lock unknown-block(22,0).
>>> md_import_device returned -16
>>> bind<hdb>
>> 
>> my /proc/mdstat:
>> 
>> [root@bengali jradford]# cat /proc/mdstat
>> Personalities : [raid1]
>> md0 : active raid1 hdb[0]
>> 195360896 blocks [2/1] [U_]
>> 
>> unused devices: <none>
>> 
>> Some drive specific information
>> 
>> [root@bengali jradford]# mdadm -E /dev/hdb
>> /dev/hdb:
>> Magic : a92b4efc
>> Version : 00.90.00
>>        UUID : 9d09bd52:e44dc514:4e6b732f:5263e2f8
>> Creation Time : Fri Jul 15 21:16:18 2005
>> Raid Level : raid1
>> Device Size : 195360896 (186.31 GiB 200.05 GB)
>> Raid Devices : 2
>> Total Devices : 2
>> Preferred Minor : 0
>> 
>> Update Time : Sat Jul 16 07:33:32 2005
>>        State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>> Spare Devices : 0
>> Checksum : 5ca8741a - correct
>> Events : 0.326
>> 
>> 
>>     Number   Major   Minor   RaidDevice State
>> this     0       3       64        0      active sync   /dev/hdb
>> 
>> 0     0       3       64        0      active sync   /dev/hdb
>> 1     1      22        0        1      active sync   /dev/hdc
>> 
>> [root@localhost jradford]# mdadm -E /dev/hdc
>> /dev/hdc:
>> Magic : a92b4efc
>> Version : 00.90.00
>>        UUID : 9d09bd52:e44dc514:4e6b732f:5263e2f8
>> Creation Time : Fri Jul 15 21:16:18 2005
>> Raid Level : raid1
>> Device Size : 195360896 (186.31 GiB 200.05 GB)
>> Raid Devices : 2
>> Total Devices : 2
>> Preferred Minor : 0
>> 
>> Update Time : Sat Jul 16 07:33:32 2005
>>        State : clean
>> Active Devices : 2
>> Working Devices : 2
>> Failed Devices : 0
>> Spare Devices : 0
>> Checksum : 5ca873ef - correct
>> Events : 0.326
>> 
>> 
>>     Number   Major   Minor   RaidDevice State
>> this     1      22        0        1      active sync   /dev/hdc
>> 
>> 0     0       3       64        0      active sync   /dev/hdb
>> 1     1      22        0        1      active sync   /dev/hdc
>> 
>> And for the md status:
>> 
>> [root@bengali mdadm-2.0-devel-2]# mdadm -D /dev/md0
>> /dev/md0:
>>     Version : 00.90.01
>> Creation Time : Fri Jul 15 21:16:18 2005
>> Raid Level : raid1
>> Array Size : 195360896 (186.31 GiB 200.05 GB)
>> Device Size : 195360896 (186.31 GiB 200.05 GB)
>> Raid Devices : 2
>> Total Devices : 1
>> Preferred Minor : 0
>> Persistence : Superblock is persistent
>> 
>> Update Time : Sat Jul 16 07:33:32 2005
>>        State : clean, degraded
>> Active Devices : 1
>> Working Devices : 1
>> Failed Devices : 0
>> Spare Devices : 0
>> 
>> UUID : 9d09bd52:e44dc514:4e6b732f:5263e2f8
>> Events : 0.326
>> 
>> Number   Major   Minor   RaidDevice State
>> 0       3       64        0      active sync   /dev/hdb
>> 1       0        0        -      removed
>> 
>> 
>> 
>> If I try and add hdc to the array With version 1.9.0 I get
>> mdadm: hot add failed for /dev/hdc: Invalid argument
>> but the same message in dmesg as above.
>> 
>> with 2.0devel2 I get:
>> mdadm: Cannot open /dev/hdc: Device or resource busy
>> But also the same message in dmesg as above
>> 
>> Any advice would be greatly appreciated.
>> 
>> Regards,
>> Jim
> 
>

-- 
==========================================================================
Jim Radford <jradford@npl.com>
http://www.jimradford.com/
==========================================================================
