From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linear RAID hot grow
Date: Mon, 20 Aug 2007 17:46:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dat Chu <dattanchu@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 20 Aug 2007, Dat Chu wrote:

> I am trying to find the mdadm version that support Linear RAID hot
> grow. Does anyone have a link to point me to? I am currently running
> 2.6.2.
>
> With warm regards,
> Dat Chu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Not sure, it seems like it would be supported by now?

But according to the docs for 2.6.2:

        Grow   Grow  (or shrink) an array, or otherwise reshape it in some way.
               Currently supported growth options including changing the active
               size of component devices in RAID level 1/4/5/6 and changing the
               number of active devices in RAID1/5/6.

--

http://neil.brown.name/blog/SoftRaid

--grow option for "linear" md arrays

I've just been working on an enhancement for Linux "MD" linear arrays 
which allows them to be enlanged.

More specifically, a new device (typcially disk drive) can be added to the 
end of an active linear array now. The size increases accordingly.

You can find patches for mdadm and 2.6.7-rc3-mm1.

It is still a work in progress, as it isn't documented, some of the code 
doesn't report errors very nicely, and I realised that there is some work 
needed in md.c with respect to handling new superblocks.

I really should do the new-superblock code in mdadm and get it all tidied 
up.
