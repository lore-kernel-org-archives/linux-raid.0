From: Foster_Brian@emc.com
Subject: RE: Linux RAID version question
Date: Fri, 24 Nov 2006 23:07:53 -0500
Message-ID: <981224FF5B88B349B7C1FED584D2620E07328A52@CORPUSMX50B.corp.emc.com>
References: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: marinkovic.dragan@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Dragan Marinkovic
> Sent: Thursday, November 23, 2006 8:49 PM
> To: linux-raid@vger.kernel.org
> Subject: Linux RAID version question
 
> 2. RAIDs built with metadata version 0.9 does not always continue
> rebuilding where they left off when last stopped (specifically on the
> clean shutdown while the raid is still rebuilding).

I have a followup question on your second point, as I've been
coincidentally searching for the same feature. I'm running 2.6.17 with
the MD_FEATURE_OFFSET_RECOVERY patches (and also have tried 2.6.18) and
do not observe recovery/resync checkpoint behavior across clean array
shutdowns (4 drive RAID 5).

From attempting to learn some of the md code, it appears the framework
is there to support this, but I had to make the following changes to
achieve desired behavior:

--- drivers/md/md.c	2006-11-24 18:03:24.000000000 -0500
+++ drivers/md/md.c	2006-11-24 17:52:28.000000000 -0500
@@ -4883,7 +4883,6 @@ void md_do_sync(mddev_t *mddev)
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
@@ -4893,6 +4892,7 @@ void md_do_sync(mddev_t *mddev)
 					       "md: checkpointing
recovery of %s.\n",
 					       mdname(mddev));
 					mddev->recovery_cp =
mddev->curr_resync;
+					mddev->sb_dirty = 1;
 				}
 			} else
 				mddev->recovery_cp = MaxSector;

I removed the check for MD_RECOVERY_SYNC, which was preventing a clean
shutdown during recovery from hitting the code that sets
recovery_offset. I was a bit confused about the logic there, as the
MD_RECOVERY_SYNC flag is checked again within that code block.. (?) I
have hit the resync checkpoint code above, but the superblock is not
updated unless I set sb_dirty.

Am I missing something that would allow me to achieve this behavior
without such changes? If not, is there any reason why the recovery does
not currently checkpoint across array stoppage? Is this considered safe
in terms of functional correctness (i.e., is my data at risk if I
"continue" a recovery in this fashion)? Any insight is greatly
appreciated, thanks in advance...

Brian

