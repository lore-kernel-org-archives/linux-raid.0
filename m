From: Andreas Kahnt <aka@aka.coware.de>
Subject: RE: raid1: resync hanging until reboot (fwd)
Date: Tue, 8 Apr 2003 17:06:17 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304081619250.22178-100000@aka.coware.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We also use 2.4.19-64GB-SMP (SLES-8) and have the same problems. I looked into
the kernel sources, the patch from Andy Cress is already applied.

Worse, we got a broken disk last week. A cp-process became hanging in kernel
(status 'D' with ps command) on a mirrored device. So we want to reboot the
server. It did not work, we had to powercycle the machine.

Our equipment: Compaq DL380, Adaptec AHA-3960D / AIC-7899A U160/m (rev 01), 10
34GB/70GB data disks on two busses each mirrored across plus one hotspare per
bus.

Andreas.Kahnt@coware.de

---------- Forwarded message ----------
Date: Tue, 8 Apr 2003 07:03:29 -0700
From: "Cress, Andrew R" <andrew.r.cress@intel.com>
To: 'Alfred Isele' <Alfred.Isele@fujitsu-siemens.com>
Cc: linux-raid@vger.kernel.org
Subject: RE: raid1: resync hanging until reboot

I've seen something similar in 2.4.18, and here's how we patched it.
http://scsirastools.sourceforge.net/kern/2.4.18/raid_resync.patch
It's short, so I've also included it below, but the formatting of the email
may wrap some lines.

Andy Cress

--- linux-2.4.18/drivers/md/md.c.orig	Thu Jan 30 10:35:01 2003
+++ linux-2.4.18/drivers/md/md.c	Thu Jan 30 10:37:13 2003
@@ -3424,6 +3424,10 @@
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
 		// stop recovery, signal do_sync ....
+		if (mddev->pers->stop_resync)
+			mddev->pers->stop_resync(mddev);
+		if (mddev->recovery_running)
+			md_interrupt_thread(md_recovery_thread);
 	}
 }

@@ -3578,7 +3582,7 @@
 	 * this also signals 'finished resyncing' to md_stop
 	 */
 out:
-	wait_event(mddev->recovery_wait,
atomic_read(&mddev->recovery_active)==0);
+	wait_disk_event(mddev->recovery_wait,
atomic_read(&mddev->recovery_active)==0);
 	up(&mddev->resync_sem);
 out_nolock:
 	mddev->curr_resync = 0;

-----Original Message-----
From: Alfred Isele [mailto:Alfred.Isele@fujitsu-siemens.com]
Sent: Monday, April 07, 2003 9:25 AM
To: linux-raid@vger.kernel.org
Subject: raid1: resync hanging until reboot



Hello!

When we disable a partition from a raid meta device
and try to reattach it again without a reboot in between
the resynch often starts hanging. After a reboot the
resynch does complete. In detail:

We use Linux version 2.4.19-64GB-SMP

We create a raid1 meta devivce:

    mdadm -Cv /dev/md0 -l1 -n2 /dev/sda1 /dev/sdb1

We disable one piece from the meta device:

    mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1

We reattach it to the meta device:

	mdadm /dev/md0 -a /dev/sda1

And very often but not always the resych hangs with
cat /proc/mdstat showing:

	md0 : active raid1 sda1[2] sdb1[1]
      	80256 blocks [2/1] [_U]
      	[>....................]  recovery =  0.0% (0/80256) finish=26.7min
speed=0K/sec


Does anybody know a solution to this problem?
Thank you very much
Alfred


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

