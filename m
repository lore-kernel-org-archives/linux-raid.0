From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 15:03:31 -0500
Message-ID: <200412031503.32130.systemloc@earthlink.net>
References: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	My server is a K6-500 with 43MB of RAM, standard x86 hardware. The
>
> such a machine was good in its day, but that day was what, 5-7 years ago?
> in practical terms, the machine probably has about 300 MB/s of memory
> bandwidth (vs 3000 for a low-end server today).  further, it was not
> uncommon for chipsets to fail to cache then-large amounts of RAM (32M was a
> common limit for caches configured writeback, for instance, that would
> magically cache 64M if set to writethrough...)

Bah. As much as I had hoped to squeeze more out of this box, I think you have 
a pretty solid point. I tried out doing a quick hdparm -tT on all of the 
drives, using the same OS on the newer Athlon box I described. I got much 
better numbers. I included the output below.

> > OS is Slackware 10.0 w/ 2.6.7 kernel I've had similar problems with the
>
> with a modern kernel, manual hdparm tuning is unnecessary and probably
> wrong.
>
> > To tune these drives, I use:
> > hdparm -c3 -d1 -m16 -X68 -k1 -A1 -a128 -M128 -u1 /dev/hd[kigca]

I also checked out what hdparm showed for default settings without modifying 
them on boot, both on the Athlon, and on the K6. In the case of the Athlon, 
you're right, performance suffered from my tuning. In the case of the K6, I 
saw no noticeable difference. 

It's interesting that on the Athlon, one controller was set to -c1 by default, 
while on the K6, the same controller with the same drives is set to -c0 by 
default by the exact same kernel. I'm at a loss for how this is determined 
and why..

> if you don't mess with the config via hdparm, what mode do they come up in?

I included this for both machines.

I think I will concentrate on tweaking the PCI settings to see if I can't get 
a bit more out of that bus and check for any noticable improvements in 
throughput. I'm hoping that this still may be related to some sort of PCI 
latency issue.

TJ Harrell
_______________________________________________________________________

Default settings on the Athlon:

75 GXP:
 Timing buffer-cache reads:   1124 MB in  2.01 seconds = 560.12 MB/sec
 Timing buffered disk reads:  108 MB in  3.02 seconds =  35.74 MB/sec

WD 1200:
 Timing buffer-cache reads:   1116 MB in  2.00 seconds = 556.69 MB/sec
 Timing buffered disk reads:  108 MB in  3.05 seconds =  35.43 MB/sec

WD 2000:
 Timing buffer-cache reads:   1092 MB in  2.01 seconds = 544.45 MB/sec
 Timing buffered disk reads:  106 MB in  3.00 seconds =  35.32 MB/sec

WD 400:
 Timing buffer-cache reads:   1084 MB in  2.01 seconds = 540.46 MB/sec
 Timing buffered disk reads:  122 MB in  3.02 seconds =  40.42 MB/sec

WD 2000:
 Timing buffer-cache reads:   1140 MB in  2.00 seconds = 569.52 MB/sec
 Timing buffered disk reads:  112 MB in  3.01 seconds =  37.19 MB/sec

Defaults on the K6:

/dev/hda:
 multcount    =  0 (off)
 IO_support   =  1 (32-bit)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 65535/16/63, sectors = 78165360, start = 0

/dev/hdc:
 multcount    =  0 (off)
 IO_support   =  1 (32-bit)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 24321/255/63, sectors = 390721968, start = 0

dev/hdg:
 multcount    =  0 (off)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 24321/255/63, sectors = 390721968, start = 0

/dev/hdi:
 multcount    =  0 (off)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 16383/255/63, sectors = 234441648, start = 0

/dev/hdk:
 multcount    =  0 (off)
 IO_support   =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 65535/16/63, sectors = 90069840, start = 0
