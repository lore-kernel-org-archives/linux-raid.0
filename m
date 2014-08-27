From: Peter Hoeg <peter@hoeg.com>
Subject: Re: Add BBL to existing array
Date: Wed, 27 Aug 2014 19:29:08 +0800
Message-ID: <20140827112908.GF15857@dolores.internal.speartail.com>
References: <20140827090707.GA15857@dolores.internal.speartail.com>
 <20140827192721.57c57c3b@notabene.brown>
 <20140827103213.GE15857@dolores.internal.speartail.com>
 <20140827210700.5a9b3e60@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140827210700.5a9b3e60@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

>> It basically runs:
>> # mdadm --assemble --scan --run --auto=yes
>>
>> so it would become:
>> # mdadm --assemble --update=bbl --scan --run --auto=yes
>
>Sorry, --update and --scan are incompatible.

That explains that...

>> That didn't work. I ended up in the initramfs and had to manually bring
>> up the RAID as well as LVM to get the machine booted.
>
>That would have been a good time to wield the --update=bbl seeing you were
>assembling the array anyway.

I actually did - I ran:

mdadm --assemble --update=bbl /dev/md0

Which returned without error, but it doesn't seem to have changed
anything (or am I looking in the wrong place?)

# mdadm --detail /dev/md0

/dev/md0:
        Version : 1.2
  Creation Time : Fri Jan 11 15:02:11 2013
     Raid Level : raid6
     Array Size : 5859439616 (5588.00 GiB 6000.07 GB)
  Used Dev Size : 2929719808 (2794.00 GiB 3000.03 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Aug 27 19:23:06 2014
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : nas2:md0
           UUID : d6c281be:30db3be9:b1316603:00f77a7d
         Events : 190523

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       3       8       34        2      active sync   /dev/sdc2
       4       8       50        3      active sync   /dev/sdd2

Or is the 4KB mentioned in /proc/mdstat ?

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda2[0] sdd2[4] sdc2[3] sdb2[1]
      5859439616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 1/2 pages [4KB], 1048576KB chunk
                        ^^^^^

unused devices: <none>


>Oops.  I forgot to update that list when I added 'bbl' and 'no-bbl'.
>
>Will be fixed in 3.3.3.

Looking forward to seeing that in Debian in 2017... ;-)

--
Regards,
Peter
