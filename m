From: MRK <gabriele.trombetti@gmail.com>
Subject: [PATCH 1/1] Fix raid-6 read-error correction in degraded state
Date: Wed, 28 Apr 2010 16:07:54 +0200
Message-ID: <4BD8413A.2000707@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
Cc: Janos Haar <janos.haar@netcenter.hu>
List-Id: linux-raid.ids

Fix: Raid-6 was not trying to correct a read-error when in 
singly-degraded state and was instead dropping one more device, going to 
doubly-degraded state. This patch fixes this behaviour.

Signed-off-by: Gabriele A. Trombetti <g.trombetti.lkrnl1213@logicschema.com>
Reported-by: Janos Haar <janos.haar@netcenter.hu>
--------
--- linux-2.6.34-rc5-git8-vanilla/drivers/md/raid5.c    2010-04-28 
13:05:03.000000000 +0200
+++ linux-2.6.34-rc5-git8/drivers/md/raid5.c    2010-04-28 
13:08:15.000000000 +0200
@@ -1527,7 +1527,7 @@ static void raid5_end_read_request(struc

                 clear_bit(R5_UPTODATE, &sh->dev[i].flags);
                 atomic_inc(&rdev->read_errors);
-               if (conf->mddev->degraded)
+               if (conf->mddev->degraded >= conf->max_degraded)
                         printk_rl(KERN_WARNING
                                   "raid5:%s: read error not correctable "
                                   "(sector %llu on %s).\n",

---------------------------------------------------------------

Thanks,
Gabriele A. Trombetti

