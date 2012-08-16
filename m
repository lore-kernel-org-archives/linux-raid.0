From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: md: raid 10 supports TRIM
Date: Thu, 16 Aug 2012 14:02:38 +0300
Message-ID: <20120816110237.GA4709@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: shli@fusionio.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Shaohua Li,

This is a semi-automatic email about new static checker warnings.

The patch d61b764704ca: "md: raid 10 supports TRIM" from Aug 15, 
2012, leads to the following Smatch complaint:

drivers/md/raid10.c:3510 run()
	 warn: variable dereferenced before check 'mddev->queue' (see line 3508)

drivers/md/raid10.c
  3507	
  3508		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
                                              ^^^^^^^^^^^^
New dereference.

  3509		chunk_size = mddev->chunk_sectors << 9;
  3510		if (mddev->queue) {
                    ^^^^^^^^^^^^
Old check.

  3511			blk_queue_io_min(mddev->queue, chunk_size);
  3512			if (conf->geo.raid_disks % conf->geo.near_copies)

regards,
dan carpenter

