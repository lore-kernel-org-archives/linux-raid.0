From: NeilBrown <neilb@suse.de>
Subject: Re: check vs repair -- mismatch count goes up in repair, zeros in
 check?
Date: Sun, 19 Jun 2011 09:23:46 +1000
Message-ID: <20110619092346.2774cf10@notabene.brown>
References: <BANLkTikWJvVfmwiRgDPzprQsU_Jc67go0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikWJvVfmwiRgDPzprQsU_Jc67go0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 18 Jun 2011 09:10:01 -0700 Rory Jaffe <rsjaffe@gmail.com> wrote:

> I'm a bit confused about check vs repair.
> 
> When I run repair, mismatches are initially zero'd at the start and
> then add up as it runs through, so that at the end there is a positive
> mismatch count. Running check after that zero's them out.
> 
> I thought check would run through the array and identify mismatches,
> but not repair them, while repair would do the repair step as well.
> But the exhibited behavior seems to indicate the opposite.

Does it?   Why do you think that 'check' found no mismatches?  Because
'repair' had already repaired them!

Both 'check' and 'repair' report how many mismatches were found.  'check'
doesn't repair them.  'repair' does.

> 
> Does the mismatch count show the current number of identified
> mismatches? Or what is it really counting?

It is really counting sectors that might not match.
i.e. it performs the check is section larger than one sector.  When it finds
a mismatch it just adds the number of sectors in the section to the count.

NeilBrown


> 
> See http://pastthe.endoftheinternet.org/munin/home/ubuntunas/index.html#munin
> for an example (page up from the munin graphs--the three graphs
> immediately above track the array.
> 
> 
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sat Apr 30 14:29:07 2011
>      Raid Level : raid6
>      Array Size : 5857609728 (5586.25 GiB 5998.19 GB)
>   Used Dev Size : 1952536576 (1862.08 GiB 1999.40 GB)
>    Raid Devices : 5
>   Total Devices : 6
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Jun 18 09:08:03 2011
>           State : clean
>  Active Devices : 5
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>            Name : ubuntunas:0  (local to host ubuntunas)
>            UUID : 9916bc94:a245d51b:ecca3480:7c612ed5
>          Events : 127
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        3       8       50        3      active sync   /dev/sdd2
>        4       8       66        4      active sync   /dev/sde2
> 
>        5       8       82        -      spare   /dev/sdf2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

