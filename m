From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Metadata upgradable?
Date: Wed, 2 Jul 2008 16:25:06 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807021624150.5339@p34.internal.lan>
References: <486BD0DC.6030104@are-b.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <486BD0DC.6030104@are-b.org>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver <oliver@are-b.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 2 Jul 2008, Oliver wrote:

> Hi,
>
> I've made the assumption last year or so that I won't ever be having an array 
> of more then 2Tb. The irony is of course that I thought of this whilst 
> building an array of 4x500gb. I've decided to stick an extra 500gb and expand 
> the array a bit, and now I might bump into that 2TB limitation of 0.9 
> superblocks.
>
> I've read the manpage and it mentions something cryptic about superblock 1.2 
> restrictions, but I'm sure it's not something i'll have to worry about. What 
> I am curious about however is wether I can upgrade my metadata on my raid5 
> array?
>
> Thanks,
>
> oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hmm I used 0.93.00 to upgrade from 1.8TiB to 3.2TiB using 400GiB drives 
without an issue, what 0.9x.xx are you running?

I continue to use 0.93.00 because it lets me boot using LILO in a RAID1 
configuration and there still seems like there is a lot of confusion > 
0.9x..

Justin.
