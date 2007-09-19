From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help: very slow software RAID 5.
Date: Wed, 19 Sep 2007 14:25:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0709191425440.27758@p34.internal.lan>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
 <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
 <20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
 <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>
 <20070919174956.9497310209D@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070919174956.9497310209D@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 19 Sep 2007, Dean S. Messing wrote:

> Justin Piszcz wrote:
> : One of the 5-10 tuning settings:
> :
> : blockdev --getra /dev/md0
> :
> : Try setting it to 4096,8192,16384,32768,65536
> :
> : blockdev --setra 4096 /dev/md0
> :
> :
>
> I discovered your January correspondence to the list about this.  Yes,
> the read-ahead length makes a dramtic difference---for sequential data
> reading.  However, in doing some further study on this parameter, I
> see that random access is going to suffer.  Since I had intended
> to build an LVM on this RAID 5 array and put a full linux system on
> it, I'm not sure that large read-ahead values are a good idea.
>
> : Also, with a 3-disk raid5 that is the worst performance you can get using
> : only 3 disks
>
> I don't know why (for reads) I should suffer such bad performance.
> According to all I've read, the system is not even supposed to read
> the parity data on reads.  So why do I not get near RAID 0 speeds w/o
> having to increase  the Read-ahead value?
>
> : , while with a 10 disk raid5 it'd be closer to 90%.  Reads you
> : should get good speeds, but for writes-- probably not.
>
> When you say "reads you should get good speeds" are you referring
> to the aforementioned 10 disk RAID 5 or my 3 disk one?
>
> : Then re-benchmark.
>
> Large Read-ahead nearly double the speed of 'hdparm -t'.  (So does
> simply using the "--direct" flag.  Can you explain this?)  Also, in
> your opinion, is it wise to use such large read-aheads for a RAID 5
> intended for the use to which I plan to put it?
>
> Aside: I have found RAID quite frustrating.  With the original two
> disks I was getting 120-130 MB/s in RAID 0.  I would think that for
> the investment of a 3rd drive I ought to get the modicum of
> redundancey I expect and keep the speed (at least on reads) w/o
> sacrificing anything.  But it appears I actually lost something for my
> investment.  I'm back to the speed of single drives with the modicum
> of redundancey that RAID 5 gives.  Not a very good deal.
>
> Dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Did you try increasing the readahead and benchmarking?  You can set it 
back to what it was when you are done.

Justin.
