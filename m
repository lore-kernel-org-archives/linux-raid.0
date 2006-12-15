From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC: 2.6 patch] simplify drivers/md/md.c:update_size()
Date: Fri, 15 Dec 2006 01:45:12 +0100
Message-ID: <20061215004512.GU3388@stusta.de>
References: <20061215001902.GR3388@stusta.de> <1166142995.2745.319.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1166142995.2745.319.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, mingo@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 14, 2006 at 07:36:35PM -0500, Doug Ledford wrote:
> On Fri, 2006-12-15 at 01:19 +0100, Adrian Bunk wrote:
> > While looking at commit 8ddeeae51f2f197b4fafcba117ee8191b49d843e,
> > I got the impression that this commit couldn't fix anything, since the 
> > "size" variable can't be changed before "fit" gets used.
> > 
> > Is there any big thinko, or is the patch below that slightly simplifies 
> > update_size() semantically equivalent to the current code?
> 
> No, this patch is broken.  Where it fails is specifically the case where
> you want to autofit the largest possible size, you have different size
> devices, and the first device is not the smallest.  When you hit the
> first device, you will set size, then as you repeat the ITERATE_RDEV
> loop, when you hit the smaller device, size will be non-0 and you'll
> then trigger the later if and return -ENOSPC.  In the case of autofit,
> you have to preserve the fit variable instead of looking at size so you
> know whether or not to modify the size when you hit a smaller device
> later in the list.
>...

OK, sorry, I've got my thinko:

ITERATE_RDEV() is a loop.

That's what I missed.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

