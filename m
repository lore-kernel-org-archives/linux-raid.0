From: "Jonathan Vardy" <jonathanv@explainerdc.com>
Subject: Re: RAID 5 performance problems
Date: Fri, 4 Apr 2003 00:09:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00bf01c2fa2d$afafedd0$2e77c23e@pentium4>
References: <Pine.GSO.4.30.0304031334070.20118-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Peter L. Ashford" <ashford@sdsc.edu>, Stephan van Hienen <raid@a2000.nu>
Cc: Jonathan Vardy <jonathan@explainerdc.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> OK.  We've found a potential issue.  Are the disks being identified as
> UDMA-33 or UDMA-66/100/133?  The performance numbers agree too closely for
> this to be a coincidence.  Check the boot logs.

I looked into /var/log/dmesg and found this:

blk: queue c0393144, I/O limit 4095Mb (mask 0xffffffff)
hda: 39062500 sectors (20000 MB) w/2048KiB Cache, CHS=2431/255/63, UDMA(33)
blk: queue c03934a8, I/O limit 4095Mb (mask 0xffffffff)
hdc: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c039380c, I/O limit 4095Mb (mask 0xffffffff)
hde: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0393b70, I/O limit 4095Mb (mask 0xffffffff)
hdg: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0393ed4, I/O limit 4095Mb (mask 0xffffffff)
hdi: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)
blk: queue c0394238, I/O limit 4095Mb (mask 0xffffffff)
hdk: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=232581/16/63,
UDMA(33)

This is what you meant?

but after the boot I set hdparm manually for each drive with the following
settings:

hdparm -a8 -A1 -c1 -d1 -m16 -u1 /dev/hdc.

