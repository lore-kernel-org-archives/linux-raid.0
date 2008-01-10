From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Thu, 10 Jan 2008 11:09:54 +1100
Message-ID: <18309.25170.258730.225322@notabene.brown>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
	<alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
	<Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
	<e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
	<alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>
	<e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com>
	<alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>
	<1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday January 9
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 9, dan.j.williams@intel.com wrote:
> On Sun, 2007-12-30 at 10:58 -0700, dean gaudet wrote:
> > i have evidence pointing to d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> > 
> > which was Neil's change in 2.6.22 for deferring generic_make_request 
> > until there's enough stack space for it.
> > 
> 
> Commit d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 reduced stack utilization
> by preventing recursive calls to generic_make_request.  However the
> following conditions can cause raid5 to hang until 'stripe_cache_size' is
> increased:
> 

Thanks for pursuing this guys.  That explanation certainly sounds very
credible.

The generic_make_request_immed is a good way to confirm that we have
found the bug,  but I don't like it as a long term solution, as it
just reintroduced the problem that we were trying to solve with the
problematic commit.

As you say, we could arrange that all request submission happens in
raid5d and I think this is the right way to proceed.  However we can
still take some of the work into the thread that is submitting the
IO by calling "raid5d()" at the end of make_request, like this.

Can you test it please?  Does it seem reasonable?

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c    |    2 +-
 ./drivers/md/raid5.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-07 13:32:10.000000000 +1100
+++ ./drivers/md/md.c	2008-01-10 11:08:02.000000000 +1100
@@ -5774,7 +5774,7 @@ void md_check_recovery(mddev_t *mddev)
 	if (mddev->ro)
 		return;
 
-	if (signal_pending(current)) {
+	if (current == mddev->thread->tsk && signal_pending(current)) {
 		if (mddev->pers->sync_request) {
 			printk(KERN_INFO "md: %s in immediate safe mode\n",
 			       mdname(mddev));

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-07 13:32:10.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-10 11:06:54.000000000 +1100
@@ -3432,6 +3432,7 @@ static int chunk_aligned_read(struct req
 	}
 }
 
+static void raid5d (mddev_t *mddev);
 
 static int make_request(struct request_queue *q, struct bio * bi)
 {
@@ -3547,7 +3548,7 @@ static int make_request(struct request_q
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
+			set_bit(STRIPE_HANDLE, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -3569,6 +3570,7 @@ static int make_request(struct request_q
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
 			        ? 0 : -EIO);
 	}
+	raid5d(mddev);
 	return 0;
 }
 
