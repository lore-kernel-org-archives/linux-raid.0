From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Fri, 11 Oct 2013 10:42:07 +0200
Message-ID: <5257B9DF.9010000@hesbynett.no>
References: <20131009123135.GT1779@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131009123135.GT1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/10/13 14:31, Andy Smith wrote:
> Hello,
> 
> Due to increasing load of random read IOPS I am considering using 8
> SSDs and md in my next server, instead of 8 SATA HDDs with
> battery-backed hardware RAID. I am thinking of using Crucial m500s.
> 
> Are there any gotchas to be aware of? I haven't much experience with
> SSDs.
> 
> If these were normal HDDs then (aside from small partitions for
> /boot) I'd just RAID-10 for the main bulk of the storage. Is there
> any reason not to do that with SSDs currently?
> 
> I think I read somewhere that offline TRIM is only supported by md
> for RAID-1, is that correct? If so, should I be finding a way to use
> four pairs of RAID-1s, or does it not matter?
> 
> Any insights appreciated.
> 
> Cheers,
> Andy


If you are worried about the reliability of the SSDs, then one
possibility is to throw a couple of HD's into the mix.  I've never done
this, but I think it should work.

Set up a couple of hard disks, capacity at least 8 times an SSD, in a
raid1 pair.  Partition the raid1 into 8 partitions of SSD size.

Then for each pair of SSD, make a triple mirror with the two SSD's, and
a "write-mostly" hard disk raid partition.  All writes will be then get
an extra copy on the hard disk, while reads will always come from the
SSD's, and therefore be at the same low latency and high speed as
before, and will not use up the HD's bandwidth on reads.  And if both
your SSD's die, you have the extra copy on the hard disk.  It will run
like treacle, but it will run.

If you find that the harddisk pair is a bottleneck on write speeds, you
can add a write-intent bitmap to the raid1 sets and enable
"write-behind".  Then writes will be "completed" when the data is on
both SSD's - the writes to the harddisk are queued and will complete
when time allows.  This will greatly reduce the latency on writes, but
of course it means that if the SSD's die while there are pending HD
writes in the queue, the filesystem and applications will think data is
safe on the disk even though it is not yet there.  Only you can decide
the balance here.


