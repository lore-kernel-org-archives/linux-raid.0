From: CaT <cat@zip.com.au>
Subject: Re: raid5 resizing
Date: Wed, 19 Dec 2007 23:23:16 +1100
Message-ID: <20071219122316.GG29538@zip.com.au>
References: <20071219111713.GF29538@zip.com.au> <18281.1965.40403.734289@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18281.1965.40403.734289@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 19, 2007 at 10:59:41PM +1100, Neil Brown wrote:
> On Wednesday December 19, cat@zip.com.au wrote:
> > Hi,
> > 
> > I'm thinking of slowly replacing disks in my raid5 array with bigger
> > disks and then resize the array to fill up the new disks. Is this
> > possible? Basically I would like to go from:
> > 
> > 3 x 500gig RAID5 to 3 x 1tb RAID5, thereby going from 1tb to 2tb of
> > storage.
> > 
> > It seems like it should be, but... :)
> 
> Yes.
> 
> mdadm --grow /dev/mdX --size=max

Oh -joy-. I love linux sw raid. :) The only thing it seems to lack is
battery backed-up cache.

Thank you.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
