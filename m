From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Fri, 22 Apr 2011 20:05:06 -0400
Message-ID: <4DB217B2.8090904@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio>	<4DB1D543.3080400@cdf.toronto.edu> <20110423081253.0a31b027@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110423081253.0a31b027@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 04/22/11 18:12, NeilBrown wrote:
> This is not correct.  RAID10-n2 on 2 drives is exactly the same layout and
> very nearly the same speed as RAID1 on 2 drives.  (I say 'very nearly' only
> because the read-balancing code is a little different and might have slightly
> different results).
>
> Or have you measured these two and found an actually difference?  That would
> certainly be interesting.

The difference that I see is probably 100% due to the different read 
balancing algorithm. When I start two dd processes reading from two 
separate partitions on the RAID (just so there are no buffers screwing 
up my results), with RAID1, I see less than one drive worth of 
sequential read speed for the two dd processes combined.

On the other hand, with RAID10 I see the two drives being utilized 
fully, and I get one drive worth of sequential read speeds for each dd 
process, or a total of two drives worth of read speed for the two dd 
processes.

The numbers were something like this:

- Single drive speed: ~130MB/s sequential read.
- Two simultaneous dd sequential reads with RAID1, bs=1024k: ~40MB/s per dd.
- Two simultaneous dd sequential reads with RAID10, bs=1024k: ~130MB/s 
per dd.

That's what I meant by better sequential reads, but perhaps I should try 
to phrase it more precisely.

> RAID10-f2 will give faster sequential reads at the cost of slower writes.

I am not sure what RAID10-f2 on a two disk setup will look like, but I 
like the idea of the drives being identical, and in the worst case, 
being able to pull one drive, zero the superblock, and be left with a 
drive with intact data, which only RAID10-n2 can give, if I am not mistaken.

Just to follow up on our discussion on Grub v2 and booting from a RAID 
device. I discovered that if I allow Grub to use UUID, occasionally, it 
would try to mount a raw device for root instead of the RAID device. 
Apart from the nuisance, this would probably cause mismatch_cnt to be 
non-zero!! (heh heh). At any rate, the guide reflects how I deal with 
that - by turning off the use of UUIDs.

Many thanks for taking a look at the guide and sharing your thoughts! 
Please let me know if you still think I should change that part where I 
say that RAID10 gives me faster sequential reads, and what you would say 
instead.

Iordan
