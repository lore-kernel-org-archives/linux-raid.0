From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Sat, 4 Dec 2004 12:59:11 -0500
Message-ID: <200412041759.iB4HxG922078@www.watkins-home.com>
References: <200412041023.35945.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412041023.35945.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'TJ' <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My disks...
My system has 14 disk drives.  At 65Meg per second they are only doing about
5 meg per second each.  6 of the disks are on a 40MB/second SCSI bus, this
limits my overall speed.  During a re-sync I get about 6 Meg/second per
disk.

My system...
2 CPUs help.  It's a Dell.  :)  It is what they call a workstation.  The
chipset is Intel 440BX (going from memory, so not 100% sure).  In its day it
was a high end system.  It has SD ram.  100 Mhz system bus.  All memory
slots are full with the same size DIMMs, so it can interleave if the chipset
supports that.  The chipset has 3 PCI buses.  Since my overall speed is not
exceeding the speed of 1 PCI bus, I don't think this helps me, but maybe it
does.  Everything is SCSI, I don't know if that helps.  My disks are on 3
different SCSI busses, 2 Adaptec cards and 1 built-in Adaptec chipset.

This may help, it is a Dell Precision Workstation 410.
http://support.dell.com/support/edocs/systems/deqkmt/specs.htm

If my system is so much faster because of the motherboard design, then cool!
I did not know motherboard design could make such a difference.

The test "hdparm -tT /dev/md2" used about 35% of both CPU's.  The test is so
quick it is hard to be sure about the cpu load.  I have 17 disks overall, so
I tried hdparm of all of my disks at the same time.  This uses 100% of my
CPUs.  I don't understand how this can report such high speeds on my 6 disks
on the slow SCSI bus.
Timing buffer-cache reads:
128 MB in 11.18 seconds = 11.45 MB/sec
128 MB in 11.03 seconds = 11.60 MB/sec
128 MB in 10.97 seconds = 11.67 MB/sec
128 MB in 10.91 seconds = 11.73 MB/sec
128 MB in 11.43 seconds = 11.20 MB/sec
128 MB in 11.37 seconds = 11.26 MB/sec
128 MB in 11.35 seconds = 11.28 MB/sec
128 MB in 11.37 seconds = 11.26 MB/sec
128 MB in 11.45 seconds = 11.18 MB/sec
128 MB in 11.97 seconds = 10.69 MB/sec
128 MB in 11.78 seconds = 10.87 MB/sec
128 MB in 11.99 seconds = 10.68 MB/sec
128 MB in 12.26 seconds = 10.44 MB/sec
128 MB in 12.18 seconds = 10.51 MB/sec
128 MB in 11.84 seconds = 10.81 MB/sec
128 MB in 11.84 seconds = 10.81 MB/sec
128 MB in 12.43 seconds = 10.30 MB/sec

Timing buffered disk reads:
64 MB in  9.42 seconds =  6.79 MB/sec
64 MB in  9.62 seconds =  6.65 MB/sec
64 MB in  9.95 seconds =  6.43 MB/sec
64 MB in  9.71 seconds =  6.59 MB/sec
64 MB in 10.17 seconds =  6.29 MB/sec
64 MB in 11.00 seconds =  5.82 MB/sec
64 MB in 11.45 seconds =  5.59 MB/sec
64 MB in 10.81 seconds =  5.92 MB/sec
64 MB in 11.20 seconds =  5.71 MB/sec
64 MB in 11.57 seconds =  5.53 MB/sec
64 MB in 10.89 seconds =  5.88 MB/sec
64 MB in 11.73 seconds =  5.46 MB/sec
64 MB in 11.27 seconds =  5.68 MB/sec
64 MB in 11.20 seconds =  5.71 MB/sec
64 MB in 12.18 seconds =  5.25 MB/sec
64 MB in 11.41 seconds =  5.61 MB/sec
64 MB in 11.91 seconds =  5.37 MB/sec

This is from a single disk:
Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec
Timing buffered disk reads:  64 MB in  3.51 seconds = 18.23 MB/sec

When I test a single disk, they all perform about the same.

A single disk "buffer-cache" performs better than any of my SCSI buses.  I
have 2 at 80 Meg/sec and 1 at 40 Meg/sec.  The speed exceeds the speed of
the PCI bus.  Ok, I understand.  I was thinking buffer-cache was the disk
drive's on-board cache, but buffer-cache is the Linux disk cache.  I think!
Now I wonder why it is so slow!  :)

Anyway, I hope I gave you too much information!  :)

Guy

-----Original Message-----
From: TJ [mailto:systemloc@earthlink.net] 
Sent: Saturday, December 04, 2004 10:24 AM
To: linux-raid@vger.kernel.org
Cc: Guy
Subject: Re: Looking for the cause of poor I/O performance

On Thursday 02 December 2004 10:54 pm, Guy wrote:
> My linux system is a P3-500 with 2 CPUs and 512 Meg RAM.  My system is
much
> faster than my network.  I don't know how your K6-500 compares to my
> P3-500. 

> My array gives about 60MB /second.

Now I'm extremely curious to know why your box does so much better than
mine. 
Does the bus run at 100? 133? I'm guessing it's SDRAM, not DDR. Also, does
it 
have a stock PCI bus, or something special?

TJ Harrell

