From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 13:20:44 +0800
Message-ID: <dqkj7c$mf2$4@sea.gmane.org>
References: <dqkie5$mf2$3@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqkie5$mf2$3@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah, it's something to with RAID1 drives having to skip blocks that are 
read from the other drives, right?

i.e., it's about the head having to move further, instead of to just the 
next block? I suppose that's only important for sequential reads, and it 
would be 'fixed' to some extent by the drives' cache...

Max.

Max Waterman wrote:
> Hi,
> 
> I've been reading a bit about RAID 1 vs RAID 0 on these pages :
> 
> <http://www.pcguide.com/ref/hdd/perf/raid/levels/single_Level1.htm>
> 
> They seem to suggest RAID 0 is faster for reading than RAID 1, and I 
> can't figure out why.
> 
> Clearly, the write performance is worse for RAID 1 than RAID 0 since 
> with RAID 1 that data you are writing at the same time is the same for 
> both drives; but for reading, why can't the two drives be read as if 
> they were a stripe.
> 
> You could even read the stripe in any 'direction'...when the RAID 1 
> array has more than two disks, that would make RAID 1 *faster* than RAID 0.
> 
> ie
> 
> RAID 0
> file is like this
> 0 1 2 3 4
> 
> can only be read in that order :
> 0 1 2 3 4 but
> 
> RAID 1
> file is like this
> A B C D E
> ---------
> 0 0 0 0 0
> 1 1 1 1 1
> 2 2 2 2 2
> 3 3 3 3 3
> 4 4 4 4 4
> 
> can be read as
> A B C D E
> 0
>   1
>     2
>       3
>         4
> 
> or
> 1
>   0
>     3
>       4
>         2
> 
> or whatever...
> 
> Could it not help with small files and when not streaming?
> 
> Am I missing something?
> 
> Max.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

