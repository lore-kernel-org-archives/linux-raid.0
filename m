From: Eivind Sarto <eivindsarto@gmail.com>
Subject: patch: raid5: avoid release list until last reference
Date: Fri, 21 Mar 2014 11:52:16 -0700
Message-ID: <4DC020F4-7863-46FE-8DA9-521A8AA71939@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_164177FE-8A2E-45E7-8149-2F2F6E19ADBB"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_164177FE-8A2E-45E7-8149-2F2F6E19ADBB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Here is a very simple raid5 performance patch that reduces the number of =
times a stripe is queued
on the release list.
Whenever IO is scheduled for N chunks, the stripe may be queued on the =
release list up to N+1 times.
But, it is only handled when the reference drops to zero.
For each IO that completes, the stripe is again queued on the release =
list.  It is not until the last IO
completes that the stripe needs to be put on the release list.  All the =
other times the stripe is queued
does nothing other than add useless processing and lock contention.

This patch will reduce the number of times raid5d (or kworkers, if =
enabled) are woken up.  The
number of stripes that are queued on the release list will be reduced to =
1/3 or 1/2 depending on the
type of write workload.

Eivind Sarto

--Apple-Mail=_164177FE-8A2E-45E7-8149-2F2F6E19ADBB
Content-Disposition: attachment;
	filename=raid5.patch
Content-Type: application/octet-stream;
	name="raid5.patch"
Content-Transfer-Encoding: 7bit

From: Eivind Sarto <eivindsarto@gmail.com>
Date: Fri Mar 21 10:46:31 PDT 2014
Subject: raid5: avoid release list until last reference

This is a simple performance patch that will attempt to avoid queueing
the stripe on the release list until the last reference on the stripe.
Currently, the stripe is always queued on the release list.  Whenever IO
is scheduled for N chunks the reference count will be N+1 and the stripe
is queued on the release list N+1 times.  raid5d (or the kworkers) will
will not do any useful work on this stripe until the last reference, or
the last IO completes.

Queuing the stripe on the release list up to N+1 times just adds additional
processing and also additional contension for the device lock.

This may look like a race since two cpus could possibly both decide to take
the "slow_path" when the count is 2.  But, the stripe will then just be
released in the slow_path without being queued on the release list.

This patch will reduce raid5 processing with or without enabling the
kernel worker threads.

The performance improvement will depend on the number of drives used in
the array and also on the size of the writes.  I ran some tests on a
6-drive array using some extremely fast flash drives, causing the md-thread
and kworkers to be almosy saturated.  I measured as much as 10% improvment in
write throughput.  I have not tested with slower drives, but I don't expect
throughput will improve much unless the md-thread or kworkers can be pushed to
near saturation.  But, this patch will reduce processing and the number of
times the device lock is grabbed.

--- a/drivers/md/raid5.c	2014-03-03 11:57:58.000000000 -0800
+++ b/drivers/md/raid5.c	2014-03-21 10:43:45.000000000 -0700
@@ -413,6 +413,13 @@ static void release_stripe(struct stripe
 	int hash;
 	bool wakeup;
 
+	/* Try to avoid release_list until the last reference.
+	 * This will reduce the number of times the stripe is
+	 * processed by raid5d or kworkers.
+	 */
+	if (atomic_read(&sh->count) > 1)
+		goto slow_path;
+
 	if (unlikely(!conf->mddev->thread) ||
 		test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
 		goto slow_path;

--Apple-Mail=_164177FE-8A2E-45E7-8149-2F2F6E19ADBB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

 
--Apple-Mail=_164177FE-8A2E-45E7-8149-2F2F6E19ADBB--
