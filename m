From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Sat, 22 Feb 2003 23:51:41 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302222251.h1MMpfP10837@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au, mingo@redhat.comneilb@cse.unsw.edu.au
List-Id: linux-raid.ids

I'll set out here the basic couple of changes needed in the raid1
driver in order to allow async writes, once one has a bitmap. It's
a short trick, but I'd like somebody to tell me if the accounting
is in the right places still ...

The basic idea is that in an ordinary write, we mark the bitmap
before the write, and clear the bitmap in the last end_io of the
mirrored set of end_ios. So if we don't write all the mirrors,
well, it's because one errrored, which means the array will fault it,
and our bitmap will be dirty for that block, and the block will
be resynced when we put in a new disk component.

So we can afford to ack back to the user on the FIRST end_io of a 
mirrored set of writes, not the last. The remaining i_os are async.

The first change is in the final end_io function. It no longer
unconditionally acks the user i_o, only if nobody else has done
it yet.

        struct buffer_head *bh = r1_bh->master_bh;
        raid1_conf_t * conf = mddev_to_conf(r1_bh->mddev);

+       if (r1_bh->cmd == WRITE && !test_and_set_bit(R1BH_AsyncPhase, &r1_bh->state)) {
+
                io_request_done(bh->b_rsector, conf,
                        test_bit(R1BH_SyncPhase, &r1_bh->state));
                bh->b_end_io(bh, uptodate);
+       }


I think that io_request_done is alright there.  I assume it's
accounting.  The whole lot of the stuff which has been if'ed above can
now be done in an ordinary (nonfinal) end_io (raid1_end_request)
instead.  I just added an if on whether or not the io is successful,
with the whole lot above in. So it probably will result in a user ack
on the first i/o of a set. not the last.

        /*
         * WRITE:
         *
         * Let's see if all mirrored write operations have finished 
         * already.
         */

+       if (uptodate && !test_and_set_bit(R1BH_AsyncPhase, &r1_bh->state)) {
+               struct buffer_head *bh = r1_bh->master_bh;
+               raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);
+
+               io_request_done(bh->b_rsector, conf,
+                       test_bit(R1BH_SyncPhase, &r1_bh->state));
+               bh->b_end_io(bh, uptodate);
+       }

        if (atomic_dec_and_test(&r1_bh->remaining))
                raid1_end_bh_io(r1_bh, test_bit(R1BH_Uptodate, &r1_bh->state));


Peter
