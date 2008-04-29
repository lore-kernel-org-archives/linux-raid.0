From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 008 of 9] md: md: raid5 rate limit error printk
Date: Tue, 29 Apr 2008 14:14:46 +1000
Message-ID: <18454.41142.654638.785292@notabene.brown>
References: <20080429133104.20146.patches@notabene>
	<1080429033534.20399@suse.de>
	<20080428205522.28dce527.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday April 28
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bernd Schubert <bernd-schubert@gmx.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Monday April 28, akpm@linux-foundation.org wrote:
> On Tue, 29 Apr 2008 13:35:34 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > +			printk_rl(KERN_WARNING "raid5:%s: read error NOT corrected!! "
> > +				  "(sector %llu on %s).\n",
> > +				  mdname(conf->mddev),
> > +				  (unsigned long long)(sh->sector + rdev->data_offset),
> > +				  bdn);
> >  		else if (atomic_read(&rdev->read_errors)
> >  			 > conf->max_nr_stripes)
> >  			printk(KERN_WARNING
> > 
> > diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
> > --- .prev/include/linux/raid/md_k.h	2008-04-29 12:25:24.000000000 +1000
> > +++ ./include/linux/raid/md_k.h	2008-04-29 12:27:58.000000000 +1000
> > @@ -368,6 +368,9 @@ static inline void safe_put_page(struct 
> >  	if (p) put_page(p);
> >  }
> >  
> > +#define printk_rl  printk_ratelimit() ?: printk
> 
> (boggle)

You don't like the "?:" operator?

Maybe
   printk_ratelimit() && printk
?

> 
> Isn't this backwards?  Should be !printk_ratelimit()?

Arggg.. Did I do that?  Bother.

> 
> open-coding the printk_ratelimit() at each callsite would be more
> conventional.

True, but it can get noisy, adding an extra level of indent where it
isn't really needed (and the printk lines tend to be fairly long
already).

NeilBrown
