From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: Looking for the cause of poor I/O performance
Date: Sat, 4 Dec 2004 18:51:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
References: <200412041759.iB4HxG922078@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412041759.iB4HxG922078@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

