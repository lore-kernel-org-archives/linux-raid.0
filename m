From: Robert Kierski <rkierski@cray.com>
Subject: RE: RAID 5,6 sequential writing seems slower in newer kernels
Date: Mon, 7 Dec 2015 14:18:53 +0000
Message-ID: <F7761B9B1D11B64BBB666019E9378117FE0BAA@CFWEX01.americas.cray.com>
References: <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
 <565F136F.2090709@turmel.org>
 <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
 <566059E8.60804@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDE157@CFWEX01.americas.cray.com>
 <20151204185155.GA3590@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151204185155.GA3590@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Phil Turmel <philip@turmel.org>, Dallas Clement <dallas.a.clement@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I re-ran the test using buffered IO, with both XDD and FIO.  Except that I was using XDD and FIO, the tests were essentially the same -- TC=4, QD=1, BS=1M, DIR=Write, Order=SEQ.

I've switched to using spinning disks, since several people on this list indicated that using DDR Disk devices with it's ultra low latency could cause unintended behavior in RAID6.  My theoretical MAX TP is 1080 - 1620 MB/s for 6 HDD's that each have a TP of about 270 MB/s on the outer edge.  My SAS infrastructure is such that I shouldn't have a problem achieving the Theoretical MAX, when testing on the outer edge.

With Buffered IO...

FIO reported a sustained TP of 2200 MB/s.  As this is well above the theoretical MAX, I didn't trust it.  I ran the same test with XDD.  It reported a TP of 570 MB/s.  When I watched the system via vmstat and iostat while running both of these tests, both tools indicated that I was doing about 570 MB/s while running both XDD and FIO.  So there must be something wrong in the way FIO is calculating TP when using buffered IO.

When running both FIO and XDD using direct IO, I was able to get much better performance (about 1040 MB/s) with the above paramaters (TC=4, QD=1, BS=1M, DIR=Write, Order=SEQ).  I am able to confirm that TP using vmstat and iostat.

While running with both Buffered-IO and Direct-IO, I watched the IO's in both iostat and vmstat and can confirm that there weren't any reads, which means there wasn't any Read-Modify-Write going on in either case.

As I am getting nearly the theoretical MAX, one might think there isn't a problem.  However, when I increase TC to 5, my TP is only 750 MB/s.  When I increase TC to 32, my TP is about 250 MB/s.  While you may conclude that 32 threads is overwhelming the system, 5 threads shouldn't be overwhelming a system that has 12 core.  When you consider that I get MAX TP with 4 threads, the fact that I get  a 25% reduction by adding one thread is a problem.

Bob Kierski
Senior Storage Performance Engineer
Cray Inc.
380 Jackson Street
Suite 210
St. Paul, MN 55101
Tele: 651-967-9590
Fax:  651-605-9001
Cell: 651-890-7461

