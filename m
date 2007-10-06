From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Sat, 6 Oct 2007 08:30:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710060830250.28479@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <Pine.LNX.4.64.0710031248020.8612@p34.internal.lan>
 <20071003211003.37130cc8@alpha.digital-domain.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071003211003.37130cc8@alpha.digital-domain.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 3 Oct 2007, Andrew Clayton wrote:

> On Wed, 3 Oct 2007 12:48:27 -0400 (EDT), Justin Piszcz wrote:
>
>> Also if it is software raid, when you make the XFS filesyste, on it,
>> it sets up a proper (and tuned) sunit/swidth, so why would you want
>> to change that?
>
> Oh I didn't, the sunit and swidth were set automatically. Do they look
> sane?. From reading the XFS section of the mount man page, I'm not
> entirely sure what they specify and certainly wouldn't have any idea
> what to set them to.
>
>> Justin.
>
> Cheers,
>
> Andrew
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

As long as you ran mkfs.xfs /dev/md0 it should have optimized the 
filesystem according to the disks beneath it.

Justin.
