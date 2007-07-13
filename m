From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Re-building an array
Date: Fri, 13 Jul 2007 15:37:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707131537110.2064@p34.internal.lan>
References: <1184352876.24282.82.camel@thor.greenbuzz.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1184352876.24282.82.camel@thor.greenbuzz.net>
Sender: linux-raid-owner@vger.kernel.org
To: mail <lists@gmnet.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 13 Jul 2007, mail wrote:

> Hi List,
>
> I am very new to raid, and I am having a problem.
>
> I made a raid10 array, but I only used 2 disks.  Since then, one failed,
> and my system crashes with a kernel panic.
>
> I copied all the data, and I would like to start over.  How can I start
> from scratch? I need to get rid of my /dev/md0, fully test the discs,
> and build them over again as raid1 ?
>
> Thanks!
> Rick
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

man mdadm, check --zero-superblock option
