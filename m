From: Neil Brown <neilb@suse.de>
Subject: Re: improving raid 5 performance
Date: Tue, 23 May 2006 20:40:37 +1000
Message-ID: <17522.59045.371311.439259@cse.unsw.edu.au>
References: <5d96567b0605230153w2c2b0015y3bdd54cc9ae37899@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Tuesday May 23
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 23, raziebe@gmail.com wrote:
> Neil hello.
> 
> 1.
> i have applied the common path according to
> http://www.spinics.net/lists/raid/msg11838.html as much as i can.

Great.  I look forward to seeing the results.

> 
> it looks ok in terms of throughput.
> before i continue to a non common path ( step 3 ) i do not understand
> raid0_mergeable_bvec entirely.

Not too surprising - it is rather subtle unfortunately.

> 
> as i understand the code checks alignment . i made a version for this
> purpose which looks like that:

Yes, it checks alignment with the chunks and devices.
However we always have to allow one page to be added to a bio, so
sometimes we have to accept a bio that crosses a chunk/device boundary.

The main (possibly only) user is in __bio_add_page in fs/bio.c
so we basically code the merge_bvec_fn to meet the needs of that code.

> 
> static int raid5_mergeable_bvec(request_queue_t *q, struct bio *bio,
> struct bio_vec *biovec)
> {
> 	mddev_t *mddev = q->queuedata;
> 	sector_t sector=bio->bi_sector+get_start_sect(bio->bi_bdev);
> 	int max;
> 	unsigned int chunk_sectors = mddev->chunk_size >> 9;
> 	unsigned int bio_sectors = bio->bi_size >> 9;
> 
> 	max=(chunk_sectors-((sector&(chunk_sectors-1))+bio_sectors))<<9;
> 	if (max < 0){
> 		printk("handle_aligned_read not aligned %d %d %d
> %lld\n",max,chunk_sectors,bio_sectors,sector);
> 		return -1; // Is bigger than one chunk size
> 	}
> 
> //	printk("handle_aligned_read aligned %d %d %d
> %lld\n",max,chunk_sectors,bio_sectors,sector);
> 	return max;
> }

you cannot return a negative number, because the result is
compared with an 'unsigned int', and the comparison will be unsigned. 
So "return -1" is a problem.  I think you need to make this code 
look a lot more like raid0_mergeable_bvec.


> 
> Questions:
>    1.1 why did you drop the max=0 case ?

I'm not sure what you mean by 'drop'.
If bio->bi_size == 0, then we are not allowed to return a number
smaller than biovec->bv_len, otherwise bio_add_page wont be able
to put any pages on the bio, and so wont be able to start any IO.

>    1.2  what these lines mean ? do i need it ?
>        if (max <= biovec->bv_len && bio_sectors == 0)
>                  return biovec->bv_len;
>          else
>                 return max;
>          }

Yes, you need this.  It basically implements the above restriction.

NeilBrown
