From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 13:38:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0304031334070.20118-100000@multivac.sdsc.edu>
References: <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0304032104070.3085@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Stephan,

> here benchmark from my system with an fasttrak-tx4 (same card jonathan
> has) with WD1800BB :

The WD1800BB and the WD1200BB use the same technology (same data density,
fewer platters).  The streaming speed should be very similar.

> /dev/hde:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  1.37 seconds = 46.72 MB/sec
>
> WD1800BB on onboard ultra100 controller :
>
> /dev/hdo:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  1.58 seconds = 40.51 MB/sec
>
> WD1800BB on onboard ultra33 controller :
>
> /dev/hda:
>  Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
>  Timing buffered disk reads:  64 MB in  2.55 seconds = 25.10 MB/sec

OK.  We've found a potential issue.  Are the disks being identified as
UDMA-33 or UDMA-66/100/133?  The performance numbers agree too closely for
this to be a coincidence.  Check the boot logs.

Good luck.
				Peter Ashford
