From: David Greaves <david@dgreaves.com>
Subject: Re: Raid 5 questions
Date: Thu, 03 Jun 2004 16:50:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BF48D9.6020409@dgreaves.com>
References: <40BF35D7.9050902@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40BF35D7.9050902@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Answering my own post:
<snip>
 > Rebuild Status : 0% complete
<snip>

Yeah, ok, I'm dim :)

Maybe the output could be a little more helpful? State = rebuilding?

and for anyone else, cat /proc/mdstat gave me the hint!!

Other things:
1)
in Manage mode it's documented to allow multiple commands and yet:

cu:~# mdadm  /dev/md0 -f /dev/sdc1 -r /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
mdadm: hot remove failed for /dev/sdc1: Device or resource busy
cu:~# mdadm  /dev/md0 -r /dev/sdc1
mdadm: hot removed /dev/sdc1


2)
To allow autodetection on startup you're supposed to set the partition 
type to 0xfd
What if you're using whole disks? Are you supposed to create massive 
partitions?

3)
I'm having some odd responses from the Monitor mode:

Here is the system:

cu:~# mdadm --detail /dev/md0
/dev/md0:
       Version : 00.90.01
 Creation Time : Thu Jun  3 17:03:11 2004
    Raid Level : raid5
    Array Size : 1975552 (1.88 GiB 2.02 GB)
   Device Size : 987776 (964.63 MiB 1011.48 MB)
  Raid Devices : 3
 Total Devices : 4
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Thu Jun  3 17:32:45 2004
         State : clean, no-errors
Active Devices : 3
Working Devices : 4
Failed Devices : 0
 Spare Devices : 1

        Layout : left-symmetric
    Chunk Size : 128K

   Number   Major   Minor   RaidDevice State
      0       8        1        0      active sync   /dev/sda1
      1       8       17        1      active sync   /dev/sdb1
      2       8       33        2      active sync   /dev/sdc1
      3       8        2       -1      spare   /dev/sda2
          UUID : 9120f538:88dcabef:ba6f5f75:d2ce9e00
        Events : 0.3904

I run the monitor using a PROGRAM to ensure I see all events (#'s below 
are annotations :) )
cu:~# mdadm --monitor -d 1 -t /dev/md0
mdadm: Monitor using program "/bin/echo" from config file
TestMessage /dev/md0
# -f a device at this point
Fail /dev/md0
# Note that the device is not reported.
# A bit later (not long now I'm using 1Gb test partitions!)
SpareActive /dev/md0 /dev/sda2
# Note there were no RebuildStarted, RebuildNN, RebuildFinished events?
# -r the device - no events
# -a the device - no events
# mdadm --stop /dev/md0 here
DeviceDisappeared /dev/md0

Also stopping the monitor and degrading the array (-f a device) followed 
by a monitor restart doesn't give a DegradedArray event.


David

