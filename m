From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Issue with md and 4K sector alignment
Date: Fri, 7 Sep 2012 08:19:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209070804500.13902@uplift.swm.pp.se>
References: <5031556B.5050706@averageurl.com> <alpine.DEB.2.00.1208200735020.27104@uplift.swm.pp.se> <5031E72B.8060002@hesbynett.no> <504908CC.2030400@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504908CC.2030400@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Brown <david.brown@hesbynett.no>, Kyle Brantley <kyle@averageurl.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Sep 2012, H. Peter Anvin wrote:

> This is one advantage with superblock 1.0 -- the alignment of the 
> underlying device is preserved since the metadata is at the end.

This whole problem becomes quite complicated when one starts to take into 
account the whole block device stack, for instance 
drives->md->crypto->lvm->fs, when one wants to get the filesystem to 
understand where an md complete RAID6 stride (?) starts and ends, 
especially when this changes over time when drives are being added at a 
later date, or the LV being moved around, even when the filesystem is 
mounted.

I don't know how hard it would be to add infrastructure for an fs to find 
out this underlying information through all these layers, and if there is 
interest in doing so? I have just gotten accustomed to seeing 
approximately 10% reads when I do file writing to my RAID6. I tried to 
align it from the beginning, but now I just try to make sure it's 4k 
aligned (which is not hard, since I don't use partitions and cryptsetup, 
md and lvm are all 4k aligned already). I suspect that xfs doesn't 
correctly understand even where my 64k stripe size starts and ends even 
though I tried to align it, but it does know my stripe size, but I suspect 
that since I have added drives over time, xfs first block isn't aligned 
with the start of an even 1:st stripe location (so even though it knows 
that a complete stride set is X drives and Y k per stripe, this isn't 
correctly aligned to 1:st drive, so a complete stride write from xfs would 
span two different md strides).

PS. I am not sure I got the stripe/stride wording correct here, hope it 
can still be understood what I mean.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
