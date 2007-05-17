From: "Jeff Zheng" <Jeff.Zheng@endace.com>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 17:38:57 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B348A@gazelle.ad.endace.com>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com><17994.19043.771733.453896@notabene.brown><659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com><17995.42562.870806.396617@notabene.brown><659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com><17995.49602.427417.500049@notabene.brown><Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm><17995.57891.56738.592100@notabene.brown> <17995.59547.368508.202596@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <17995.59547.368508.202596@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, david@lang.hm, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids


Yeah, seems you've locked it down, :D. I've written 600GB of data now,
and anything is still fine.
Will let it run overnight, and fill the whole 11T. I'll post the result
tomorrow

Thanks a lot though.

Jeff 

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de] 
> Sent: Thursday, 17 May 2007 5:31 p.m.
> To: david@lang.hm; Jeff Zheng; Michal Piotrowski; Ingo 
> Molnar; linux-raid@vger.kernel.org; 
> linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Subject: RE: Software raid0 will crash the file-system, when 
> each disk is 5TB
> 
> On Thursday May 17, neilb@suse.de wrote:
> > 
> > Uhm, I just noticed something.
> > 'chunk' is unsigned long, and when it gets shifted up, we 
> might lose 
> > bits.  That could still happen with the 4*2.75T arrangement, but is 
> > much more likely in the 2*5.5T arrangement.
> 
> Actually, it cannot be a problem with the 4*2.75T arrangement.
>   chuck << chunksize_bits
> 
> will not exceed the size of the underlying device *in*kilobytes*.
> In that case that is 0xAE9EC800 which will git in a 32bit long.
> We don't double it to make sectors until after we add
> zone->dev_offset, which is "sector_t" and so 64bit arithmetic is used.
> 
> So I'm quite certain this bug will cause exactly the problems 
> experienced!!
> 
> > 
> > Jeff, can you try this patch?
> 
> Don't bother about the other tests I mentioned, just try this one.
> Thanks.
> 
> NeilBrown
> 
> > Signed-off-by: Neil Brown <neilb@suse.de>
> > 
> > ### Diffstat output
> >  ./drivers/md/raid0.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
> > --- .prev/drivers/md/raid0.c	2007-05-17 
> 10:33:30.000000000 +1000
> > +++ ./drivers/md/raid0.c	2007-05-17 15:02:15.000000000 +1000
> > @@ -475,7 +475,7 @@ static int raid0_make_request (request_q
> >  		x = block >> chunksize_bits;
> >  		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
> >  	}
> > -	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
> > +	rsect = ((((sector_t)chunk << chunksize_bits) + 
> > +zone->dev_offset)<<1)
> >  		+ sect_in_chunk;
> >   
> >  	bio->bi_bdev = tmp_dev->bdev;
> 
