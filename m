From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 19:34:08 +0100
Message-ID: <02a8b2-44r.ln1@news.it.uc3m.es>
References: <200501091623.j09GNG917488@www.watkins-home.com> <41E15D73.9020203@tls.msk.ru> <qj78b2-jqk.ln1@news.it.uc3m.es> <41E17117.2090500@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> There where some patches posted to this list some time ago that tries to
> do just that (or a discussion.. i don't remember).  Yes, md code currently
> doesn't do such things, and fails a drive after the first error -- it's
> the simplest way to go ;)

There would be two things to do (for raid1):

  1) make the raid1_end_request code notice a failure on READ, but not
     panic, simply resubmit the i/o to another mirror (it has to count
     "tries") and only give up after the last try has failed.

  2) hmmm .. is there a 2)? Well, maybe. Perhasp check that read errors
     per bio (as opposed to per request) don't fault the disk to the
     upper layers ..  I don't think they can. And possible arrange for 
     2 read bios to be prepared but only one to be sent, and discard
     the second if the first succeeds, or try it if the first fails.

Actually, looking at raid1_end_request, it looks as though it does try
again:

       if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
                 ...
                /*
                 * we have only one bio on the read side
                 */
                if (uptodate)
                        raid_end_bio_io(r1_bio);
                else {
                        /*
                         * oops, read error:
                         */
                        char b[BDEVNAME_SIZE];
                        printk(KERN_ERR "raid1: %s: rescheduling sector %llu\n",
                                bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
                        reschedule_retry(r1_bio);
                }
        } 

But does reschedule_retry try a different disk?  Anyway, there is maybe
a mistake in this code because we decrement the number of outsanding
reads in all cases:

        atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
        return 0;

but if the read is retried it should not be unpended yet!  Well, that
depends on your logic ..  I suppose that morally the request should be
unpended, but not the read, which is still pending.  And I seem to
remember that nr_pending is to tell the raid layers if we are in use or
not, so I don't think we want to unpend here.

Well, reschedule_retry does try the same read again:

 static void reschedule_retry(r1bio_t *r1_bio)
 {
        unsigned long flags;
        mddev_t *mddev = r1_bio->mddev;

        spin_lock_irqsave(&retry_list_lock, flags);
        list_add(&r1_bio->retry_list, &retry_list_head);
        spin_unlock_irqrestore(&retry_list_lock, flags);

        md_wakeup_thread(mddev->thread);
 }

So it adds the whole read request (using the master, not the bio that
failed) onto a retry list.  Maybe that list will be checked for
nonemptiness, which solves the nr_pending problem.

It looks like a separate kernel thread (raid1d) does the retries.

And bless me but if it doesn't try and send the read elsewhere ...

               case READ:
               case READA:
                        if (map(mddev, &rdev) == -1) {
                                printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
                                " read error for block %llu\n",
                                bdevname(bio->bi_bdev,b),
                                (unsigned long long)r1_bio->sector);
                                raid_end_bio_io(r1_bio);
                                break;
                        }

Not sure what that is about (?? disk is not in array?), but the next
bit is clear:

                        printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
                                " another mirror\n",
                                bdevname(rdev->bdev,b),
                                (unsigned long long)r1_bio->sector);

So it will try and redirect. It rewrites the target of the bio:

                        bio->bi_bdev = rdev->bdev;
                        ..
                        bio->bi_sector = r1_bio->sector + rdev->data_offset;

It resets the offset in case it is different for this disk.

                        bio->bi_rw = r1_bio->cmd;

Dunno why it needs to do that. It should be unchanged.

                        generic_make_request(bio);

And submit.

                        break;


So it looks to me as though reads ARE redirected. It would be trivial t
do a write on the failed disk to.


Peter



