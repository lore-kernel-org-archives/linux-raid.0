From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid1 creation problems
Date: Sat, 12 Jun 2004 13:00:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16586.29135.598399.909655@cse.unsw.edu.au>
References: <40C9AAA4.4020603@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rrk on Friday June 11
To: rrk <rrk@prairie.lakes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 11, rrk@prairie.lakes.com wrote:
> why would mdadm be creating a md device (raid1) that was larger than the 
> partition table?

Because the partition table hadn't  been read after it was last
changed maybe.

> these are two identical seagate 120's --debian 2.4.26 with raid compiled in.
> i have built the partition tables with fdisk cfdisk and parted same 
> problem everytime . everything is fine
> up until i boot at which time it say's the superblock is larger than the 
> partition by about 20 or 30 blocks

At which time *what* says that *what* superblock is larger by exactly
*how*many* blocks.

> I have built several other raid1 system's  over the last year and have 
> not seen this problem before.
> to add the drives to the array i boot under a recuse disk and sync under 
> the rescue disk. same mdadm
> version as they were built with. The partition tables match in all cases 
> -- with fdisk i kept everything on cyl
> boundaries.

I really think that if you want help, you need to provide better
details.  I'm guessing that this is a raid array that you are booting
off. Is that correct?

Exactly what do you do, and exactly what happens.

> 
> where and how does mdadm check partition size?

It uses an ioctl to ask the partition device how big it is.

NeilBrown

> thanks
> rob 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
