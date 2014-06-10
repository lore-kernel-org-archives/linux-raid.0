From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [patch 1/1] raid5: speedup sync_request processing
Date: Mon, 9 Jun 2014 17:06:19 -0700
Message-ID: <EC0B81A7-E03B-442F-B523-4B7154ABDC34@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_7D888C0A-86A3-41CB-857E-93A07444B60A"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


--Apple-Mail=_7D888C0A-86A3-41CB-857E-93A07444B60A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Ignore previous email.  Forgot to attach patch.

This is a trivial patch that improves rebuild/resync speed of raid5 =
arrays.
Instead of having the resync-thread handle the stripe, it now just sets =
STRIPE_HANDLE and
releases the stripe.  Allowing the resync-thread to return immediately =
and schedule more operations.

The speedup will increase with more drives in the array.  And it will =
increase further if additional
kworker threads are enabled.  But, it improves with just the default =
raid5d() running.

Note: I posted this patch a while back, but nothing happened.  Not =
accepted, not rejected.

Trying one more time.

-eivind=

--Apple-Mail=_7D888C0A-86A3-41CB-857E-93A07444B60A
Content-Disposition: attachment;
	filename=raid5_speedup_sync_request.patch
Content-Type: application/octet-stream;
	name="raid5_speedup_sync_request.patch"
Content-Transfer-Encoding: 7bit

Author: Eivind Sarto <esarto@fusionio.com>
Date: Mon Jun  9 16:51:26 2014

raid5: speedup sync_request processing

The raid5 sync_request() processing calls handle_stripe() within the context of
the resync-thread.  The resync-thread issues the first set of read requests
and this adds execution latency and slows down the scheduling of the next
sync_request().
The current rebuild/resync speed of raid5 is not much faster than what
rotational HDDs can sustain.
Testing the following patch on a 6-drive array, I can increase the rebuild
speed from 100 MB/s to 175 MB/s.
The sync_request() now just sets STRIPE_HANDLE and releases the stripe.  This
creates some more parallelism between the resync-thread and raid5 kernel daemon.

Signed-off-by: Eivind Sarto <esarto@fusionio.com>

Index: current/drivers/md/raid5.c
===================================================================
--- current.orig/drivers/md/raid5.c
+++ current/drivers/md/raid5.c
@@ -4425,8 +4425,8 @@ static inline sector_t sync_request(mdde
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
+	set_bit(STRIPE_HANDLE, &sh->state);
 
-	handle_stripe(sh);
 	release_stripe(sh);
 
 	return STRIPE_SECTORS;

--Apple-Mail=_7D888C0A-86A3-41CB-857E-93A07444B60A--
