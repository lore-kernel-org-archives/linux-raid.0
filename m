From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: Looking for the cause of poor I/O performance
Date: Mon, 6 Dec 2004 09:48:51 -0800
Message-ID: <20041206174851.GA521@hamachi.dyndns.org>
References: <200412041759.iB4HxG922078@www.watkins-home.com> <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca> <20041205010008.GA8091@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041205010008.GA8091@hamachi.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 04 Dec 2004 17:00:08 -0800, Steven Ihde wrote:
[snip]
> A possible clue is that when tested individually but in parallel, hda
> and hdc both halve their bandwidth:
> 
> /dev/hda:
>  Timing cached reads:   1552 MB in  2.00 seconds = 774.57 MB/sec
>  Timing buffered disk reads:   68 MB in  3.07 seconds =  22.15 MB/sec
> /dev/hdc:
>  Timing cached reads:   784 MB in  2.00 seconds = 391.86 MB/sec
>  Timing buffered disk reads:   68 MB in  3.02 seconds =  22.54 MB/sec
> /dev/sda:
>  Timing cached reads:   836 MB in  2.00 seconds = 417.65 MB/sec
>  Timing buffered disk reads:  120 MB in  3.00 seconds =  39.94 MB/sec
> 
> Could there be contention for some shared resource in the on-board
> PATA chipset between hda and hdc?  Would moving one of them to a
> separate IDE controller on a PCI card help?
> 
> Am I unreasonable to think that I should be getting better than 37
> MB/sec on raid5 read performance, given that each disk alone seems
> capable of 40 MB/sec?

To answer my own question... I moved one of the PATA drives to a PCI
PATA controller.  This did enable me to move 40MB/sec simultaneously
from all three drives.  Guess there's some issue with the built-in
PATA on the ICH5R southbridge.

However, this didn't help raid5 performance -- it was still about
35-39MB/sec.  I also have a raid1 array on the same physical disks,
and observed the same thing there (same read performance as a single
disk with hdparm -tT, about 40 MB/sec).  So:

2.6.8 includes the raid1 read balancing fix which was mentioned
previously on this list -- should this show up as substantially better
hdparm -tT numbers for raid1 or is it more complicated than that?

Does raid5 do read-balancing at all or am I just fantasizing?

Thanks,

Steve
