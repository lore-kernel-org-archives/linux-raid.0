From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 17:46:30 +0100
Message-ID: <6o6tb2-cj2.ln1@news.it.uc3m.es>
References: <41EBD827.80701@pipi.ma.cx> <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net> <1105977081.15184.12.camel@linux.local>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hans Kristian Rosbach <hk@isphuset.no> wrote:
> -It selects the disk that is closest to the wanted sector by remembering
>  what sector was last requested and what disk was used for it.
> -For sequential reads (sucha as hdparm) it will override and use the
>  same disk anyways. (sector = lastsector+1)
> 
> I gained a lot of throughput by alternating disk, but seek time was
> roughly doubled. I also tried to get smart and played some with the
> code in order to avoid seeking both disks back and forth wildly when
> there were two sequential reads. I didn't find a good way to do it
> unfortunately.

Interesting. How did you measure latency? Do you have a script you
could post?

> I'm not going to make any patch available, because I removed bad-disk
> checking in order to simplify it.

The FR1 patch measures disk latency and weights the disk head distances
by the measured latency, which may help.  It probably also gets rid of
that sequential read thing (I haven't done anything but port the patch
to 2.6, not actually run it in anger!).

  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.15b.tgz

(I am doing a 2.16 with the robust-read patch I suggested added in).

I really don't think this measuring disk head position can help unless
raid controls ALL of the disks in question, or the disks are otherwise
inactive.  Is that your case?


Peter

