From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 17:44:19 -0700
Message-ID: <49F7A2E3.4000908@zytor.com>
References: <1240574900.4507.2076.camel@ezra>	 <18935.35883.181289.739254@notabene.brown>  <49F79331.1050007@zytor.com>	 <1240963507.18303.866.camel@ezra>  <49F79A0B.1000805@zytor.com> <1240965373.18303.929.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240965373.18303.929.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Reurich wrote:
> 
> We are already in pain at not having the capability to reliably boot
> from a software raid array.  
> 

We have that just fine.  Use a RAID-1, which means that as long as the
firmware can find ANY disk you can boot from it, at which time you have
the full library of Linux drivers available, and it doesn't matter how
bad things work.

> This is the last hurdle to supplanting proprietary hardware raid
> controllers with their proprietary drivers and management tool stacks,
> and make software raid actually use able for the average Joe with his
> small business server built from cheap commodity hardware running linux.
>
> Or is this what your scared of?

The cheap commodity hardware running Linux is exactly what I want to
make work correctly; in particular I want it to work even when Joe finds
that a card goes dead in his box and he buys another one off the shelf.
 At that point, it should JUST WORK, no matter how broken the firmware
is (extremely common) or even if the card comes with no firmware at all
(common enough).

We already have the technology to splitting the disk between the boot
region and the array region (partition tables) and making sure that the
boot region is fully replicated (RAID-1).  That is what we should be
deploying, and if it somehow is too hard to deploy, that is what should
be fixed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

