From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Looking for the cause of poor I/O performance
Date: Thu, 2 Dec 2004 19:49:57 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
References: <200412021138.17311.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412021138.17311.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 	My server is a K6-500 with 43MB of RAM, standard x86 hardware. The

such a machine was good in its day, but that day was what, 5-7 years ago?
in practical terms, the machine probably has about 300 MB/s of memory 
bandwidth (vs 3000 for a low-end server today).  further, it was not uncommon
for chipsets to fail to cache then-large amounts of RAM (32M was a common
limit for caches configured writeback, for instance, that would magically
cache 64M if set to writethrough...)

> OS is Slackware 10.0 w/ 2.6.7 kernel I've had similar problems with the

with a modern kernel, manual hdparm tuning is unnecessary and probably wrong.

> To tune these drives, I use:
> hdparm -c3 -d1 -m16 -X68 -k1 -A1 -a128 -M128 -u1 /dev/hd[kigca]

if you don't mess with the config via hdparm, what mode do they come up in?

> hda: WD 400JB  40GB
> hdc: WD 2000JB 200GB
> hdg: WD 2000JB 200GB
> hdi: IBM 75 GXP  120GB
> hdk: WD 1200JB 120GB

iirc, the 75GXP has a noticably lower density (and thus bandwidth).

> Controllers:
> hda-c: Onboard controller, VIA VT82C596B (rev 12)
> hdd-g: Silicon Image SiI 680 (rev 1)
> hdh-k: Promise PDC 20269 (rev 2)
> /dev/hda:  Timing buffered disk reads:   42 MB in  3.07 seconds =  13.67 MB/sec
> /dev/hdc:  Timing buffered disk reads:   44 MB in  3.12 seconds =  14.10 MB/sec

not that bad for such a horrible controller (and PCI, CPU, memory system)

> /dev/hdg:  Timing buffered disk reads:   68 MB in  3.04 seconds =  22.38 MB/sec
> /dev/hdi:  Timing buffered disk reads:   72 MB in  3.06 seconds =  23.53 MB/sec
> /dev/hdk:  Timing buffered disk reads:   66 MB in  3.05 seconds =  21.66 MB/sec

fairly modern controllers help, but not much.

> /dev/md0:  Timing buffered disk reads:   70 MB in  3.07 seconds =  22.77 MB/sec
> /dev/md1:  Timing buffered disk reads:   50 MB in  3.03 seconds =  16.51 MB/sec

since the cpu/mem/chipset/bus are limiting factors, raid doesn't help.

> I would appriciate any thoughts, leads, ideas, anything at all to point me in
> a direction here.

keeping a K6 alive is noble and/or amusing, but it's just not reasonable to 
expect it to keep up with modern disks.  expecting it to run samba well is 
not terribly reasonable.

plug those disks into any entry-level machine bought new (celeron, sempron)
and you'll get whiplash.  plug those disks into a proper server
(dual-opteron, few GB ram) and you'll never look back.  in fact,
you'll start looking for a faster network.

regards, mark hahn.

