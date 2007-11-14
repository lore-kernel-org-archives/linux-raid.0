From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Date: Tue, 13 Nov 2007 16:22:14 -0800
Message-ID: <20071114002214.GA31928@kroah.com>
References: <20071022171426.31103.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071022171426.31103.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, M@suse.de, linux-kernel@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 22, 2007 at 05:15:27PM +1000, NeilBrown wrote:
> 
> It appears that a couple of bugs slipped in to md for 2.6.23.
> These two patches fix them and are appropriate for 2.6.23.y as well
> as 2.6.24-rcX
> 
> Thanks,
> NeilBrown
> 
>  [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
>  [PATCH 002 of 2] md: raid5: fix clearing of biofill operations

I don't see these patches in 2.6.24-rcX, are they there under some other
subject?

thanks,

greg k-h
