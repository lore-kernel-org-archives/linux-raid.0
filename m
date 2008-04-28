From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] limit error rate
Date: Mon, 28 Apr 2008 11:44:59 +1000
Message-ID: <18453.11291.797493.538474@notabene.brown>
References: <ftquac$82m$1@ger.gmane.org>
	<e9c3a7c20804221744m6600eccdy9934f58fb6ccded3@mail.gmail.com>
	<200804240055.17675.bernd-schubert@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Thursday April 24
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 24, bernd-schubert@gmx.de wrote:
> 
> @@ -1157,19 +1159,20 @@ static void raid5_end_read_request(struct bio * bi, int error)
>  
>  		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>  		atomic_inc(&rdev->read_errors);
> -		if (conf->mddev->degraded)
> +		if (conf->mddev->degraded && printk_ratelimit())
>  			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
>  			       mdname(conf->mddev),
>  			       (unsigned long long)(sh->sector + rdev->data_offset),
>  			       bdn);
> -		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
> +		else if (test_bit(R5_ReWrite, &sh->dev[i].flags) && 
> +			 printk_ratelimit())
>  			/* Oh, no!!! */
>  			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
>  			       mdname(conf->mddev),
>  			       (unsigned long long)(sh->sector + rdev->data_offset),
>  			       bdn);
>  		else if (atomic_read(&rdev->read_errors)
> -			 > conf->max_nr_stripes)
> +			 > conf->max_nr_stripes && printk_ratelimit())
>  			printk(KERN_WARNING
>  			       "raid5:%s: Too many read errors, failing device %s.\n",
>  			       mdname(conf->mddev), bdn);

This is not good, you are subtly changing semantics.
You have changed:

  if (A)
      X;
  else if (B)
      Y;
  else if (C)
      Z;
  else
      W;

to 
  if (A && foo())
      X;
  else if (B && foo())
      Y;
  else if (C && foo())
      Z;
  else
      W;

If 'A' and not 'foo()', you want nothing to happen, but you will
actually get one of Y, Z, or W happening, all of which are wrong.

> 
> Btw, from my point of view the 
> 
> if (printk_ratelimit())
> 	printk("print output");
> 
> looks odd. I just don't see why the API isn't
> 
> printk_ratelimit("print output");

Very sensible.  I've put

  #define printk_rl  printk_ratelimit() ?: printk

at the start of raid5.c, and used it to fix the problematic printks.

Thanks,
NeilBrown
