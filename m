From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: async writes in raid1
Date: Mon, 14 Apr 2003 21:32:18 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304141932.h3EJWI909629@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Apr 14, 2003 09:24:03 pm"
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago ptb wrote:"
> > Actually, I think you want to make sure, in the async case, that the
> > write to the _primary_ disk completes, as opposed to just the first
> > write...I think you could get the I/O completing out of order, right?
> 
> Hmm .. that's a point. It's not a question of out of order, so much as
> we want to give the maximum chance of getting one successful write and

Ooops .. I looked up the wrong bit of code in my reply. I looked at the
final end_req, instead of the mirrored i/o end_req. Yes, don't worry,
it's already done right. The ack happens early only if there is success
to report ("uptodate" is set)..


        /*
         * WRITE:
         *
         * Let's see if all mirrored write operations have finished 
         * already.
         *
         * In any case, do the end io early on the master bh if we are
         * uptodate, and AsyncIO is set on the bh. We set AsyncPhase
         * when this happens, so we don't do it twice, inadvertently.
         */

        if (uptodate
        &&  test_bit(R1BH_AsyncIO, &r1_bh->state)
        && !test_and_set_bit(R1BH_AsyncPhase, &r1_bh->state)) {

                struct buffer_head *mbh = r1_bh->master_bh;

                raid1_conf_t *conf = mddev_to_conf(r1_bh->mddev);

                PRINTK(KERN_DEBUG "raid1: async end i/o on sectors %lu-%lu\n",
                        mbh->b_rsector, mbh->b_rsector + (mbh->b_size >> 9) - 1);

                io_request_done(mbh->b_rsector, conf,
                        test_bit(R1BH_SyncPhase, &r1_bh->state));
                mbh->b_end_io(mbh, uptodate);
        }

Peter
