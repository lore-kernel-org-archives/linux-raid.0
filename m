From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Mon, 15 Nov 2004 20:56:43 +0000
Message-ID: <4199180B.6070408@robinbowes.com>
References: <41948B65.3090504@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41948B65.3090504@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
  > Then RMA *this* Maxtor and hope to resync in a couple of weeks (well,
> actually - these drives seem so damned unreliable I guess I'm going to 
> *have* to buy a spare)
> 
> FYI these are 250Gb Maxtor SATA disks.

David,

I use the same drives; I've had a *terrible* failure rate with the them.

I bought 6 drives - 2 from separate vendors on eBay (d1, d2) plus 4 more 
from another vendor (d3-d6). d3 turned out to be faulty so I asked the 
vendor to replace it. He said I could, or I could RMA it direct with 
Maxtor. This I did as it meant I could get a replacement quicker.

However, when I provided the drive serial no. for the RMA it turned out 
to be stolen - as did the other 3 drives from the same vendor (d4-d6) so 
I returned all 4 to the vendor and got 4 more (d7-10) after first 
checking the serial nos to make sure they weren't stolen!

Anyway, I checked the drives when I got them with the Maxtor PowerMax 
utility - 3 out of the 4 were faulty (d7-d9). I RMAd all three back to 
Maxtor and got 3 more (d11-d13). So far (touch wood) all six are still 
working OK.

Let's look at a summary:

d1	OK
d2	OK
d3	Failed
d4	Returned untested
d5	Returned untested
d6	Returned untested
d7	Failed
d8	Failed
d9	Failed
d10	OK
d11	OK
d12	OK
d13	OK

So, of the 10 drives I tested, four failed - That's a 40% failure rate.

Needless to say I decided to configure my RAID5 array with a spare:

[root@dude geeklog]# mdadm --detail /dev/md5
/dev/md5:
         Version : 00.90.01
   Creation Time : Thu Jul 29 21:41:38 2004
      Raid Level : raid5
      Array Size : 974566400 (929.42 GiB 997.96 GB)
     Device Size : 243641600 (232.35 GiB 249.49 GB)
    Raid Devices : 5
   Total Devices : 6
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Mon Nov 15 20:55:23 2004
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

            UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
          Events : 0.1716573

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
        4       8       66        4      active sync   /dev/sde2

        5       8       82        -      spare   /dev/sdf2

R.
-- 
http://robinbowes.com
