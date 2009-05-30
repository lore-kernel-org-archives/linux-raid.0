From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH/RFC 0/2] md: personality pushdown patches -- intro
Date: Sun, 31 May 2009 08:19:41 +1000
Message-ID: <18977.45309.243141.219288@notabene.brown>
References: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Friday May 29
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 29, maan@systemlinux.org wrote:
> Here are the first two patches for pushing down raid level dependent
> code from md.c to the corresponding personalities.
> 
> The first patch is trivial as it moves only a printk() to the
> personalities. The second patch removes knowledge about bitmaps
> from md.c.

Thanks Andre.
This first is good and is now in my for-next branch.

The second is heading in the right direction.
However md_bitmap_present is as much of a layering violation in its
own way as the previous code was - diving in to the metatype_type
specific data.

You will notice in bitmap_create that an array has a bitmap if and
only if (mddev->bitmap_file || mddev->bitmap_offset).

So that is the test which should be used in md_bitmap_present.

Also the function name "md_bitmap_present" give no hint that it will
report an error - it reads like a simple test.
Maybe "md_check_no_bitmap" to indicate what the function is expecting
to find?

Thanks,
NeilBrown


> 
> If the general approach used by the second patch is agreed with, I
> will follow up with patches that deal with data integrity registration
> and multipath handling which are the remaining two issues where md.c
> does what should be handled in personality code.
> 
> Thanks
> Andre
> -- 
> 1.5.4.3
