From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [patch 1/1] raid5: avoid release list until last reference of the stripe
Date: Tue, 27 May 2014 18:35:11 -0700
Message-ID: <CC9129A7-569A-4065-A14B-C03A9E6DD091@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_C2A89D08-A665-4BD9-B2AD-AAC01360C2FE"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


--Apple-Mail=_C2A89D08-A665-4BD9-B2AD-AAC01360C2FE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

This simple patch will reduce the number of times stripes are queued on =
the release_list.
Currently stripes are queued more than twice as many times on this list =
as they need to be.

-eivind=

--Apple-Mail=_C2A89D08-A665-4BD9-B2AD-AAC01360C2FE
Content-Disposition: attachment;
	filename=raid5_avoid_release_list_until_last_reference.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="raid5_avoid_release_list_until_last_reference.patch"
Content-Transfer-Encoding: 7bit

Author: Eivind Sarto <esarto@fusionio.com>
Date: Fri Apr 11 12:54:33 2014

raid5: avoid release list until last reference of the stripe

The (lockless) release_list reduces lock contention, but there is excessive
queueing and dequeuing of stripes on this list.  A stripe will currently be
queued on the release_list with a stripe reference count > 1.  This can cause
the raid5 kernel thread(s) to dequeue the stripe and decrement the refcount
without doing any other useful processing of the stripe.  The are two cases
when the stripe can be put on the release_list multiple times before it is
actually handled by the kernel thread(s).
1) make_request() activates the stripe processing in 4k increments.  When a
   write request is large enough to span multiple chunks of a stripe_head, the
   first 4k chunk adds the stripe to the plug list.  The next 4k chunk that is
   processed for the same stripe puts the stripe on the release_list with a
   refcount=2.  This can cause the kernel thread to process and decrement the
   stripe before the stripe us unplugged, which again will put it back on the
   release_list.
2) Whenever IO is scheduled on a stripe (pre-read and/or write), the stripe
   refcount is set to the number of active IO (for each chunk).  The stripe is
   released as each IO complete, and can be queued and dequeued multiple times
   on the release_list, until its refcount finally reached zero.

This simple patch will ensure a stripe is only queued on the release_list when
its refcount=1 and is ready to be handled by the kernel thread(s).  I added some
instrumentation to raid5 and counted the number of times striped were queued on
the release_list for a variety of write IO sizes.  Without this patch the number
of times stripes got queued on the release_list was 100-500% higher than with
the patch.  The excess queuing will increase with the IO size.  The patch also
improved throughput by 5-10%.

Signed-off-by: Eivind Sarto <esarto@fusionio.com>

Index: current/drivers/md/raid5.c
===================================================================
--- current.orig/drivers/md/raid5.c
+++ current/drivers/md/raid5.c
@@ -423,6 +423,11 @@ static void release_stripe(struct stripe
 	int hash;
 	bool wakeup;
 
+	/* Avoid release_list until the last reference.
+	 */
+	if (atomic_add_unless(&sh->count, -1, 1))
+		return;
+
 	if (unlikely(!conf->mddev->thread) ||
 		test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
 		goto slow_path;

--Apple-Mail=_C2A89D08-A665-4BD9-B2AD-AAC01360C2FE--
