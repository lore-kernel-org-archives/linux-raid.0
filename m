From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: How do people deal with disk size variations?
Date: Wed, 13 May 2009 09:05:34 -0400
Message-ID: <4A0AC59E.7020808@tmr.com>
References: <4A0A89DE.4070502@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0A89DE.4070502@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> I have a 5-disk raid5. I notice that the five identical disks, which also
> list identical LBA numbers on the label, do not show the same size when
> queried. One is reporting (smart - it should tell the truth from the disk
> pov) a smaller size.
>
> One disk reports
>     User Capacity: 1,000,203,804,160 bytes
> and the other four
>     User Capacity: 1,000,204,886,016 bytes
>
> Luckily I always build a raid on partitions so this difference is
> irrelevant being in the slack past the partition end.
>
If a drive is advertised as a certain size and isn't as least that big I 
think you have a return. But as for "bonus bytes" you take what you get. 
In many cases recently I have found drives are even larger than claimed, 
with extra capacity blocked using the hpa. In those cases you can reset 
the hpa if you dare (the extra may not be good, that's why it was 
downsized). Using space you unblock is like overclocking, sometimes you 
get performance for free and sometimes you get a learning experience.

Note that downsizing to a given size using the hpa will allow you to run 
"whole disk" arrays without the issues you mention. I have never seen a 
benefit to do so, but I know people who do it.
> However, if I managed to use the whole disk, the raid will be as large as
> the smallest disk. What happens when I replace a disk and get an even
> smaller replacement one?
>
> Do people always leave unused space at the end? Do you expect disks from
> the same exact model to have exactly the same usable size?
>
> BTW, even if the label gave the correct size, one does not know in
> advance what will arrive when you order a disk, right?
>
> cheers
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


