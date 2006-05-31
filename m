From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: RAID5E
Date: Wed, 31 May 2006 16:27:54 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0605311626240.18452@montezuma.acc.umu.se>
References: <447D9E72.3000704@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <447D9E72.3000704@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 31 May 2006, Bill Davidsen wrote:

> Where I was working most recently some systems were using RAID5E (RAID5 with 
> both the parity and hot spare distributed). This seems to be highly desirable 
> for small arrays, where spreading head motion over one more drive will 
> improve performance, and in all cases where a rebuild to the hot spare will 
> avoid a bottleneck on a single drive.
>
> Is there any plan to add this capability?

What advantage does that have over raid6? You use exactly as many drives 
(n+2), with the disadvantage of having to do a rebuild without parity when 
a drive fails and a raid failure at a double disk failure.

/Mattias Wadenstein
