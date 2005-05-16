From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [PATCH] bio: set bi_idx after bio cloning
Date: Mon, 16 May 2005 10:25:22 -0500
Message-ID: <1116257122.15450.6.camel@langvan2.homenetwork>
References: <1116020307.6557.34.camel@langvan2.homenetwork>
	 <17029.13146.794856.708018@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17029.13146.794856.708018@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, axboe@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Jens,

Unless you have specific reason for not doing in __bio_clone(), I agree
with Neil's suggestion.  Please consider the following patch:

--- linux-2.6.12-rc4-orig/fs/bio.c   2005-05-16 10:13:27.000000000 -0500
+++ linux-2.6.12-rc4-patch/fs/bio.c   2005-05-16 10:15:06.000000000 -0500
@@ -255,10 +255,7 @@
        bio->bi_flags |= 1 << BIO_CLONED;
        bio->bi_rw = bio_src->bi_rw;

-       /*
-        * notes -- maybe just leave bi_idx alone. assume identical mapping
-        * for the clone
-        */
+       bio->bi_idx = bio_src->bi_idx;
        bio->bi_vcnt = bio_src->bi_vcnt;
        bio->bi_size = bio_src->bi_size;
        bio_phys_segments(q, bio);



--
Regards,
Mike T.

On Fri, 2005-05-13 at 18:08, Neil Brown wrote:
> On Friday May 13, mhtran@us.ibm.com wrote:
> > Hi Neil et al,
> > 
> > The scenario:  Having LVM (striped) volumes on top of 2 raid1 devices
> > The problem:   Corruption in building the scatter gather list for
> > device driver (see /drivers/block/blk_rq_map_sg() function)
> > 
> > In DM code, a bio sometimes can be split into several
> > clones and the clones' bi_idx is set accordingly by DM.  MD raid1 also
> > clones bio but does not adjust bi_idx. The problem can be fixed in
> > either __bio_clone() or the caller of bio_clone().  I chose to fix
> > raid1.
> 
> Presumably the same fix would be needed in the "write" path and all in
> the read-retry path in raid1d?
> 
> Why not just put it in __bio_clone, which would be one change instead
> of (atleast) 3?
> 
> NeilBrown
> 
> > 
> > --- linux-2.6.12-rc4-orig/drivers/md/raid1.c    2005-05-10 13:35:06.000000000-0500
> > +++ linux-2.6.12-rc4-patch/drivers/md/raid1.c   2005-05-13 15:41:43.000000000-0500
> > @@ -577,6 +577,7 @@
> > 
> >                 r1_bio->bios[rdisk] = read_bio;
> > 
> > +               read_bio->bi_idx = bio->bi_idx;
> >                 read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
> >                 read_bio->bi_bdev = mirror->rdev->bdev;
> >                 read_bio->bi_end_io = raid1_end_read_request;
> > 
> > --
> > Regards,
> > Mike T.
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

