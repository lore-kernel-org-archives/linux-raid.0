From: NeilBrown <neilb@suse.de>
Subject: Re: [smatch stuff] md/raid5: potential null deref in debug code
Date: Tue, 28 Jun 2011 16:42:25 +1000
Message-ID: <20110628164225.22107a37@notabene.brown>
References: <20110624181235.GQ14591@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110624181235.GQ14591@shale.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 Jun 2011 21:12:36 +0300 Dan Carpenter <error27@gmail.com> wrote:

> Hi Neil,
> 
> In d1b053e4de0ac33 "md/raid5: Protect some more code with
> ->device_lock." we moved some debug code around and it upsets my
> static checker.  Could you take a look?
> 
> drivers/md/raid5.c +2183 add_stripe_bio(47)
> 	error: potential null derefence 'bi'.
> 
>   2168          if (forwrite) {
>   2169                  /* check if page is covered */
>   2170                  sector_t sector = sh->dev[dd_idx].sector;
>   2171                  for (bi=sh->dev[dd_idx].towrite;
>   2172                       sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
>   2173                               bi && bi->bi_sector <= sector;
>                                      ^^
> 	It looks like "bi" can be NULL at the end of this for loop.
> 
> 
>   2174                       bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
>   2175                          if (bi->bi_sector + (bi->bi_size>>9) >= sector)
>   2176                                  sector = bi->bi_sector + (bi->bi_size>>9);
>   2177                  }
>   2178                  if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
>   2179                          set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>   2180          }
>   2181          spin_unlock_irq(&conf->device_lock);
>   2182  
>   2183          pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
>   2184                  (unsigned long long)bi->bi_sector,
>                                             ^^^^^^^^^^^^^
> 	We dereference it here.
> 
>   2185                  (unsigned long long)sh->sector, dd_idx);
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks Dan,
 as it happens I received a patch just the day before from Namhyung Kim which
 fixes that bug - so all fixed now.

Thanks,
NeilBrown
