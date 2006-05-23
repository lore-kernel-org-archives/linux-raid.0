From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: improving raid 5 performance
Date: Tue, 23 May 2006 11:53:30 +0300
Message-ID: <5d96567b0605230153w2c2b0015y3bdd54cc9ae37899@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil hello.

1.
i have applied the common path according to
http://www.spinics.net/lists/raid/msg11838.html as much as i can.

it looks ok in terms of throughput.
before i continue to a non common path ( step 3 ) i do not understand
raid0_mergeable_bvec entirely.

as i understand the code checks alignment . i made a version for this
purpose which looks like that:

static int raid5_mergeable_bvec(request_queue_t *q, struct bio *bio,
struct bio_vec *biovec)
{
	mddev_t *mddev = q->queuedata;
	sector_t sector=bio->bi_sector+get_start_sect(bio->bi_bdev);
	int max;
	unsigned int chunk_sectors = mddev->chunk_size >> 9;
	unsigned int bio_sectors = bio->bi_size >> 9;

	max=(chunk_sectors-((sector&(chunk_sectors-1))+bio_sectors))<<9;
	if (max < 0){
		printk("handle_aligned_read not aligned %d %d %d
%lld\n",max,chunk_sectors,bio_sectors,sector);
		return -1; // Is bigger than one chunk size
	}

//	printk("handle_aligned_read aligned %d %d %d
%lld\n",max,chunk_sectors,bio_sectors,sector);
	return max;
}

Questions:
   1.1 why did you drop the max=0 case ?
   1.2  what these lines mean ? do i need it ?
       if (max <= biovec->bv_len && bio_sectors == 0)
                 return biovec->bv_len;
         else
                return max;
         }


thank you

Raz
