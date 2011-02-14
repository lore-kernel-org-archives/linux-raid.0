From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Raid0 <-> Raid5 migrations (imsm)
Date: Mon, 14 Feb 2011 12:21:29 +1100
Message-ID: <20110214122129.6874e64a@notabene.brown>
References: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 11 Feb 2011 14:43:50 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> The following series implements Raid5 <-> Raid0 migrations
> for imsm metadata.
> 
> Patches should be applied on top of patches previously sent by me.
> 
> BR
> Adam
> 
> 
> ---
> 
> Adam Kwolek (4):
>       FIX: Target disk number depends on source raid level

I don't like this fix - it just addresses the obvious symptom rather
than the underlying problem.  See below for that patch I have added
which should fix it and also make the code a lot cleaner.


>       imsm: process update for raid level migrations
>       imsm: prepare memory for level migration update
>       imsm: prepare update for level migrations reshape

I don't like having mdadm choose the spares to add.  That should
always be the role of mdmon.
So mdadm should at most tell mdmon that a reshape is happening
and mdmon should determine that new spares are needed.

Possibly mdadm wouldn't need to tell mdmon anything.  Having
determined that the reshape is allowed, mdadm can set up the
parameters for the reshape directly in the kernel.
mdmon could notice and make the required changes to the metadata
with at most a 'ping_monitor'.

Maybe there will be some information that has to be sent to mdmon
over the socket, but it should be absolutely minimal.

Thanks,
NeilBrown




commit b545e14a2142b946446cf80127c7c8801dab55c8
Author: NeilBrown <neilb@suse.de>
Date:   Mon Feb 14 12:17:08 2011 +1100

    analyse_change: fix calculation of after.data_disks and ->delta_disks.
    
    
    When changing level when a new number of raid disks was explicitly
    specified, we much make sure that the change implied by the
    change in level is properly incorporated into the final result.
    
    So explicitly track the change in number of parity disks
    (delta_parity) and use it together with delta_disks to determine
    final data_disks.
    Also set info->delta_disks so other code doesn't need to mirror
    this analysis.
    
    And add some errors in cases where a new number of disks was
    requested but is not currently supported
    
    Reported-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 49831ad..424d489 100644
--- a/Grow.c
+++ b/Grow.c
@@ -893,6 +893,10 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	 * when assembling an array that is undergoing reshape.
 	 */
 	int new_disks;
+	/* delta_parity records change in number of devices
+	 * caused by level change
+	 */
+	int delta_parity = 0;
 
 	/* If a new level not explicitly given, we assume no-change */
 	if (info->new_level == UnSet)
@@ -925,6 +929,10 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		 * raid0 with 1 disk
 		 */
 		if (info->new_level == 0) {
+			if (info->delta_disks != UnSet &&
+			    info->delta_disks != 0)
+				return "Cannot change number of disks "
+					"with RAID1->RAID0 conversion";
 			re->level = 0;
 			re->before.data_disks = 1;
 			re->after.data_disks = 1;
@@ -944,6 +952,10 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		}
 		if (info->array.raid_disks == 2 &&
 		    info->new_level == 5) {
+			if (info->delta_disks != UnSet &&
+			    info->delta_disks != 0)
+				return "Cannot change number of disks "
+					"with RAID1->RAID5 conversion";
 			re->level = 5;
 			re->before.data_disks = 1;
 			re->after.data_disks = 1;
@@ -970,10 +982,10 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			return "RAID10 can only be changed to RAID0";
 		new_disks = (info->array.raid_disks
 			     / (info->array.layout & 0xff));
-		if (info->delta_disks == UnSet) {
+		if (info->delta_disks == UnSet)
 			info->delta_disks = (new_disks
 					     - info->array.raid_disks);
-		}
+
 		if (info->delta_disks != new_disks - info->array.raid_disks)
 			return "New number of raid-devices impossible for RAID10";
 		if (info->new_chunk &&
@@ -1032,16 +1044,19 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		 * a raid4 style layout of the final level.
 		 */
 		switch (info->new_level) {
-		case 0:
 		case 4:
+			delta_parity = 1;
+		case 0:
 			re->level = 4;
 			re->before.layout = 0;
 			break;
 		case 5:
+			delta_parity = 1;
 			re->level = 5;
 			re->before.layout = ALGORITHM_PARITY_N;
 			break;
 		case 6:
+			delta_parity = 2;
 			re->level = 6;
 			re->before.layout = ALGORITHM_PARITY_N;
 			break;
@@ -1057,6 +1072,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	case 5:
 		switch (info->new_level) {
 		case 0:
+			delta_parity = -1;
 		case 4:
 			re->level = info->array.level;
 			re->before.data_disks = info->array.raid_disks - 1;
@@ -1068,6 +1084,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			re->before.layout = info->array.layout;
 			break;
 		case 6:
+			delta_parity = 1;
 			re->level = 6;
 			re->before.data_disks = info->array.raid_disks - 1;
 			switch (info->array.layout) {
@@ -1096,6 +1113,10 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		case 1:
 			if (info->array.raid_disks != 2)
 				return "Can only convert a 2-device array to RAID1";
+			if (info->delta_disks != UnSet &&
+			    info->delta_disks != 0)
+				return "Cannot set raid_disk when "
+					"converting RAID5->RAID1";
 			re->level = 1;
 			break;
 		default:
@@ -1106,6 +1127,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		switch (info->new_level) {
 		case 4:
 		case 5:
+			delta_parity = -1;
 		case 6:
 			re->level = 6;
 			re->before.data_disks = info->array.raid_disks - 2;
@@ -1131,11 +1153,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		 */
 		if (re->level != 4 && re->level != 5)
 			return "Cannot covert to RAID0 from this level";
-		if (info->delta_disks == UnSet)
-			re->after.data_disks = re->before.data_disks;
-		else
-			re->after.data_disks =
-				info->array.raid_disks + info->delta_disks;
+
 		switch (re->level) {
 		case 4:
 			re->after.layout = 0 ; break;
@@ -1148,11 +1166,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		/* We can only get to RAID4 from RAID5 */
 		if (re->level != 4 && re->level != 5)
 			return "Cannot convert to RAID4 from this level";
-		if (info->delta_disks == UnSet)
-			re->after.data_disks = re->before.data_disks;
-		else
-			re->after.data_disks =
-				re->before.data_disks + info->delta_disks;
+
 		switch (re->level) {
 		case 4:
 			re->after.layout = 0 ; break;
@@ -1165,14 +1179,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		/* We get to RAID5 for RAID5 or RAID6 */
 		if (re->level != 5 && re->level != 6)
 			return "Cannot convert to RAID5 from this level";
-		if (info->delta_disks == UnSet)
-			re->after.data_disks = re->before.data_disks;
-		else if (re->level == 5)
-			re->after.data_disks =
-				re->before.data_disks + info->delta_disks;
-		else
-			re->after.data_disks =
-				info->array.raid_disks + info->delta_disks - 1;
+
 		switch (re->level) {
 		case 5:
 			if (info->new_layout == UnSet)
@@ -1205,11 +1212,6 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		/* We must already be at level 6 */
 		if (re->level != 6)
 			return "Impossible level change";
-		if (info->delta_disks == UnSet)
-			re->after.data_disks = re->before.data_disks;
-		else
-			re->after.data_disks = (info->array.raid_disks +
-						info->delta_disks) - 2;
 		if (info->new_layout == UnSet)
 			re->after.layout = info->array.layout;
 		else
@@ -1218,6 +1220,12 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 	default:
 		return "Impossible level change requested";
 	}
+	if (info->delta_disks == UnSet)
+		info->delta_disks = delta_parity;
+
+	re->after.data_disks = (re->before.data_disks
+				+ info->delta_disks
+				- delta_parity);
 	switch (re->level) {
 	case 6: re->parity = 2; break;
 	case 4:
