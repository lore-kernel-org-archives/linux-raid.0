From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: [PATCH v2] md: protect against crash upon fsync on ro array
Date: Mon, 28 Jan 2013 11:32:03 +0100
Message-ID: <510653A3.9090403@profitbricks.com>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk> <5102A01B.7000407@profitbricks.com> <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk> <20130127163942.GA28572@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090604020901070109050707"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130127163942.GA28572@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090604020901070109050707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Subject was: Re: fsync() on read-only RAID triggers BUG

On 27.01.2013 17:39, Christoph Hellwig wrote:
> On Sat, Jan 26, 2013 at 07:44:40PM +0000, Ben Hutchings wrote:
>> I applied this on top of 3.2.37 and it certainly fixes the crash.
>> However I wonder whether fsync() should fail or should immediately
>> succeed.  I don't know whether the installer expects it to succeed.
> 
> It should succeed.

O.K., then I hope Neil applies the attached patch. I've changed the
return value to success.

This is also something for linux-stable and should apply to many kernel
versions without an issue.

--------------090604020901070109050707
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-md-protect-against-crash-upon-fsync-on-ro-array.txt"

From fe0357344877c9b9cc623fd582a4e0670e448317 Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Date: Fri, 25 Jan 2013 12:46:59 +0100
Subject: [PATCH v2] md: protect against crash upon fsync on ro array

If an fsync occurrs on a read-only array, we need to send a
completion for the IO and may not increment the active IO count.
Otherwise, we hit a bug trace and can't stop the MD array anymore.

By advice of Christoph Hellwig we silently return success.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>

---
 drivers/md/md.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3db3d1b..475e0be 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -322,6 +322,11 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 		}
 		finish_wait(&mddev->sb_wait, &__wait);
 	}
+	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
+		rcu_read_unlock();
+		bio_endio(bio, 0);
+		return;
+	}
 	atomic_inc(&mddev->active_io);
 	rcu_read_unlock();
 
-- 
1.7.1


--------------090604020901070109050707--
