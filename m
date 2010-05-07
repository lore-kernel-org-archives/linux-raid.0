From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Fri, 7 May 2010 19:47:04 +1000
Message-ID: <20100507194704.3ffcf17e@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
	<20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <717013.48748.qm@web31703.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Bryant <tenminjoe@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 May 2010 00:40:40 -0700 (PDT)
Joe Bryant <tenminjoe@yahoo.com> wrote:

> > I'll see about fixing that.
> >
> > Recreate the array with "--metadata 1.0" or "--metadata 1.2" and it should work better.
> 
> That's great, thanks very much.
> 

It turns out it is a bit more subtle than that, though that approach may work
for you.
If you make an odd number of changes to the metadata, it will switch from
doing what you want, to not.
e.g. if /dev/foo is your spare device, then

  mdadm /dev/md0 -f /dev/foo
  mdadm /dev/md0 -r /dev/foo
  mdadm /dev/md0 -a /dev/foo

will switch between working and not working.  v0.90 metadata starts out not
working.  v1.x start out working.

Alternately the following patch will fix it properly.

Thanks,
NeilBrown


From 12aee54f4fee61cdf4e594e501834737fd6b9605 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 7 May 2010 19:44:26 +1000
Subject: [PATCH] md: restore ability of spare drives to spin down.

Some time ago we stopped the clean/active metadata updates
from being written to a 'spare' device in most cases so that
it could spin down and say spun down.  Device failure/removal
etc are still recorded on spares.

However commit 51d5668cb2e3fd1827a55 broke this 50% of the time,
depending on whether the event count is even or odd.
The change log entry said:

   This means that the alignment between 'odd/even' and
    'clean/dirty' might take a little longer to attain,

how ever the code makes no attempt to create that alignment, so it
could take arbitrarily long.

So when we find that clean/dirty is not aligned with odd/even,
force a second metadata-update immediately.  There are already cases
where a second metadata-update is needed immediately (e.g. when a
device fails during the metadata update).  We just piggy-back on that.

Reported-by: Joe Bryant <tenminjoe@yahoo.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: stable@kernel.org

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 66ef15c..4996f27 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2217,12 +2217,18 @@ repeat:
 		if (!mddev->in_sync || mddev->recovery_cp != MaxSector) { /* not clean */
 			/* .. if the array isn't clean, an 'even' event must also go
 			 * to spares. */
-			if ((mddev->events&1)==0)
+			if ((mddev->events&1)==0) {
 				nospares = 0;
+				sync_req = 2; /* force a second update to get the
+					       * even/odd in sync */
+			}
 		} else {
 			/* otherwise an 'odd' event must go to spares */
-			if ((mddev->events&1))
+			if ((mddev->events&1)) {
 				nospares = 0;
+				sync_req = 2; /* force a second update to get the
+					       * even/odd in sync */
+			}
 		}
 	}
 
