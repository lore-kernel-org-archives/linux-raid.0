From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Tue, 12 Aug 2003 12:49:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16184.21961.117266.472665@gargle.gargle.HOWL>
References: <200308071250.18543.arekm@pld-linux.org>
	<200308112320.49298.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arkadiusz Miskiewicz on Monday August 11
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 11, arekm@pld-linux.org wrote:
> >2.6.0-test2 should be able to assemble it (it ignores those counts)
> >but there is some data corruption bug that I am hitting in
> >2.6.0-test2 that could well be raid5 related, so I'm not sure I
> >would recommend that.
> What about test3?

Should be fixed in test4.
However it only affects filesystem reads when under memory pressure,
so it should be safe to use test3 to start and then stop the array,
and this should correct the superblock and rebuild for you.

> 
> >I could probably knock up a patch to 2.4.21 in a couple of days that
> >corrects the counts when an array is assembled.
> I'm very interested in this patch. I can wait few days and test it before I do 
> proposed alternative method.

This isn't a completely general patch, as the 2.4 code doesn't lend
its self to a completely general solution.  However it fixes the
spares count for raid5, so if you boot with a 2.4.21 kernel with this
patch, it should rebuild your array.

NeilBrown


diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-08-12 12:36:40.000000000 +1000
+++ ./drivers/md/raid5.c	2003-08-12 12:46:09.000000000 +1000
@@ -1365,6 +1365,7 @@ static int raid5_run (mddev_t *mddev)
 	struct disk_info *disk;
 	struct md_list_head *tmp;
 	int start_recovery = 0;
+	int spares = 0;
 
 	MOD_INC_USE_COUNT;
 
@@ -1462,6 +1463,7 @@ static int raid5_run (mddev_t *mddev)
 			disk->write_only = 0;
 			disk->spare = 1;
 			disk->used_slot = 1;
+			spares ++;
 		}
 	}
 
@@ -1554,6 +1556,7 @@ static int raid5_run (mddev_t *mddev)
 		}
 	}
 	sb->active_disks = conf->working_disks;
+	sb->spare_disks = spares;
 
 	if (sb->active_disks == sb->raid_disks)
 		printk("raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev), sb->active_disks, sb->raid_disks, conf->algorithm);
