From: NeilBrown <neilb@suse.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Mon, 27 Jul 2015 11:56:53 +1000
Message-ID: <20150727115653.530daba6@noble>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
	<20140918110523.3ee5c064@notabene.brown>
	<CAGRgLy7+bN8ztaaN+oh6uATE7=Z=8LnU=R0m2CnVff4ZqgJFKg@mail.gmail.com>
	<20140922101704.53be2056@notabene.brown>
	<CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
	<20150724092404.66dc284d@noble>
	<CAGRgLy7qkyQquRDGCShjJsuREQXNN+WaNGaq5wK2psMLQ6BGtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7qkyQquRDGCShjJsuREQXNN+WaNGaq5wK2psMLQ6BGtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 26 Jul 2015 10:15:05 +0200 Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:

> Hi Neil,
> 
> On Fri, Jul 24, 2015 at 1:24 AM, NeilBrown <neilb@suse.com> wrote:
> > Hi Alex
> > thanks for noticing!
> > Just to be sure we mean the same thing: this is the patch which is
> > missing - correct?
> >
> > Thanks,
> > NeilBrown
> >
> > From: NeilBrown <neilb@suse.com>
> > Date: Fri, 24 Jul 2015 09:22:16 +1000
> > Subject: [PATCH] md/raid1: fix test for 'was read error from last working
> >  device'.
> >
> > When we get a read error from the last working device, we don't
> > try to repair it, and don't fail the device.  We simple report a
> > read error to the caller.
> >
> > However the current test for 'is this the last working device' is
> > wrong.
> > When there is only one fully working device, it assumes that a
> > non-faulty device is that device.  However a spare which is rebuilding
> > would be non-faulty but so not the only working device.
> >
> > So change the test from "!Faulty" to "In_sync".  If ->degraded says
> > there is only one fully working device and this device is in_sync,
> > this must be the one.
> >
> > This bug has existed since we allowed read_balance to read from
> > a recovering spare in v3.0
> >
> > Reported-and-tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
> > Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
> > Cc: stable@vger.kernel.org (v3.0+)
> > Signed-off-by: NeilBrown <neilb@suse.com>
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 166616411215..b368307a9651 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -336,7 +336,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
> >                 spin_lock_irqsave(&conf->device_lock, flags);
> >                 if (r1_bio->mddev->degraded == conf->raid_disks ||
> >                     (r1_bio->mddev->degraded == conf->raid_disks-1 &&
> > -                    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
> > +                    test_bit(In_sync, &conf->mirrors[mirror].rdev->flags)))
> >                         uptodate = 1;
> >                 spin_unlock_irqrestore(&conf->device_lock, flags);
> >         }
> 
> Yes, this was the missing piece.
> 
> But you also advised to put the whole of "raid1_spare_active" under
> the spinlock:
> > 2/ extend the spinlock in raid1_spare_active to cover the whole function.
> So we did this bit too. Can you pls comment if this is needed?

When you say "we did this bit" it would help a lot to actually show the
patch - helps avoid misunderstanding.  In fact I was probably hoping
that you would post a patch once you had it fixed.... no mater.
See below for that patch I have just queue.  There is an extra place
were a spinlock is probably helpful.

> 
> Also, will you be sending this patch to "stable"? We are moving to
> kernel 3.18, so we should get this then.

Putting "cc: stable@vger.kernel.org" means that it will automatically
migrated to the stable kernels once it has appeared in Linus' kernel.
So yes: it will go to -stable

> 
> Thanks!
> Alex.

Thanks,
NeilBrown

From 04f58ef505b9d354dd06c477a94a7e314a38cb72 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.com>
Date: Mon, 27 Jul 2015 11:48:52 +1000
Subject: [PATCH] md/raid1: extend spinlock to protect raid1_end_read_request
 against inconsistencies

raid1_end_read_request() assumes that the In_sync bits are consistent
with the ->degaded count.
raid1_spare_active updates the In_sync bit before the ->degraded count
and so exposes an inconsistency, as does error()
So extend the spinlock in raid1_spare_active() and error() to hide those
inconsistencies.

This should probably be part of
  Commit: 34cab6f42003 ("md/raid1: fix test for 'was read error from
  last working device'.")
as it addresses the same issue.  It fixes the same bug and should go
to -stable for same reasons.

Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
Cc: stable@vger.kernel.org (v3.0+)
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b368307a9651..742b50794dfd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1476,6 +1476,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
 	struct r1conf *conf = mddev->private;
+	unsigned long flags;
 
 	/*
 	 * If it is not operational, then we have already marked it as dead
@@ -1495,14 +1496,13 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 		return;
 	}
 	set_bit(Blocked, &rdev->flags);
+	spin_lock_irqsave(&conf->device_lock, flags);
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
-		unsigned long flags;
-		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
 	} else
 		set_bit(Faulty, &rdev->flags);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
 	 */
@@ -1568,7 +1568,10 @@ static int raid1_spare_active(struct mddev *mddev)
 	 * Find all failed disks within the RAID1 configuration
 	 * and mark them readable.
 	 * Called under mddev lock, so rcu protection not needed.
+	 * device_lock used to avoid races with raid1_end_read_request
+	 * which expects 'In_sync' flags and ->degraded to be consistent.
 	 */
+	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
 		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
@@ -1599,7 +1602,6 @@ static int raid1_spare_active(struct mddev *mddev)
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
 		}
 	}
-	spin_lock_irqsave(&conf->device_lock, flags);
 	mddev->degraded -= count;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
