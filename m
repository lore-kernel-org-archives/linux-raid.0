From: "Rainer Fuegenstein" <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: resync duration ?
Date: Fri, 15 May 2009 13:16:13 +0200 (CEST)
Message-ID: <41321.81.217.58.120.1242386173.squirrel@kaneda.iguw.tuwien.ac.at>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
    <18956.50134.658843.652060@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18956.50134.658843.652060@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> As others have said, 3 hours it a reasonable ball-part for 750Gig.
> 10-12 hours is definitely longer than I would expect.
>
> Of course, if use are using the array then resync (or recovery) will
> back off and let the regular IO have priority.  So if you were
> actively using the array during the 10-12 hours resync, then it makes
> perfect sense.

That's what puzzles me: the server is used just for storage and usually
there are nearly no accesses during the 10-12h resync period. whereas
(according to your statement above) when accessing the raid with the one
new 1.5TB disk during the 3h resync period, the estimate climbs to about
1600 minutes, but drops back to 3 hours when idle again.

could this be a result of the hardware configuration ?

old 750GB disk:
  Vendor: ATA       Model: SAMSUNG HD753LJ   Rev: 1AA0
  Type:   Direct-Access                      ANSI SCSI revision: 05

new 1.5TB disk: (western digital caviar green)
  Vendor: ATA       Model: WDC WD15EADS-00R  Rev: 01.0
  Type:   Direct-Access                      ANSI SCSI revision: 05

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 127
model name      : AMD Sempron(tm) Processor LE-1200
stepping        : 1
cpu MHz         : 1800.000
cache size      : 512 KB
[...]

mainboard is an ASUS M2N with 4 onbord SATA ports.

anyway, when all the 1.5TB disks are active in the raid5, I'll simulate a
power failure and see how long the re-sync will take then.


