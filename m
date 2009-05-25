From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/6] md: More sector_t conversions -- intro
Date: Tue, 26 May 2009 09:49:27 +1000
Message-ID: <18971.11911.795582.413933@notabene.brown>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday May 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 25, maan@systemlinux.org wrote:
> Hi
> 
> this patch set against the for-next tree as of last Friday converts a
> couple of remaining internal representation of md sizes to sector_t,
> fixes a bug in the reshape code and adds a couple of trivial cleanups.
> 
> Patch #1 converts mddev->chunk_size which was previously stored
> in bytes.  Patch #2 fixes what I believe is a bug in super_1_sync()
> and might be a candiate for -stable. Patches #3 and #4 are further
> straight-forward conversions that deal with mddev->new_chunk,
> conf->chunk_size and conf->prev_chunk. Patches #5 and #6 are pure
> cleanups.

Thanks.
With the exception of #2, and with the other changes I mentioned,
there are all i my for-next now.

Even #2 was useful.  It helped me to realise that super_1_sync wasn't
writing out any changed to level/layout/chunk_size.  Until just
recently these couldn't change so there was no point.  But now
they can.  So I added another patch (below) to my for-linus set and
modified your patches to match.

> 
> All patches pass the tests of the mdadm test suite except
> 07reshape5intr which appears fail also for the vanilla for-next tree.

Hmm... I guess I should look into that!

Thanks,
NeilBrown


commit 62e1e389f87a8839ad83b08c44691d1df8320846
Author: NeilBrown <neilb@suse.de>
Date:   Tue May 26 09:40:59 2009 +1000

    md: always update level / chunk_size / layout when writing v1.x metadata.
    
    We previously didn't update these fields when writing the metadata
    because they could never change.  They can now, so we better write
    them.
    v0.90 metadata always updated these fields.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fccc834..aa79d55 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1375,6 +1375,9 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
 	sb->size = cpu_to_le64(mddev->dev_sectors);
+	sb->chunksize = cpu_to_le32(mddev->chunk_size >> 9);
+	sb->level = cpu_to_le32(mddev->level);
+	sb->layout = cpu_to_le32(mddev->layout);
 
 	if (mddev->bitmap && mddev->bitmap_file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
