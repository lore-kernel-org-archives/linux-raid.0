From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Stress testing system?
Date: Sat, 09 Oct 2004 18:19:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41681D96.9020308@robinbowes.com>
References: <200410091658.i99GwJN22615@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410091658.i99GwJN22615@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Once a drive fails, md will not re-sync it automatically.  It will just sit
> there in a failed state.  If you had a spare, then it would re-sync
> automatically.  I am not 100% sure but I think...if you were to reboot,
> after the reboot md will resync.
> 
> If you reboot before the re-sync is done, the re-sync will start over, at
> lease with my version.

I think that's what must have happened.

I replaced the power supply and brought the box back up. It then froze 
on me, so I powered down again and investigated, bring the box up and 
down a few times in the process. I then noticed the loose power 
connection, fixed it, and brought the box back up. I reckon the array 
must have been re-syncing from that point and it had nothing to do with 
bonnie++.

Incidentally, I do have a spare drive:

[root@dude home]# mdadm --detail /dev/md5
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

     Update Time : Sat Oct  9 18:18:54 2004
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

            UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
          Events : 0.1410301

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
        4       8       66        4      active sync   /dev/sde2

        5       8       82        -      spare   /dev/sdf2

Cheers,

R.
-- 
http://robinbowes.com
