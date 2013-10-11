From: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Fri, 11 Oct 2013 13:00:09 +0200
Message-ID: <20131011110009.GB21439@telegraafnet.nl>
References: <20131009123135.GT1779@bitfolk.com>
 <5257B9DF.9010000@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5257B9DF.9010000@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Fri, Oct 11, 2013 at 10:42:07AM +0200, David Brown wrote:
> Then for each pair of SSD, make a triple mirror with the two SSD's, and
> a "write-mostly" hard disk raid partition.  All writes will be then get
> an extra copy on the hard disk, while reads will always come from the
> SSD's, and therefore be at the same low latency and high speed as
> before, and will not use up the HD's bandwidth on reads.  And if both
> your SSD's die, you have the extra copy on the hard disk.  It will run
> like treacle, but it will run.

I've done that and found some bugs. Neil has already fixed that
btw :-).
Write-mostly with a write-behind works mostly correct, all O will
be lagging waiting for the disk to catch up, but reads are really
really fast. In our case we had a single hard disk paired with a
single SSD. The blade could not hold more and we were not
confident enough with SSD. Well, if the SSD breaks, so does your
server, but then of high load ;-). (Actually the server doesn't
break, but your application will).

Personally I would try a raid-1 with two different manufacturers
SSD (or some brands you have really tested under continuous high
load), bcache and then the old array.
And I mean try: as in have a redundant setup.
