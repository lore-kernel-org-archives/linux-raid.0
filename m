From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: RAID 5 rebuild fails with power interruption.
Date: Wed, 25 Nov 2009 19:50:47 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02B43EC7@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com><87y6m759o2.fsf@frosties.localdomain><8338BD137FF1B64EB341218BD702985E02AB90B8@BLR-EC-MBX03.wipro.com><20091117094720.4c8736d7@notabene.brown><8338BD137FF1B64EB341218BD702985E02AB9233@BLR-EC-MBX03.wipro.com><20091118163655.2ef3f00d@notabene.brown><8338BD137FF1B64EB341218BD702985E02B43A2A@BLR-EC-MBX03.wipro.com> <20091125131413.51a37b79@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091125131413.51a37b79@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

The patch you have provided doesn't seem to go with the code we use.
We use the md driver that comes with linux-1.16.8 source code.
Could you pls suggest the changes for this version of md?

Thanks,
Senthil M 

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Wednesday, November 25, 2009 7:44 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment);
linux-raid@vger.kernel.org
Subject: Re: RAID 5 rebuild fails with power interruption.


(adding linux-raid back in to the CC list - please don't drop Cc's)

On Mon, 23 Nov 2009 19:01:31 +0530 <senthilkumar.muthukalai@wipro.com>
wrote:

> Hi Neil,
> 
> I applied the patch to our code as seen below.
> But then the disk is kicked out of the array while the system is power
> interrupted.
> Should I use --force option always to ensure the disk is not thrown
> out in this case?
> Pls advice.

It looks like you need one extra change in that patch for it to
be completely reliable.  See below.

Note that if you interrupt power while the array is degraded (which is
the case while it is recovering to a spare), and the array was active
at that time (i.e. there had been a write in the last 200ms or so),
then you will have a "dirty degraded" array and mdadm will refuse to
assemble such an array unless you use --force.
This is because when an array is 'dirty' you cannot trust the parity
to be correct, and when it is degraded you might have some data missing,
and that data cannot reliably be recovered from the parity (because we
don't trust the parity).

Pulling the power on a RAID5 array simply is not a good idea.

NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index b2a9ebc..e68b254 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1517,12 +1517,10 @@ static void super_1_sync(mddev_t *mddev,
mdk_rdev_t *rdev)
 
 	if (rdev->raid_disk >= 0 &&
 	    !test_bit(In_sync, &rdev->flags)) {
-		if (rdev->recovery_offset > 0) {
-			sb->feature_map |=
-				cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
-			sb->recovery_offset =
-				cpu_to_le64(rdev->recovery_offset);
-		}
+		sb->feature_map |=
+			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
+		sb->recovery_offset =
+			cpu_to_le64(rdev->recovery_offset);
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -1556,7 +1554,7 @@ static void super_1_sync(mddev_t *mddev,
mdk_rdev_t *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] =
cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >= 0 && rdev2->recovery_offset
> 0)
+		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] =
cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
@@ -6769,6 +6767,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 						       nm,
mdname(mddev));
 					spares++;
 					md_new_event(mddev);
+					set_bit(MD_CHANGE_DEVS,
&mddev->flags);
 				} else
 					break;
 			}
