From: micah <micah@riseup.net>
Subject: Re: Raid1 element stuck in (S) state
Date: Tue, 28 Oct 2014 00:45:48 -0400
Message-ID: <877fzkx0n7.fsf@muck.riseup.net>
References: <87k33lwq7s.fsf@muck.riseup.net> <20141027165716.44eaab04@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141027165716.44eaab04@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, micah anderson <micah@debian.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Joe,

Joe Lawrence <joe.lawrence@stratus.com> writes:

> On Mon, 27 Oct 2014 10:18:47 -0400
> micah anderson <micah@debian.org> wrote:
>
>> 
>> Hi,
>> 
>> i've got a raid1 setup, where one drive died, it was replaced with a new
>> one, but its stuck in a (S) state and I can't seem to get it added into
>> the array, /proc/mdstat looks like this:
>> 
>> md3 : active raid1 sdc1[2](S) sdd1[1]
>>       976759672 blocks super 1.2 [2/1] [_U]
>> 
>> where sdc1 is the replaced drive.
>
> Hi Micah,
>
> What does the output from mdadm --detail /dev/md3 look like?

# mdadm --detail /dev/md3
/dev/md3:
        Version : 1.2
  Creation Time : Fri Oct 21 12:22:03 2011
     Raid Level : raid1
     Array Size : 976759672 (931.51 GiB 1000.20 GB)
  Used Dev Size : 976759672 (931.51 GiB 1000.20 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Oct 27 21:45:01 2014
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

           Name : unassigned-hostname:3
           UUID : 736c4da2:1e53a976:6b0ff39a:b0ca93c2
         Events : 2459508

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       49        1      active sync   /dev/sdd1

       2       8       33        -      spare   /dev/sdc1
# 

