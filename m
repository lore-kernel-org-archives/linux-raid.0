From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID-6 ...
Date: Sat, 15 Jan 2005 16:12:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501130941190.21510@lion.drogon.net>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
 <Pine.LNX.4.56.0501121020490.21510@lion.drogon.net> <16869.55531.489452.193862@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16869.55531.489452.193862@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Jan 2005, Neil Brown wrote:

> There is no current support for raid6 in any 2.4 kernel and I am not
> aware of anyone planning such support.  Assume it is 2.6 only.

How "real-life" tested is RAID-6 so-far? Anyone using it in anger on a
production server?

I've spent the past day or 2 getting to grips with kernel 2.6.10 and mdadm
1.8.0 on a test system running Debian Woody, on a rather clunky old test
PC - Asus XG-DLS, Twin Xeon PIII/500's on-board IDE with 2 x old 4GB
drives attached, it also has on-board Adaptec SCSI with 2 x 18GB drives -
one on an 8-bit bus, and a Highpoint HPT302 card with 2 modern 80 GB
drives (Maxtor, I know, but keep them cool and so-far so good...)

Performance isn't exactly stellar (one PCI bus!) but I did squeeze
60MB/sec out of a RAID-0 off the 2 new drives... Clunky by todays
standards, but 5.5 years ago when it was new, it rocked!

Anyway, so far so good. I've constructed a RAID-6 system with a 4GB
partition on 5 of the drives, and done some tests & what not.

The tests I've done involve creating the array, putting a filesystem on it
(ext3), writing a bigfile of zeros, checksumming it, failing a drive,
adding it back in, failing another, failing a 2nd, adding them in, failing
another before the 2nd drive finished resyncing, etc. all the time writing
a file & checksumming it between unmounting & re-mounting it. There was a
script posted round about July last year which I used to get some ideas
from.

So-far so good, no corruption, but it doesn't doesn't mean anything in the
real-world.

So who's using RAID-6 for real?

Can it be considered more or less stable than RAID-5?

Should I stick to my RAID-5 on-top of RAID-1 pairs?

Or should I just take a chance with RAID-6? (And nearly 6 years ago when I
started using Linux s/w RAID I said this to myself, but stuck with it and
haven't had a problem I could pin down to software... So who knows!)

Gordon
