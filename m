From: Adam Luter <luterac@bellsouth.net>
Subject: Re: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 09:39:30 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029153930.GA21099@smeagol>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de> <20021029131453.GB24171@unthought.net> <1035904587.13219.304.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1035904587.13219.304.camel@ralph.plexio.private>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 29, 2002 at 07:16:26AM -0800, Stephen Lee wrote:
> > real    0m5.024s
> > 
> 
> My systems are very different than what you describe above but here are
> some data points for reference. BTW, should that not be "of=$i/$j"?  
> 
> For a Dual P3/1.4Gig with 3x10000rpm SCSI drives running software raid5
> and ext3 on a 2.4.18 (Redhat 7.3 2.4.18-17.7) kernel:
> 
> real	0m2.217s
> 
> For a P3/1Gig with 2x10000rpm SCSI drive running software raid1 and ext3
> on a stock 2.4.18 kernel:
> 
> real	0m3.349s

#!/bin/sh
time for i in {0,1,2,3,4,5,6,7,8,9}
do
mkdir $i
 for j in {0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
 do
  dd if=/dev/zero of=$i/$j bs=1k count=4 2>/dev/null
 done
done

If everyone else is going to start squirting testosterone around, then
I'll add my share:

The above code, made an average time of about 3.7s .  This is with
raid-5 (soft) 2.4.20pre8 with 4 IDE drives (Ibm 120 gig 7200rpm)
running at/on a Promise ATA/100 card (so 2 drives per bus).  Also, the
filesystem is reiserfs, and running at medium-light load.

Changing the above code to:

#!/bin/sh
time for i in {0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
do
 dd if=/dev/zero of=$i bs=1k count=4 2>/dev/null
done

(so that it writes them all to one directory), made the same time,
3.7s on average.

In fact, adding another 0..9 onto that loop only changed the average
time to 44 seconds.

For comparison the same tests on my system drive, a Maxtor IDE 40 gig
7200rpm drive connected to the onboard IDE controller (and also
reiserfs), resulted in 3.3 seconds, and 35 seconds respectively.

My conclusions are:  IDE is damn fast and reiser kicks ass with small
files.

Of course alternate conclusions are that my raid-5 array suffers from
using two channels per drive (I know -- but when I put two promise
cards they or linux has DMA problems) and that I'm still behind the
pack when you throw 10krpm at me :) (2.2 seconds is nice!).

But, I'll never be rich enough for SCSI.

Back to the grind...

-Gryn (Adam Luter)
