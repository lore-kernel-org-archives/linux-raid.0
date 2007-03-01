From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Growing a raid 6 array
Date: Thu, 1 Mar 2007 18:14:31 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0703011813580.11515@p34.internal.lan>
References: <45E72549.2080108@unix-scripts.info> <Pine.LNX.4.64.0703011728270.7560@p34.internal.lan>
 <45E75D03.2050906@unix-scripts.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E75D03.2050906@unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@unix-scripts.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 2 Mar 2007, Laurent CARON wrote:

> Justin Piszcz wrote:
>> You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.
>
>
>> From the man page:
>
> Grow   Grow (or shrink) an array, or otherwise reshape it in some way.
> Currently supported growth options including changing the active size of
> component devices in RAID level 1/4/5/6 and changing the number of
> active devices in RAID1.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Interesting, give it a try? :)  The kernel says raid-5 only.

   x x    [*]     RAID-4/RAID-5/RAID-6 mode
   x x    [*]       Support adding drives to a raid-5 array

   x CONFIG_MD_RAID5_RESHAPE:                                                x
   x                                                                         x
   x A RAID-5 set can be expanded by adding extra drives. This               x
   x requires "restriping" the array which means (almost) every              x
   x block must be written to a different place.                             x

