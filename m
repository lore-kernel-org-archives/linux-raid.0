From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 16:00:03 +0800
Message-ID: <dqksi3$mf2$5@sea.gmane.org>
References: <dqkie5$mf2$3@sea.gmane.org> <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>> They seem to suggest RAID 0 is faster for reading than RAID 1, and I 
>> can't figure out why.
> 
> with R0, streaming from two disks involves no seeks;
> with R1, a single stream will have to read, say 0-64K from the first disk,
> and 64-128K from the second.  these could happen at the same time, and 
> would indeed match R0 bandwidth.  but with R1, each disk has to seek past
> the blocks being read from the other disk.  seeking tends to be slow...

Ah, a good way of putting it...I think I was pretty much there with my 
followup message.

Still, it seems like it should be a solvable problem...if you order the 
data differently on each disk; for example, in the two disk case, 
putting odd and even numbered 'stripes' on different platters [or sides 
of platters].

> 
>> Clearly, the write performance is worse for RAID 1 than RAID 0 since 
>> with RAID 1 that data you are writing at the same time is the same for 
>> both drives;
> 
> the cost for doing the double writes in R1 is not high, unless you've 
> already got a bottleneck somewhere that limits you to talking to one disk
> at a time.  for instance, R1 to a pair of disks at 50 MB/s apiece is 
> basically trivial for a decent server, since it's about 1% of memory
> bandwidth, and a smallish fraction of even plain old 64x66 PCI.
> 
>> array has more than two disks, that would make RAID 1 *faster* than RAID 0.
> 
> R1 is not going to be faster than R0 on the same number of disks.

Yeah, I think I see that now.

Thanks.

Max.

> 
> regards, mark hahn.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

