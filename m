From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 14:28:59 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0304031413280.20118-100000@multivac.sdsc.edu>
References: <00bf01c2fa2d$afafedd0$2e77c23e@pentium4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00bf01c2fa2d$afafedd0$2e77c23e@pentium4>
To: Jonathan Vardy <jonathanv@explainerdc.com>
Cc: Stephan van Hienen <raid@a2000.nu>, Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jonathan,

> > OK.  We've found a potential issue.  Are the disks being identified as
> > UDMA-33 or UDMA-66/100/133?  The performance numbers agree too closely for
> > this to be a coincidence.  Check the boot logs.
>
> I looked into /var/log/dmesg and found this:
>
> blk: queue c03934a8, I/O limit 4095Mb (mask 0xffffffff)
> hdc: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
> UDMA(33)
>
> This is what you meant?

That's the one.  Your 120GB drives are being seen as UDMA-33.  Whatever is
causing this is slowing you down.  Fix this, and the performance should
improve.

> but after the boot I set hdparm manually for each drive with the following
> settings:
>
> hdparm -a8 -A1 -c1 -d1 -m16 -u1 /dev/hdc.

According to your single-drive benchmarks, it didn't do the job.  You'll
have to find the CAUSE of the UDMA-33 identification, and fix it.  An
example (not necessarily your problem) is that if a 40-conductor cable is
used, you CAN'T set the drive to UDMA-66/100/133.  There may also be some
settings in the drive or controller, or some jumpers, that are keeping the
drive from switching to the fast modes.

Once you get the drives being identified at a fast UDMA, you then need to
again verify the array performance.  It should have climbed significantly.

Good luck.
				Peter Ashford

