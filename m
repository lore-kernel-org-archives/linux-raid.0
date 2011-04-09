From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Using of RAID10,offset for faster writes
Date: Sat, 9 Apr 2011 17:05:14 +0200
Message-ID: <20110409150514.GA24675@www2.open-std.org>
References: <inphu9$5kl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <inphu9$5kl$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 09, 2011 at 02:03:21PM +0200, David Brown wrote:
> During a discussion about RAID in another context (a Linux newsgroup), I 
> began thinking about the speeds of the different RAID10 layouts for 
> different usages.  RAID10,far is often the fastest choice for general 
> use - you get striped reads for large reads, and access times are good 
> because you can get the data from either disk.  The disadvantage is that 
> writes involve a lot of extra head movement, as you need copies of the 
> data on two widely separated areas on the each disk.  But for general 
> use, you read a lot more often than you write, so the tradeoff is worth it.
> 
> In the discussion we were looking particularly at swap space on RAID. 
> This is a usage that requires a lot of writing, especially small writes. 
>  Using the RAID10,offset layout should give you most of the benefits of 
> RAID10,far when it comes to reading - you don't get quite as efficient 
> block reads for large reads, but you can still do a lot of striping in 
> the reads.  And writes will involve far less head movement, and so 
> should complete faster.
> 
> Has anyone tried this, or done any benchmarking?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Some tests indicate that the theoretical slower writing speed of
raid10,far tends to be minimized by the elevator algoritm for the disk.
Writes are normally just delivered to the kernel in-core buffers, and
then every 30 secs or so flushed to the disk. The elevator orders this
writing to minimize head movement. So there is almost no penalty for
writes for raid10,far. 

Anyway, for swapping the paetition siz is normally quite small, say 2 to
10 GB, and head movement is thus quite small.

Tests show that raid10,offset does not really stripe sequential reads.
Anyway it would be interesting to see tests on swapping on rid10,offset
vs raid10,far. I am not sure how to test it. But it could be load times
for eg. openoffice in a swapped state - loading a big app is one of the
areas where you would notice the speed most in a user environment. Tht
could be the reading test. For the writing test, one could operate with
a rather small swap  partition, and then load a lot of big apps.

Best regards
Keld


