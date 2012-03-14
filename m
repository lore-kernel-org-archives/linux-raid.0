From: "majianpeng" <majianpeng@gmail.com>
Subject: Question about handle_failed_sync()
Date: Wed, 14 Mar 2012 15:16:45 +0800
Message-ID: <201203141516404211761@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 In function handle_failed_sync():
>>/* During recovery devices cannot be removed, so locking and
>>	 * refcounting of rdevs is not needed
>>	 */
>>	for (i = 0; i < conf->raid_disks; i++) {
>>		struct md_rdev *rdev = conf->disks[i].rdev;
>>		if (rdev
>>		    && !test_bit(Faulty, &rdev->flags)
>>		    && !test_bit(In_sync, &rdev->flags)
>>		    && !rdev_set_badblocks(rdev, sh->sector,
>>					   STRIPE_SECTORS, 0))
>>			abort = 1;

I have two questions:
1:if raid have two or more spare disks, it wil set bad block on all spare disk. Is it worth it?
2:If raid have two or more spare disks,I can remove spare disks which not working for recovery.Then you shold add locking 
   and refconting.
 				
--------------
majianpeng
2012-03-14

