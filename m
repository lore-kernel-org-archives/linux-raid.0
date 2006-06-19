From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Mon, 19 Jun 2006 12:03:29 +1000
Message-ID: <17558.1521.522659.91428@cse.unsw.edu.au>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Sunday June 18
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 18, nigel@nigelterry.net wrote:
> This from dmesg might help diagnose the problem:
> 

Yes, that helps a lot, thanks.

The problem is that the reshape thread is restarting before the array
is fully set-up, so it ends up dereferencing a NULL pointer.

This patch should fix it.
In fact, there is a small chance that next time you boot it will work
without this patch, but the patch makes it more reliable.

There definitely should be no data-loss due to this bug.

Thanks,
NeilBrown



### Diffstat output
 ./drivers/md/md.c    |    6 ++++--
 ./drivers/md/raid5.c |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-05-30 15:07:14.000000000 +1000
+++ ./drivers/md/md.c	2006-06-19 12:01:47.000000000 +1000
@@ -2719,8 +2719,6 @@ static int do_md_run(mddev_t * mddev)
 		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_wakeup_thread(mddev->thread);
-	
 	if (mddev->sb_dirty)
 		md_update_sb(mddev);
 
@@ -2738,6 +2736,10 @@ static int do_md_run(mddev_t * mddev)
 
 	mddev->changed = 1;
 	md_new_event(mddev);
+
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread);
+
 	return 0;
 }
 

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-19 11:56:41.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-19 11:56:44.000000000 +1000
@@ -2373,9 +2373,6 @@ static int run(mddev_t *mddev)
 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
 							"%s_reshape");
-		/* FIXME if md_register_thread fails?? */
-		md_wakeup_thread(mddev->sync_thread);
-
 	}
 
 	/* read-ahead size must cover two whole stripes, which is
