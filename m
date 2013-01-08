From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Tue, 8 Jan 2013 16:44:15 +0300
Message-ID: <20130108134415.GA840@elgon.mountain>
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

drivers/md/raid10.c:3630 run()
	 error: we previously assumed 'mddev->queue' could be null (see line 3619)

drivers/md/raid10.c
  3618		chunk_size = mddev->chunk_sectors << 9;
  3619		if (mddev->queue) {
                    ^^^^^^^^^^^^
Old check.

  3620			blk_queue_max_discard_sectors(mddev->queue,
  3621						      mddev->chunk_sectors);
  3622			blk_queue_io_min(mddev->queue, chunk_size);
  3623			if (conf->geo.raid_disks % conf->geo.near_copies)
  3624				blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
  3625			else
  3626				blk_queue_io_opt(mddev->queue, chunk_size *
  3627						 (conf->geo.raid_disks / conf->geo.near_copies));
  3628		}
  3629	
  3630		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
                                                 ^^^^^^^^^^^^
New dereference.

  3631		rdev_for_each(rdev, mddev) {
  3632			long long diff;

regards,
dan carpenter
