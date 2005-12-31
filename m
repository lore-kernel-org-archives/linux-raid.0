From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: hard drives with "variable"  device names - mdadm raid assembly
 options setup
Date: Sat, 31 Dec 2005 12:40:58 +0800
Message-ID: <dp52bc$nh8$1@sea.gmane.org>
References: <200512300908.19390.mlaks@verizon.net> <87d5jep027.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d5jep027.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Pittman wrote:
> Mitchell Laks <mlaks@verizon.net> writes:
> 
> G'day Mitchell.
> 
>> I notice on my system that the hard drives "device names" can change.
>>
>> The hard drives are connected to the motherboard SATA connectors or to
>> PCI SATA cards. They get different "names" /dev/sda or /dev/sdc
>> depending how many of the cards are "active".
>>
>> For instance the hard drives on the motherboard itself are called
>> /dev/sde and /dev/sdf if there are hard drives on the 2 PCI cards and
>> are called /dev/sda and /dev/sdb if there are none.
> 
> Well, one solution is udev, but since you prefer to avoid that...
> 
> [...]
> 
>> Now I am confused:  unfortunately this does not seem to help me: 
>> if it relys on the configuration file /etc/mdadm/mdadm.conf 
>> this config file - i create with the aid of mdadm --detail --scan 
>> seems to still have the (problematic) "variable" device names in it. 
> 
> ...you can simply remove the 'device names' variable, and list the
> theoretically possible devices for MD stuff in the configuration:
> 
> DEVICE /dev/hd*
> DEVICE /dev/sd*
> 
> That will include all the IDE and SCSI disks (including SATA), so they
> will be scanned at an appropriate time.
> 
> Then, list your arrays:
> 
> ARRAY /dev/md2 level=raid1 num-devices=2 UUID=529d70fa:e5fe992b:ceb05593:bfcc6c25
> 
> That will cause mdadm to scan all those device entries (all the disks
> and partitions) looking for an array with the right UUID, and assemble
> it from all the components it finds.

I am trying to do this with my 8 (currently only 7 since /dev/hdk is off 
line being replaced) disk raid5 array. mdadm --detail /dev/md0 gives :

"
/dev/md0:
         Version : 00.90.02
   Creation Time : Sat Aug  6 10:18:41 2005
      Raid Level : raid5
      Array Size : 976804480 (931.55 GiB 1000.25 GB)
     Device Size : 195360896 (186.31 GiB 200.05 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Dec 31 12:35:32 2005
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 15bfec75:595ac793:0914f8ee:862effd8
          Events : 0.838124

     Number   Major   Minor   RaidDevice State
        0      33        0        0      active sync   /dev/hde
        1      34        0        1      active sync   /dev/hdg
        2      56        0        2      active sync   /dev/hdi
        3       8        0        3      active sync   /dev/sda
        4       8       16        4      active sync   /dev/sdb
        5       8       32        5      active sync   /dev/sdc

        6       8       48        -      spare   /dev/sdd
"

I am confused why there are only 4 UUIDs, when there are 7 devices 
listed...what should I put in my mdadm.conf file, which is currently :

"
DEVICE /dev/hd[egik] /dev/sd[abcd]

ARRAY /dev/md0 level=raid5 num-devices=6 spares=1 
devices=/dev/hde,/dev/hdg,/dev/hdi,/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd
"

What do I put for UUIDs for the 7 devices?

Max.

