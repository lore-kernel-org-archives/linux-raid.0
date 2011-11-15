From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: md/raid10: handle recovery of replacement devices.
Date: Tue, 15 Nov 2011 09:32:39 +0300
Message-ID: <20111115063239.GA30827@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello NeilBrown,

This is a semi-automatic email about new static checker warnings.

The patch e1f6cbf7e1b0: "md/raid10: handle recovery of replacement 
devices." from Nov 9, 2011, leads to the following Smatch complaint:

drivers/md/raid10.c +2814 sync_request()
	 error: we previously assumed 'bio' could be null (see line 2808)

drivers/md/raid10.c
  2807					bio = r10_bio->devs[1].repl_bio;
  2808					if (bio)
                                            ^^^
check.

  2809						bio->bi_end_io = NULL;
  2810					rdev = mirror->replacement;
  2811					if (rdev == NULL ||
  2812					    test_bit(Faulty, &rdev->flags))
  2813						break;
  2814					bio->bi_next = biolist;
                                        ^^^^^^^^^^^^
unconditional dereference.

  2815					biolist = bio;
  2816					bio->bi_private = r10_bio;

regards,
dan carpenter

