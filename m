From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: recovery from multiple failures
Date: Sun, 08 Jan 2012 17:58:16 -0800
Message-ID: <o6upt8xd0p.ln2@goaway.wombat.san-francisco.ca.us>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
 <4F0A30CD.60904@turmel.org>
 <fatpt8x1so.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-01-09, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.01
>   Creation Time : Thu Sep 29 21:26:35 2011
>      Raid Level : raid6
>   Used Dev Size : 1953113920 (1862.63 GiB 1999.99 GB)
>    Raid Devices : 9
>   Total Devices : 10
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Jan  7 22:50:29 2012
>           State : active, degraded, Not Started
>  Active Devices : 8
> Working Devices : 10
>  Failed Devices : 0
>   Spare Devices : 2
>
>      Chunk Size : 64K
>
>            Name : 0
>            UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
>          Events : 106120
>
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>       13       8       33        1      active sync   /dev/sdc1
>       11       8      161        2      active sync   /dev/sdk1
>        6       8       97        3      spare rebuilding   /dev/sdg1
>        4       8       65        4      active sync   /dev/sde1
>        9       8      129        5      active sync   /dev/sdi1
>       10       8       81        6      active sync   /dev/sdf1
>        7       8      113        7      active sync   /dev/sdh1
>        8       8      145        8      active sync   /dev/sdj1
>
>       12       8      177        -      spare   /dev/sdl1

I apologize for not pointing this out in my previous post: it is
possible that drives were relabeled from the last --examine to now, as I
removed the drives that were in the other array and rebooted (simply to
stop them from confusing me).  If new mdadm --examine output is required
please let me know.

Thanks for your help!

--keith


-- 
kkeller@wombat.san-francisco.ca.us


