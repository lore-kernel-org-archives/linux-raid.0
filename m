From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID across multiple SATA host controllers - OK?
Date: Mon, 16 Jul 2007 18:22:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707161822130.23875@p34.internal.lan>
References: <469BE63D.8070504@covchurch.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469BE63D.8070504@covchurch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Neumarke <greg.neumarke@covchurch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 16 Jul 2007, Greg Neumarke wrote:

> Hi. I'm looking at setting up software RAID across 5 drives on an Intel 
> motherboard that has a ICH7R 4-port SATA controller and also an additional 4 
> SATA ports on a Marvell controller.
>
> Is there anything I should be aware of when creating a software RAID5 array 
> with drives hosted on more that one controller? Is this a bad idea, or no 
> problem?
>
> Thanks
> -Greg
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I do it with 6 ports on 965 + 2 port sata controllers, no issues in my 
case.

Justin.
