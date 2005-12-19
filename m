From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm state
Date: Mon, 19 Dec 2005 20:48:30 +1100
Message-ID: <17318.33262.936434.118088@cse.unsw.edu.au>
References: <1134985289.11548.17.camel@Gentoo-Whng40.pro-jects.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mario kammerer - the.PRO-jects.com on Monday December 19
Sender: linux-raid-owner@vger.kernel.org
To: m.kammerer@pro-jects.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 19, m.kammerer@pro-jects.com wrote:
> hello neil, hello all!
> 
> i have only a small single question, which i cannot solve via searching
> the web.
> 
> i got an raid1 with 2 scsi disk (2x 73g) and have the state "dirty,
> no-errors".
> 
> what can i do to get a REAL CLEAN state - both disks are on, active
> sync.

Upgrade mdadm to 1.9.0 or later.
It won't change the array at all, but it will report it as 'active'
rather than 'dirty', as more people than just you found it confusing.

Hopefully you will accept that when you are using your array, it is
'active'. 

Or to put it another way, it is meant to be 'dirty' (aka active) in
this state.  There is nothing wrong.

NeilBrown

> 
> ---- snipplet -----
> mdadm -D /dev/md1
> /dev/md1:
>         Version : 00.90.00
>   Creation Time : Mon Feb 10 21:17:05 2003
>      Raid Level : raid1
>      Array Size : 71681920 (68.36 GiB 73.40 GB)
>     Device Size : 71681920 (68.36 GiB 73.40 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Dec 19 11:25:26 2005
>           State : dirty, no-errors
> Active Devices : 2
> Working Devices : 2
> Failed Devices : 0
>   Spare Devices : 0
> 
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
>            UUID : 59a16c8a:d18a2590:cfe54cd9:f8c7ff55
>          Events : 0.63
> ---------------------------------------------------------------------------
> 
> many thanks for a small tip!
> 
> best regards,
> mario - austria - vienna
> 
> 
> --
> Mario Kammerer  
