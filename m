From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 04:05:14 -0500
Message-ID: <200501100905.j0A95M920746@www.watkins-home.com>
References: <jsm9b2-iqp.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jsm9b2-iqp.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This confuses me!

A RAID1 array does not fail on a read error, unless the read error is on the
only disk.
Maybe you have found a bug?

Were you able to cause an array to fail by having 1 disk give a read error?

Or are you just preventing a single read error from kicking a disk?
I think this is what you are trying to say, if so, it has value.

Based on the code below, I think you are not referring to failing the array,
but failing a disk.

Would be nice to then attempt to correct the read error(s).  Also, log the
errors.  Else the array could continue to degrade until finally the same
block is bad on all devices.

You said if all disks get a read error the last disks is kicked.  What data
is returned to the user?  Normally, the array would go off-line.  But since
you still have 1 or more disks in the array, it is a new condition.

My guess is that you have not given this enough thought.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Monday, January 10, 2005 2:19 AM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> DOES kick a disk out on read error, but also DOES RETRY the read from
> another disk for that sector.  Currently he does that in the resync
> thread. 
> 
> He needs a list of failed reads and only needs to kick the disk when
> recovery fails.

Well, here is a patch to at least stop the array (RAID 1) being failed
until all possible read sources have been exhausted for the sector in
question.  It's untested - I only checked that it compiles.

The idea here is to modify raid1.c so that

   1) in make_request, on read (as well as on write, where we already do
      it) we set the master bios "remaining" count to the number of viable
      disks in the array.

      That's the third of the three hunks in the patch below and is
      harmless unless somebody somewhere already uses the "remaining"
      field in the read branch.  I don't see it if so.

   2) in raid1_end_request, I pushed the if (!uptodate) test which
      faults the current disk out of the array down a few lines (past no
      code at all, just a branch test for READ or WRITE) and copied it
      into both the start of the READ and WRITE branches of the code.

      That shows up very badly under diff, which makes it look as
      though I did something else entirely. But that's all, and that
      is harmless. This is the first two hunks of the patch below.
      Diff makes it look as though I moved the branch UP, but I
      moved the code before the branch DOWN.

      After moving the faulting code into the two branches, in the
      READ branch ONLY I weakened the condition that faulted the disk
      from "if !uptodate" to "if !uptodate and there is no other source
      to try".

      That's probably harmless in itself, modulo accounting questions -
      there might be things like nr_pending still to tweak.

This leaves things a bit unfair - "don't come any closer or the hacker
gets it".  The LAST disk that fails a read, in case all disks fail to
read on that sector, gets ejected from the array.  But which it is is
random, depending on the order we try (anyone know if the
rechedule_retry call is "fair" in the technical sense?). In my opinion 
no disk should ever be ejected from the array in these cicumstances -
it's just a read error produced by the array as a whole and we have
already done our bestto avoid it and can do on more. In a strong sense,
as it sems to me, "error is the correct read result". I've marked what
line to comment with /* PTB ... */ in the patch.



--- linux-2.6.3/drivers/md/raid1.c.orig	Tue Dec 28 00:39:01 2004
+++ linux-2.6.3/drivers/md/raid1.c	Mon Jan 10 07:39:38 2005
@@ -354,9 +354,15 @@
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+	update_head_pos(mirror, r1_bio);
+	if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
+	        if (!uptodate
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+                        && atomic_dec_and_test(&r1_bio->remaining)
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
+                        ) { /* PTB remove next line to be much fairer! */
+		        md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+                } else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -368,8 +374,6 @@
 		 */
		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
-	update_head_pos(mirror, r1_bio);
-	if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
 		if (!r1_bio->read_bio)
 			BUG();
 		/*
@@ -387,6 +391,20 @@
 			reschedule_retry(r1_bio);
 		}
 	} else {
+	        if (!uptodate)
+		        md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+	        else
+		/*
+		 * Set R1BIO_Uptodate in our master bio, so that
+		 * we will return a good error code for to the higher
+		 * levels even if IO on some other mirrored buffer fails.
+		 *
+		 * The 'master' represents the composite IO operation to
+		 * user-side. So if something waits for IO, then it will
+		 * wait for the 'master' bio.
+		 */
+		        set_bit(R1BIO_Uptodate, &r1_bio->state);
+
 
 		if (r1_bio->read_bio)
 			BUG();
@@ -708,6 +726,19 @@
 		read_bio->bi_end_io = raid1_end_request;
 		read_bio->bi_rw = r1_bio->cmd;
 		read_bio->bi_private = r1_bio;
+
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+	        atomic_set(&r1_bio->remaining, 0);
+	        /* select target devices under spinlock */
+	        spin_lock_irq(&conf->device_lock);
+	        for (i = 0;  i < disks; i++) {
+		        if (conf->mirrors[i].rdev &&
+		        !conf->mirrors[i].rdev->faulty) {
+		                atomic_inc(&r1_bio->remaining);
+		        } 
+	        }
+	        spin_unlock_irq(&conf->device_lock);
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
 
 		generic_make_request(read_bio);
 		return 0;

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

