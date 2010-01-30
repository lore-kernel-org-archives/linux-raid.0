From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature suggestion to handle read errors during re-sync of
 raid5
Date: Sat, 30 Jan 2010 22:33:03 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6482BD.6090102@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Jan 2010, John Robinson wrote:

> I think the problem is that modern discs haven't got more reliable, but they 
> have got much, much bigger; "modern" 2G discs had a read error rate of 1 bit 
> per 10^14, and current 2T discs have the same, so while on a 2G disc you 
> could read the whole surface of the disc tens of thousands of times before 
> being likely to get a read error, now it's only tens of times. Someone did 
> recently post links to a formal article analysing this subject to this list, 
> but I can't find it :-(

I think the 4k sector size on WD20EARS (for instance) is supposed to add 
more ECC information but I'm not sure how this will affect the 10^14 error 
rate. I think the manufacturers need to work a bit more on it, I don't see 
how these drives can be used in single drive configuration with the 
current 10^14 value.

I don't have experience with any other drives than the WD20EADS but they 
develop read errors at a rate higher than any other drive I've 
experienced before (and I started doing computer stuff in the 80ties). 
Yes, the large size is absolutely a factor, so the per-block read error 
rate might not be too high, but the read error per drive is definitely so 
(and I use the default ubuntu behaviour and read scrub every week).

I'm going RAID6 as soon as I can because of this, I'm tired of this 
bit-rot when I ddrescue things because of this (hopefully it's just 4k of 
data in the middle of a file which I care little about).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
