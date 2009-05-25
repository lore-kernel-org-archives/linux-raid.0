From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/6] md: Make mddev->chunk_size sector-based.
Date: Tue, 26 May 2009 09:02:20 +1000
Message-ID: <18971.9084.661068.219724@notabene.brown>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
	<1243243657-21855-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday May 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 25, maan@systemlinux.org wrote:
> This patch changes the type of the chunk_size field from int to
> sector_t and renames it to chunk_sectors with the implied change of
> semantics. Since
> 
> 	is_power_of_2(chunk_size) = is_power_of_2(chunk_sectors << 9)
> 				  = is_power_of_2(chunk_sectors)
> 
> these bits don't need an adjustment for the shift.

Thanks.

I don't really want chunk_sectors to be sector_t - it is a waste on
32bit, and would cause
> +		if (sector_div(temp, mddev->chunk_sectors))

to fail.
I've left it as 'int' and removed all the (int) casts and (sector_t)
casts.   I adjusted the comment too.

I also changed:
	if (mddev->chunk_sectors << 9 < PAGE_SIZE ||
to
	if (mddev->chunk_sectors < (PAGE_SIZE >> 9) ||
primarily because I need the brackets around the shift, even if the
C compiler doesn't.


Thanks,
NeilBrown
