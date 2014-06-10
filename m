From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [patch 1/1] raid5: speedup sync_request processing
Date: Mon, 9 Jun 2014 17:03:25 -0700
Message-ID: <8133F95E-0053-4DCB-B5BB-480A8278B281@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This is a trivial patch that improves rebuild/resync speed of raid5 arrays.
Instead of having the resync-thread handle the stripe, it now just sets STRIPE_HANDLE and
releases the stripe.  Allowing the resync-thread to return immediately and schedule more operations.

The speedup will increase with more drives in the array.  And it will increase further if additional
kworker threads are enabled.  But, it improves with just the default raid5d() running.

Note: I posted this patch a while back, but nothing happened.  Not accepted, not rejected.

Trying one more time.

-eivind