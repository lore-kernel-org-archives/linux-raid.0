From: Eivind Sarto <eivindsarto@gmail.com>
Subject: raid1 data corruption during resync
Date: Fri, 29 Aug 2014 12:29:52 -0700
Message-ID: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am seeing occasional data corruption during raid1 resync.
Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc231c9=
a90a278333c21f761 introduced a bug.
Prior to this commit raise_barrier() used to wait for conf->nr_pending =
to become zero.  It no longer does this.
It is not easy to reproduce the corruption, so I wanted to ask about th=
e following potential fix while I am still testing it.
Once I validate that the fix indeed works, I will post a proper patch.
Do you have any feedback?

=97 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
+++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
@@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
 	 *    handling.
 	 */
 	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen &&
+			    !conf->array_frozen && !conf->nr_pending &&
 			    conf->barrier < RESYNC_DEPTH &&
 			    (conf->start_next_window >=3D
 			     conf->next_resync + RESYNC_SECTORS),


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
