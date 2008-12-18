From: "David Lethe" <david@santools.com>
Subject: RE: upgrade advice / Disk drive failure rates - real world
Date: Thu, 18 Dec 2008 13:14:27 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C0314BCDA@34093-C3-EVS3.exchange.rackspace.com>
References: <d5fe39840812160310t45e822c1geb633f805cf5388e@mail.gmail.com> <1229428184.22331.43.camel@localhost> <alpine.DEB.1.10.0812160807200.725@p34.internal.lan> <1229436950.22331.45.camel@localhost> <cccedfc60812160757x2af73afbv4a69eac31d212062@mail.gmail.com> <alpine.DEB.1.10.0812161829490.31132@p34.internal.lan> <cccedfc60812161608y29e6c645n6ff7df5c87292374@mail.gmail.com> <1229497160.22331.73.camel@localhost> <cccedfc60812170526l43c661ddgff95c99ea883f362@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C030D4837@34093-C3-EVS3.exchange.rackspace.com> <cccedfc60812170637j7eab2c4cyac88fc110b51755f@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C030D48CC@34093-C3-EVS3.exchange.rackspace.com> <494A7C61.6080805@anonymous.org.uk> <alpine.DEB.1.10.0812181140260.28725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0812181140260.28725@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> Sent: Thursday, December 18, 2008 10:43 AM
> To: John Robinson
> Cc: David Lethe; Linux RAID
> Subject: Re: upgrade advice
> 
> 
> 
> On Thu, 18 Dec 2008, John Robinson wrote:
> 
> > On 17/12/2008 15:30, David Lethe wrote:
> >> The duty cycle makes a difference now, but wasn't a design point
> until
> > [...]
> >> OK, off my soapbox ... back to work writing disk diagnostic
software
> for
> >> my OEM customers
> >
> > I am going to print that message, frame it and hang it on the wall.
> > (Including the bit I elided with ...)
> >
> > I'll probably keep using desktop drives for domestic NAS, though.
> I think it also depends on how often drives are used and what type of
> workloads they are exposed to, for a domestic NAS for mainly
sequential
> file writes/reads, they will probably be OK-- I have a few SW RAID5's
> on
> desktop drives but I use them primarily as storage via rsync, once a
> week
> or month I am not constantly read/writing on them-- on a daily basis.
> Is
> that how you use your NAS as well?  Or?
> 

Surprisingly, the failure rates for consumer class ATA disks are
counterintuitive.
Breaking down into raw low,medium,high utilization ... this is what the
study of 100,000 disks
Revealed over 5 year period. (Rounded results, all in percentage)

DISK AGE      LOW   MED  HIGH (utilization)
 3 months      4     2    10
 6 mos         2     1     4
12 mos         .5    1     2
2  years       2     2     2
4  years       3    4      4
5  years       1    1      5

So, if you pound a disk with I/O then it is 5x more likely to die in
first 3 months then
if it has light duty load.   If a disk survives the first year, then
load doesn't make much of
a statistical difference ... until it approaches the 5 year mark.

Note, these are for consumer class disks, that were better products back
in 2000 when the study began.
There are no long-term studies for real-world drive life for the (SATA)
consumer vs. enterprise disk drives that are made today.   The study
involved 9 different disks, Seagate, Hitachi, WD, etc.   that were
typical of what you got with a personal computer from manufacturer, or
you bought at a PC store.   The test is as real-world as they come.

As for drive temperature vs. failure rate, this will blow you away.

The probability density curve is logarithmic in nature, so disks at 20
degrees C are 3X more likely to fail for any given load then disks at 26
degrees C.   Once you hit 26 degrees then the curve really flattens out.
Not much of a difference between 30-45 degrees.   Sweet spot is 36-42
degrees.  Colder disks are 6x more likely to fail then ones running
around 40 deg.

So don't throw money away on disk drive coolers/fans, unless temp
without them is in the 45 deg C range!

There is more correlation between failure rates of drives when both age
and temperature are considered.   The highlight that disks running
colder than the sweet spot are 2-3x more likely to die in first 3 months
then ones running near 40 deg.  (AFR is 9% for coldest disks, 3% for
warmest disks).


From 6 mos to 2 years, drive temp becomes less of a factor, with AFR of
cold disks around 4%, sweet-spot disks 2%.
Year 3, however is the killer, where everything changes...
AFR of cold-warm disks approx 6 %, AFR of the disks from 35-40 deg is
11%.

So aggregate walk-away
 - Keep disks in 36-42 degrees C for maximum life up to year 2, where
they should be run cooler.
 - New disks are 5x more likely to die in first 3 months with high vs.
low workload.
 - AFR and temperature become less important after the 3-month burn-in,
but this all changes in year 3.

David @ santools.com



