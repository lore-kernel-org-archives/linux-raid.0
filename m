From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Raid1 doesn't balance under high load [patch]
Date: Thu, 10 Jun 2004 09:38:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001601c44ef0$2d3593a0$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know the details of how writing works in the code. I do know that
consecutive writes must be issued to both disks, though. This means that
there is a concievable time when one disk is written to and one is not,
making the array unclean. I'm assuming that this is the reason that the
array is marked unclean during a write. If you disable this, I would bet
that it will create a race condition where you may read from a disk before
it is written to and get old data. This would probably cause data
corruption, no?


----- Original Message ----- 
From: Miquel van Smoorenburg
To: linux-raid@vger.kernel.org
Sent: Thursday, June 10, 2004 7:30 AM
Subject: Raid1 doesn't balance under high load [patch]


I have several servers installed with a bootable raid1 array. I noticed
that under high load, the load wasn't balanced over the 2 disks in
the array anymore - all reads went to just one of the disks.

The problem is in raid1.c:read_balance().

There's a check to see if the array is in sync:

        /*
         * Check if it if we can balance. We can balance on the whole
         * device if no resync is going on, or below the resync window.
         * We take the first readable disk when above the resync window.
         */
        if (!conf->mddev->in_sync && (this_sector + sectors >=
conf->next_resync)) {

Now if you write to the array, the array is marked not in sync by
md.c:md_write_start(). conf->next_resync is initialized to zero, so
that means read balancing doesn't work anymore.

Now I think there should be a separate flag called 'resync_in_progress'
that flags whether, well, a resync is in progress ;) and the whole
read_balance() function should be simplified as well since it tests
the same things about three times, but for now here's a simple one-liner
that fixes it:

--- linux-2.6.6/drivers/md/raid1.c.orig 2004-05-10 04:32:37.000000000 +0200
+++ linux-2.6.6/drivers/md/raid1.c 2004-06-10 01:16:00.000000000 +0200
@@ -1172,6 +1172,7 @@
  mddev->recovery_cp = MaxSector;

  conf->resync_lock = SPIN_LOCK_UNLOCKED;
+ conf->next_resync = mddev->size << 1;
  init_waitqueue_head(&conf->wait_idle);
  init_waitqueue_head(&conf->wait_resume);


Signed-Off-By: Miquel van Smoorenburg <miquels@cistron.nl>

(please keep me cc'ed, I'm not on the list)

Mike.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

