From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/6] md: More sector_t conversions -- intro
Date: Tue, 26 May 2009 12:40:39 +1000
Message-ID: <18971.22183.861530.508422@notabene.brown>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
	<18971.11911.795582.413933@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Tuesday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 26, neilb@suse.de wrote:
> > 
> > All patches pass the tests of the mdadm test suite except
> > 07reshape5intr which appears fail also for the vanilla for-next tree.
> 
> Hmm... I guess I should look into that!

Yep. There is a big there.  Thanks for helping find it.

Here is the patch.

Thanks,
NeilBrown


Author: NeilBrown <neilb@suse.de>
Date:   Tue May 26 12:39:27 2009 +1000

    md: raid5: avoid sector values going negative when testing reshape progress.
    
    As sector_t in unsigned, we cannot afford to let 'safepos' etc go
    negative.
    So replace
       a -= b;
    by
       a -= min(b,a);
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6b89a7e..dce7741 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3810,13 +3810,13 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->delta_disks < 0) {
-		writepos -= reshape_sectors;
+		writepos -= min(reshape_sectors, writepos);
 		readpos += reshape_sectors;
 		safepos += reshape_sectors;
 	} else {
 		writepos += reshape_sectors;
-		readpos -= reshape_sectors;
-		safepos -= reshape_sectors;
+		readpos -= min(reshape_sectors, readpos);
+		safepos -= min(reshape_sectors, safepos);
 	}
 
 	/* 'writepos' is the most advanced device address we might write.
