From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and  I/O sizes
Date: Thu, 11 Jun 2009 20:25:58 +1000
Message-ID: <18992.56246.663815.790604@notabene.brown>
References: <yq1my8i6naw.fsf@sermon.lab.mkp.net>
	<6579bc561e648e03ed4a739799e51d9e.squirrel@neil.brown.name>
	<yq1ws7k60vt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin K. Petersen on Wednesday June 10
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 10, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> 
> >> + blk_queue_io_opt(mddev->queue, chunk_size * (mddev->raid_disks >>
> >>  	blk_queue_io_opt(mddev->1));
> 
> Neil>  ">> 1" is wrong.  A raid10 may have more than 2 copies for each
> Neil>  block.
> 
> I recall pondering when I wrote that.  Never got around to revisiting
> the issue.  Your RAID10 implementation is a bit hipper than most :)

And I know where my towel is, too :-)
> 
> 
> Neil>  This calculation needs to be a bit more subtle and take about of
> Neil>  the particular layout (near, offset, or far).
> 
> Why would layout interfere with preferred I/O size?

For a 'far' or 'offset' layout, you probably want
    chunksize * raid_disks
just like raid0. 

For a 'near' layout, what you suggest seems good.

The driver actually allows both 'near' and 'far'.  I doubt if anyone
would use it, but it would be nice to get it 'right'.
> 
> How about:
> 
>     if (conf->raid_disks % conf->copies)
> 	blk_queue_io_opt(mddev->queue, chunk_size * conf->raid_disks);
>     else
> 	blk_queue_io_opt(mddev->queue, chunk_size *
> 			 (conf->raid_disks / conf->copies));

I think that if you replace "conf->copies" by 'nc' (which is
 (mddev->layout & 255)
) then that will be perfect.  For a 'far' layout, nc is normally '1',
and either branch will give the correct value.

Thanks,
NeilBrown


> 
> I.e.:
> 
> 2 drives, 2 copies: a1 a1       optimal I/O = 1 * chunk_size
> 
> 3 drives, 2 copies: a1 a1 a2
>                     a2 a3 a3    optimal I/O = 3 * chunk_size
> 
> 4 drives, 2 copies: a1 a1 a2 a2	optimal I/O = 2 * chunk_size
> 
> 4 drives, 3 copies: a1 a1 a1 a2
>                     a2 a2 a3 a3
>                     a3 a4 a4 a4 optimal I/O = 4 * chunk_size
> 
> And so on.  Does that make sense?  I.e. we try to keep all drives
> equally busy.
> 
> 
> Neil> You seem to be treating raid4 like raid6 :-)
> 
> Whoops.  I always forget about raid4.  Fixed.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
