From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: RAID code doubt
Date: Mon, 27 Dec 2004 01:39:23 +0100 (MET)
Message-ID: <200412270039.iBR0dNV06278@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Question - in raid1.c, for example, I see:


    mbio = bio_clone(bio, GFP_NOIO);
    ...
    mbio->bi_sector = r1_bio->sector + conf->mirrors[i].rdev->data_offset;          
but I don't think bio_clone is GUARANTEED to produce a non-null result,
is it? It uses bio_alloc to get a bio, and bio_alloc does ...

        bio = mempool_alloc(bio_pool, gfp_mask);
        if (unlikely(!bio))
                goto out;

out:
                return bio;
        }

        mempool_free(bio, bio_pool);
        bio = NULL;
        goto out;
  
So it looks perfectly capable of producing a NULL.

Peter
