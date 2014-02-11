From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [PATCH 1/1] md/raid5: allow resync-rebuild requests to run multi-threaded
Date: Mon, 10 Feb 2014 17:52:02 -0800
Message-ID: <7847F3C0-2B56-48E7-802C-0FBA937FD44F@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_A1696C09-B87F-4D38-BA74-04F221B1359C"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_A1696C09-B87F-4D38-BA74-04F221B1359C
Content-Disposition: attachment;
	filename=raid5.patch
Content-Type: application/octet-stream;
	name="raid5.patch"
Content-Transfer-Encoding: 7bit

Author: Eivind Sarto <eivind.sarto@gmail.com>
Date: Mon Feb 10 17:42:09 2014

    md/raid5: allow resync/rebuild requests to run multi-threaded

    Sync operations are currently handled within the sync thread, making the
    execution single-threaded.  This patch will allow the processing to be done
    parallel by raid5d (and a pool of kworkers), significantly increasing
    rebuild/resync throughput.

    Signed-off-by: Eivind Sarto <eivind.sarto@gmail.com>

--- a/drivers/md/raid5.c	2014-02-10 17:18:43.000000000 -0800
+++ b/drivers/md/raid5.c	2014-02-10 17:21:49.000000000 -0800
@@ -5026,8 +5026,8 @@ static inline sector_t sync_request(stru
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
+	set_bit(STRIPE_HANDLE, &sh->state);
 
-	handle_stripe(sh);
 	release_stripe(sh);
 
 	return STRIPE_SECTORS;

--Apple-Mail=_A1696C09-B87F-4D38-BA74-04F221B1359C--
