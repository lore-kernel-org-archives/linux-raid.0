From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: md: raid5 resync corrects read errors on data block - is this correct?
Date: Thu, 13 Sep 2012 19:05:35 +0300
Message-ID: <CAGRgLy7VRTeegGXbxhzn4zrCt6agoQqLaOT5mM7=vSkq6XDN5A@mail.gmail.com>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
	<20120912082909.33c8eec0@notabene.brown>
	<CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
	<20120913101924.13431e6e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120913101924.13431e6e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
below please find the patch. It got pretty ugly, so even if you don't
apply it, please comment. Did I miss anything?
As we discussed some time ago, the usage of mddev->recovery_cp is
overloaded in MD - it indicates both the resync progress and also
whether array is dirty due to ongoing writes. So I tried to somehow
differentiate between these two. I did not manage to repro yet the
"needed" and "transitional" parts. I also don't force reconstruct on
"check" and "repair". I tested the patch on kernel 3.2.

Finally, I asked you some time ago about how MD treats stripes when it
is rebuilding a drive. So now I dug in the code, and found out that
absolutely everything you told me was correct. Amazing!

Thanks,
Alex.


---------------------------
From e876cddae5768bc7f6bdcbd617f36ea3a12445aa Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadarastorage.com>
Date: Thu, 13 Sep 2012 18:55:00 +0300
Subject: [PATCH] When RAID5 is dirty, force reconstruct-write instead of
 read-modify-write.

Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: Yair Hershko <yair@zadarastorage.com>

diff --git a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
index 5332202..fa03410 100644
--- a/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
+++ b/ubuntu_kmodules/Ubuntu-3.2.0-25.40/drivers/md/raid5.c
@@ -2561,26 +2561,54 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		 * look like rcw is cheaper
 		 */
 		rcw = 1; rmw = 2;
-	} else for (i = disks; i--; ) {
-		/* would I have to read this buffer for read_modify_write */
-		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx) &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags))
-				rmw++;
-			else
-				rmw += 2*disks;  /* cannot read it */
-		}
-		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
-			else
-				rcw += 2*disks;
+	} else {
+		/* Attempt to check whether resync is now happening.
+		 * If yes, the array is dirty (after unclean shutdown or
+		 * initial creation), so parity in some stripes might be inconsistent.
+		 * In this case, we need to always do reconstruct-write, to ensure
+		 * that in case of drive failure or read-error correction, we
+		 * generate correct data from the parity.
+		 */
+		sector_t recovery_cp = conf->mddev->recovery_cp;
+		unsigned long recovery = conf->mddev->recovery;
+		int needed = test_bit(MD_RECOVERY_NEEDED, &recovery);
+		int resyncing = test_bit(MD_RECOVERY_SYNC, &recovery) &&
+			            !test_bit(MD_RECOVERY_REQUESTED, &recovery) &&
+			            !test_bit(MD_RECOVERY_CHECK, &recovery);
+		int transitional = test_bit(MD_RECOVERY_RUNNING, &recovery) &&
+			               !test_bit(MD_RECOVERY_SYNC, &recovery) &&
+			               !test_bit(MD_RECOVERY_RECOVER, &recovery) &&
+			               !test_bit(MD_RECOVERY_DONE, &recovery) &&
+			               !test_bit(MD_RECOVERY_RESHAPE, &recovery);
+		
+		/* If array is dirty and should start resync or already resyncing */
+		if (recovery_cp < MaxSector && sh->sector >= recovery_cp &&
+			(needed || resyncing || transitional)) {
+			/* Force reconstruct-write */
+			rcw = 1; rmw = 2;
+			pr_debug("dirty, force RCW recovery_cp=%lu sh->sector=%lu recovery=0x%lx\n",
+				     recovery_cp, sh->sector, recovery);
+		} else for (i = disks; i--; ) {
+			/* would I have to read this buffer for read_modify_write */
+			struct r5dev *dev = &sh->dev[i];
+			if ((dev->towrite || i == sh->pd_idx) &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags))
+					rmw++;
+				else
+					rmw += 2*disks;  /* cannot read it */
+			}
+			/* Would I have to read this buffer for reconstruct_write */
+			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags))) {
+				if (test_bit(R5_Insync, &dev->flags)) rcw++;
+				else
+					rcw += 2*disks;
+			}
 		}
 	}
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",





On Thu, Sep 13, 2012 at 3:19 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 12 Sep 2012 19:49:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> I have done some more investigation on that.
>>
>> I see that according to handle_stripe_dirtying(), raid6 always does
>> reconstruct-write, while raid5 checks what will be cheaper in terms of
>> IOs - read-modify-write or reconstruct-write. For example, for a
>> 3-drive raid5, both are the same, so because of:
>>
>> if (rmw < rcw && rmw > 0)
>> ... /* this is not picked, because in this case rmw==rcw==1 */
>>
>> reconstruct-write is always performed for such 3-drvie raid5. Is this correct?
>
> Yes.
>
>>
>> The issue with doing read-modify-writes is that later we have no
>> reliable way to know whether the parity block is correct - when we
>> later do reconstruct-write because of a read error, for example. For
>> read requests we could have perhaps checked the bitmap, and do
>> reconstruct-write if the relevant bit is not set, but for write
>> requests the relevant bit will always be set, because it is set when
>> the write is started.
>>
>> I tried the following scenario, which showed a data corruption:
>> # Create 4-drive raid5 in "--force" mode, so resync starts
>> # Write one sector on a stripe that resync has not handled yet. RMW is
>> performed, but the parity is incorrect because two other data blocks
>> were not taken into account (they contain garbage).
>> # Induce a read-error on the sector that I just wrote to
>> # Let resync handle this stripe
>>
>> As a result, resync corrects my sector using other two data blocks +
>> parity block, which is out of sync. When I read back the sector, data
>> is incorrect.
>>
>> I see that I can easily enforce raid5 to always do reconstruct-write,
>> the same way like you do for raid6. However, I realize that for
>> performance reasons, it is better to do RMW if possible.
>>
>> What do you think about the following rough suggestion: in
>> handle_stripe_dirtying() check whether resync is ongoing or should be
>> started - using MD_RECOVERY_SYNC, for example. If there is an ongoing
>> resync, there is a good reason for that, probably parity on some
>> stripes is out of date. So in that case, always force
>> reconstruct-write. Otherwise, count what is cheaper like you do now.
>> (Can RCW be really cheaper than RMW?)
>>
>> So during resync, array performance will be lower, but we will ensure
>> that all stripe-blocks are consistent. What do you think?
>
> I'm fairly sure we used to do that - long long ago. (hunts through git
> history...)  No.  The code-fragment was there but it was commented out.
>
> I think it would be good to avoid 'rmw' if the sector offset is less than
> recovery_cp.
>
> Care to write a patch?
>
> Thanks,
> NeilBrown
