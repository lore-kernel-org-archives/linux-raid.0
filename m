From: Paul Clements <paul.clements@steeleye.com>
Subject: [BUG] raid1: barrier retry does not work correctly with write-behind
Date: Thu, 03 Aug 2006 11:44:06 -0400
Message-ID: <44D219C6.3090505@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Description:
-----------
When a filesystem sends a barrier write down to raid1, raid1 tries to 
pass the write down to its component devices. However, if one or more of 
the devices return EOPNOTSUPP, it means that they do not support 
barriers, and raid1 must strip the barrier out of the write and retry 
it. Now, this all works fine in most cases. However, in a raid1 mirror 
with write-behind enabled, we end up getting a corrupt bio sent down for 
the write retry. The bug is in the following code (raid1.c, line 1409):

} else if (test_bit(R1BIO_BarrierRetry, &r1_bio->state)) {
      /* some requests in the r1bio were BIO_RW_BARRIER
       * requests which failed with -EOPNOTSUPP.  Hohumm..
       * Better resubmit without the barrier.
       * We know which devices to resubmit for, because
       * all others have had their bios[] entry cleared.
       * We already have a nr_pending reference on these rdevs.
       */
      int i;
      clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
      clear_bit(R1BIO_Barrier, &r1_bio->state);
      for (i=0; i < conf->raid_disks; i++)
          if (r1_bio->bios[i])
              atomic_inc(&r1_bio->remaining);
      for (i=0; i < conf->raid_disks; i++)
          if (r1_bio->bios[i]) {
              struct bio_vec *bvec;
              int j;

              bio = bio_clone(r1_bio->master_bio, GFP_NOIO);


The r1_bio->master_bio may already have had end_io() called and been 
freed by the time we bio_clone() it. This results in an invalid bio 
being sent down to one (or more) of the raid1 components. In my testing, 
the original 4K barrier write ended up being a zero length write when it 
was retried.

Solution:
--------
Can we just bio_alloc instead of cloning? I think we have all the sector 
and offset data in the r1_bio. We could then bio_add_page() the pages 
into the new bio, possibly? Or could we just use the original bio that 
failed, being careful to clean up fields (I think we used to do this but 
Neil changed the behavior because of some problems).

--
Paul
