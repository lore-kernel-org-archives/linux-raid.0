From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Sat, 4 Dec 2004 21:16:41 -0500
Message-ID: <200412050216.iB52Gk923982@www.watkins-home.com>
References: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Hahn' <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, now I am confused.
I have a second Dell Precision Workstation 410:

System A:
CPUs	2 X 500 MHz
RAM	4 X 128 Meg SDRAM
Bus	100 MHz
Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec

System B:
CPUs	2 X 1000 MHz
RAM	4 X 256 Meg Registered SDRAM
Bus	100 MHz
Timing buffer-cache reads:   524 MB in  2.00 seconds =262.00 MB/sec

Why is system B almost twice as fast?
Is registered RAM faster?
I know the CPU speed is twice as fast, but the system bus is still 100 MHz.

There are other differences I don't think would have an effect.  Video
cards, modem, SCSI cards, HW RAID card, USB mouse.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Saturday, December 04, 2004 6:51 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: RE: Looking for the cause of poor I/O performance

> Timing buffer-cache reads:
> 128 MB in 11.18 seconds = 11.45 MB/sec
...
> 
> Timing buffered disk reads:
> 64 MB in  9.42 seconds =  6.79 MB/sec
...
> 
> This is from a single disk:
> Timing buffer-cache reads:   128 MB in  0.87 seconds =147.13 MB/sec
> Timing buffered disk reads:  64 MB in  3.51 seconds = 18.23 MB/sec

excellent!  this is really a great example of how a machine's limited
internal bandwidth infringes on your raid performance.

running hdparm -T shows that your machine can manage about 150 MB/s
when simply doing a syscall, copying bytes to userspace, and returning.
no involvement of any IO device.  this number is typically about half
the user-visible dram bandwidth as reported by the stream benchmark.

when you try to do parallel IO (either with a bunch of hdparm -t's 
or with raid), each disk is desperately trying to write to dram
at about 18 MB/s, ignoring other bottlenecks.  alas, we already know 
that your available dram bandwidth is much lower than 14*18.

for comparison, a fairly crappy SiS 735-based k7 system with 
64b-wide PC2100 can deliver maybe 1.2 GB/s dram bandwidth.
hdparm -T is about 500 MB/s, and would probably have trouble
breaking 200 MB/s with raid0 even if it had enough buses.

an older server of mine is e7500-based, dual xeon/2.4's, with 
2xPC1600 ram.  it sustains about 1.6 GB/s on Stream, and about 
500 MB/s hdparm -T, and can sustain 250 MB/s through it's 6-disk
raid without any problem.

a newish server (dual-opteron, 2xPC2700) gives 1.4 GB/s under 
hdparm -T, and I expect it could hit 600 MB/s without much trouble,
if given 10-12 disks and pcix (or better) controllers...

regards, mark hahn.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

