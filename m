From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid 5 read performance
Date: Sun, 21 May 2006 12:10:48 +0300
Message-ID: <5d96567b0605210210wc3925ek6161f427944f8b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil hello
I am measuring read performance of two raid5 with 7 sata disks, chunk size 1MB.
when i set the stripe_cache_size to 4096 i get 240 MB/s. IO'ing from
the two raids ended with 270 MB/s.

i have added a code in make_request which passes the raid5 logic in
the case of read.

it looks like this :
static int make_request (request_queue_t *q, struct bio * bi)
{
.....
	if ( conf->raid5_bypass_read  &&  bio_data_dir(bi) == READ )
	{	
		new_sector = raid5_compute_sector(bi->bi_sector,
						  raid_disks,
						  data_disks,
						  &dd_idx,
						  &pd_idx,
						  conf);

		bi->bi_sector = new_sector;
		bi->bi_bdev =  conf->disks[dd_idx].rdev->bdev;
		//
		//	do some statics
		//
		disk_stat_inc(mddev->gendisk, ios[rw]);
		disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));

		//
		// make upper level to the work for me
		//
		return 1;
	}
...
}

it increased the performance to 440 MB/s.

Question :
       What is the cost of not walking trough the raid5 code in the
case of READ ?
       if i add and error handling code will it be suffice ?

thank you
-- 
Raz
