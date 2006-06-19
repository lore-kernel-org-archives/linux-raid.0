From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Tue, 20 Jun 2006 09:33:15 +1000
Message-ID: <17559.13371.751956.423312@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
	<17554.21119.487820.638171@cse.unsw.edu.au>
	<4492D5B1.60004@nigelterry.net>
	<4492D8D9.7010101@irule.net>
	<17555.12441.42212.93049@cse.unsw.edu.au>
	<4493330E.30501@nigelterry.net>
	<17555.13409.834439.80361@cse.unsw.edu.au>
	<44945643.3070300@nigelterry.net>
	<17556.31295.280083.533342@cse.unsw.edu.au>
	<44947BCA.9040305@nigelterry.net>
	<44947C98.6060809@nigelterry.net>
	<17556.32630.611922.294047@cse.unsw.edu.au>
	<44948002.3050706@nigelterry.net>
	<44954DB7.2000305@nigelterry.net>
	<17558.1521.522659.91428@cse.unsw.edu.au>
	<44971A51.6050008@nigelterry.net>
	<17559.10564.840472.525999@cse.unsw.edu.au>
	<44972AF1.8040500@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 19, nigel@nigelterry.net wrote:
> 
> One comment - As I look at the rebuild, which is now over 20%, the time 
> till finish makes no sense. It did make sense when the first reshape 
> started. I guess your estimating / averaging algorithm doesn't work for 
> a restarted reshape. A minor cosmetic issue - see below
> 
> Nigel
> [nterry@homepc ~]$ cat /proc/mdstat
> Personalities : [raid5] [raid4]
> md0 : active raid5 sdb1[1] sda1[0] hdc1[4](S) hdb1[2]
>       490223104 blocks super 0.91 level 5, 128k chunk, algorithm 2 [4/3] 
> [UUU_]
>       [====>................]  reshape = 22.7% (55742816/245111552) 
> finish=5.8min speed=542211K/sec

Hmmm..... I see.
This should fix that, but I don't expect you to interrupt your reshape
to try it.

Thanks,
NeilBrown


### Diffstat output
 ./drivers/md/md.c           |    8 +++++---
 ./include/linux/raid/md_k.h |    3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-19 11:52:55.000000000 +1000
+++ ./drivers/md/md.c	2006-06-20 09:30:57.000000000 +1000
@@ -2717,7 +2717,7 @@ static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
-	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
+	resync = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active));
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
 	db = resync - (mddev->resync_mark_cnt);
@@ -4688,8 +4688,9 @@ static void status_resync(struct seq_fil
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
-	db = resync - (mddev->resync_mark_cnt/2);
-	rt = (dt * ((unsigned long)(max_blocks-resync) / (db/100+1)))/100;
+	db = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active))
+		- mddev->resync_mark_cnt;
+	rt = (dt/2 * ((unsigned long)(max_blocks-resync) / (db/100+1)))/100;
 
 	seq_printf(seq, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
 
@@ -5204,6 +5205,7 @@ void md_do_sync(mddev_t *mddev)
 
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
+		mddev->curr_mark_cnt = io_sectors;
 		if (last_check == 0)
 			/* this is the earliers that rebuilt will be
 			 * visible in /proc/mdstat

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2006-06-20 09:31:22.000000000 +1000
+++ ./include/linux/raid/md_k.h	2006-06-20 09:31:58.000000000 +1000
@@ -148,9 +148,10 @@ struct mddev_s
 
 	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
-	sector_t			curr_resync;	/* blocks scheduled */
+	sector_t			curr_resync;	/* last block scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
+	sector_t			curr_mark_cnt; /* blocks scheduled now */
 
 	sector_t			resync_max_sectors; /* may be set by personality */
 
