From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Tue, 8 Jan 2013 16:23:03 +0300
Message-ID: <20130108132303.GA6835@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Joe.Lawrence@stratus.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Joe Lawrence,

This is a semi-automatic email about new static checker warnings.

The patch aa992f57bd76: "md: raid1,10: Handle REQ_WRITE_SAME flag in
write bios" from Dec 14, 2012, leads to the following Smatch
complaint:

drivers/md/raid1.c:2861 run()
	 warn: variable dereferenced before check 'mddev->queue' (see line 2823)

drivers/md/raid1.c
  2822	
  2823		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
                                                 ^^^^^^^^^^^^
New dereference.

  2824		rdev_for_each(rdev, mddev) {
  2825			if (!mddev->gendisk)
  2826				continue;
  2827			disk_stack_limits(mddev->gendisk, rdev->bdev,
  2828					  rdev->data_offset << 9);
  2829			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
  2830				discard_supported = true;
  2831		}
  2832	
  2833		mddev->degraded = 0;
  2834		for (i=0; i < conf->raid_disks; i++)
  2835			if (conf->mirrors[i].rdev == NULL ||
  2836			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
  2837			    test_bit(Faulty, &conf->mirrors[i].rdev->flags))
  2838				mddev->degraded++;
  2839	
  2840		if (conf->raid_disks - mddev->degraded == 1)
  2841			mddev->recovery_cp = MaxSector;
  2842	
  2843		if (mddev->recovery_cp != MaxSector)
  2844			printk(KERN_NOTICE "md/raid1:%s: not clean"
  2845			       " -- starting background reconstruction\n",
  2846			       mdname(mddev));
  2847		printk(KERN_INFO 
  2848			"md/raid1:%s: active with %d out of %d mirrors\n",
  2849			mdname(mddev), mddev->raid_disks - mddev->degraded, 
  2850			mddev->raid_disks);
  2851	
  2852		/*
  2853		 * Ok, everything is just fine now
  2854		 */
  2855		mddev->thread = conf->thread;
  2856		conf->thread = NULL;
  2857		mddev->private = conf;
  2858	
  2859		md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
  2860	
  2861		if (mddev->queue) {
                    ^^^^^^^^^^^^
Old check.

  2862			mddev->queue->backing_dev_info.congested_fn = raid1_congested;
  2863			mddev->queue->backing_dev_info.congested_data = mddev;

regards,
dan carpenter
