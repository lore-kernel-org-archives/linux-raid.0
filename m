From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID: Fix for ineffective "sync" directive
Date: Thu, 23 Aug 2012 10:31:54 -0500
Message-ID: <1345735914.25206.8.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

There are two ways I see to fix the problem of the "sync" table argument
not causing the array to re-sync.  We could set mddev->events to
UINT_MAX and force an mddev/bitmap event mismatch - causing the bitmap
code to set BITMAP_STALE itself.  Otherwise, we can do as I have below
and set BITMAP_STALE ourselves.  The real difference is whether this is
done before or after md_run().  The first solution can be done before
md_run(); the second cannot because the bitmap is allocated during
md_run().  Either solution works and correctly sets the bitmap to stale
before bitmap_load() is called.  So, rather than having to think about
issues that come with setting events to UINT_MAX, I chose to set the
bitmap stale after md_run().

 brassow

DM RAID: Fix for "sync" directive ineffectiveness

There are two table arguments that can be given to a DM RAID target that
control whether the array is forced to (re)synchronize or skip initialization:
"sync" and "nosync".  When "sync" is given, we set mddev->recovery_cp to 0
in order to cause the device to resynchronize.  This is insufficient if there
is a bitmap in use, because the array will simply look at the bitmap and see
that there is no recovery necessary.

Once md_run() is called and creates the bitmap, we set the bitmap as stale.
When the bitmap is loaded during the resume phase, a full resync will
result.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -1123,6 +1123,10 @@ static int raid_ctr(struct dm_target *ti
 		ret = -EINVAL;
 		goto size_mismatch;
 	}
+
+	if (rs->print_flags & DMPF_SYNC)
+		set_bit(BITMAP_STALE, &(rs->md.bitmap->flags));
+
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 


