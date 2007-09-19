From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Wed, 19 Sep 2007 10:49:56 -0700 (PDT)
Message-ID: <20070919174956.9497310209D@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
 <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
 <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> (message from
	Justin Piszcz on Wed, 19 Sep 2007 04:38:22 -0400 (EDT))
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
: One of the 5-10 tuning settings:
: 
: blockdev --getra /dev/md0
: 
: Try setting it to 4096,8192,16384,32768,65536
: 
: blockdev --setra 4096 /dev/md0
: 
:

I discovered your January correspondence to the list about this.  Yes,
the read-ahead length makes a dramtic difference---for sequential data
reading.  However, in doing some further study on this parameter, I
see that random access is going to suffer.  Since I had intended
to build an LVM on this RAID 5 array and put a full linux system on
it, I'm not sure that large read-ahead values are a good idea.

: Also, with a 3-disk raid5 that is the worst performance you can get using 
: only 3 disks

I don't know why (for reads) I should suffer such bad performance.
According to all I've read, the system is not even supposed to read
the parity data on reads.  So why do I not get near RAID 0 speeds w/o
having to increase  the Read-ahead value?

: , while with a 10 disk raid5 it'd be closer to 90%.  Reads you 
: should get good speeds, but for writes-- probably not.

When you say "reads you should get good speeds" are you referring
to the aforementioned 10 disk RAID 5 or my 3 disk one?

: Then re-benchmark.

Large Read-ahead nearly double the speed of 'hdparm -t'.  (So does
simply using the "--direct" flag.  Can you explain this?)  Also, in
your opinion, is it wise to use such large read-aheads for a RAID 5
intended for the use to which I plan to put it?

Aside: I have found RAID quite frustrating.  With the original two
disks I was getting 120-130 MB/s in RAID 0.  I would think that for
the investment of a 3rd drive I ought to get the modicum of
redundancey I expect and keep the speed (at least on reads) w/o
sacrificing anything.  But it appears I actually lost something for my
investment.  I'm back to the speed of single drives with the modicum
of redundancey that RAID 5 gives.  Not a very good deal.

Dean
