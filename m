From: NeilBrown <neilb@suse.de>
Subject: [PATCH 01/18] md: never clear bit from the write-intent bitmap when
	the array is degraded.
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.36919.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is safe to clear a bit from the write-intent bitmap for a raid1
when if we know the data has been written to all devices, which is
what the current test does.
But it is not always safe to update the 'events_cleared' counter in
that case.  This is one request could complete successfully after some
other request has partially failed.

So simply disable the clearing and updating of events_cleared whenever
the array is degraded.  This might end up not clearing some bits that
could safely be cleared, but it is safest approach.

Note that the bug fixed here did not risk corrupting data by letting
the array get out-of-sync.  Rather it meant that when a device is
removed and re-added to the array, it might incorrectly require a full
recovery rather than just recovering based on the bitmap.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 7199437..be29937 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1306,6 +1306,9 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		PRINTK(KERN_DEBUG "dec write-behind count %d/%d\n",
 		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
 	}
+	if (bitmap->mddev->degraded)
+		/* Never clear bits or update events_cleared when degraded */
+		success = 0;
 
 	while (sectors) {
 		int blocks;


