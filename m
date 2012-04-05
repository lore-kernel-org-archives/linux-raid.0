From: Anuj Goel <talk2anuj@gmail.com>
Subject: doubt in chunk_aligned_read()
Date: Wed, 4 Apr 2012 21:25:53 -0400
Message-ID: <CANSbrrp_LByxog3q265ruHxJxxJRhE2SfvPgzx8EK4FyL-7KOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

HI Guys,

Why is the below call needed in the function  chunk_aligned_read()

	align_bi = bio_clone_mddev(raid_bio, GFP_NOIO, mddev);

Why do we need to create a clone of the bio passed to
chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio) ??

--
Best Regards,
Anuj Goel
Experimental Computer Science Lab
Stony Brook University.
Cell: +1-801-209-5873
