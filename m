From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: RAID code doubt
Date: Tue, 28 Dec 2004 08:13:34 +0100 (MET)
Message-ID: <200412280713.iBS7DYT25268@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From (env: ptb) at "Dec 27, 2004 01:39:23 am"
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach ptb:"
>     mbio = bio_clone(bio, GFP_NOIO);
>     ...
>     mbio->bi_sector = r1_bio->sector + conf->mirrors[i].rdev->data_offset;          

OK - the GFP_NOIO includes wait flags, so it seems to wait at least for
a bit.

      include/linux/gfp.h:#define GFP_NOIO    (__GFP_WAIT)

But can't the allocation still fail sometimes? And if not won't we just
stall forever in a deadlock if for example the only available memory is
in buffers that are aimed at this same raid device?


> but I don't think bio_clone is GUARANTEED to produce a non-null result,
> is it? It uses bio_alloc to get a bio, and bio_alloc does ...
> 
>         bio = mempool_alloc(bio_pool, gfp_mask);
>         if (unlikely(!bio))
>                 goto out;
> 
> out:
>                 return bio;
>         }
> 
>         mempool_free(bio, bio_pool);
>         bio = NULL;
>         goto out;
>   
> So it looks perfectly capable of producing a NULL.

Peter

