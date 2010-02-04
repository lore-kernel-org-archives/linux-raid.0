From: Neil Brown <neilb@suse.de>
Subject: Re: 2 drives failed, one "active", one with wrong event count
Date: Thu, 4 Feb 2010 12:03:12 +1100
Message-ID: <20100204120312.57e40158@notabene.brown>
References: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001290502140.15329@uplift.swm.pp.se>
	<20100129211719.04595761@notabene>
	<alpine.DEB.1.10.1001291306170.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001291326430.15329@uplift.swm.pp.se>
	<alpine.DEB.1.10.1001301546400.15329@uplift.swm.pp.se>
	<20100201093713.7ee33041@notabene.brown>
	<alpine.DEB.1.10.1002010810440.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002010810440.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 1 Feb 2010 08:13:24 +0100 (CET)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Mon, 1 Feb 2010, Neil Brown wrote:
> 
> > You might know that nothing has been written to the array since the 
> > device with the lower event count was removed, but md doesn't know that. 
> > Any device with an old event count could have old and so cannot be 
> > trusted (unless you assemble with --force meaning that you are taking 
> > responsibility).
> 
> I did use --force, but it seems in the state "one drive with lower event 
> count and another one with 0x2", the event count on the drive isn't 
> forcably updated and since there is a 0x2 drive, the array isn't started.
> 
> I had the same situation again this morning (changing controller next), 
> but this time I had bitmaps enabled so recovery of the array with 
> --assemble --force took just a few seconds. Really nice.
> 

Right... I understand now.

Fixed with the following patch which will be in 3.1.2.

Thanks,
NeilBrown

commit 921d9e164fd3f6203d1b0cf2424b793043afd001
Author: NeilBrown <neilb@suse.de>
Date:   Thu Feb 4 12:02:09 2010 +1100

    Assemble: fix --force assembly of v1.x arrays which are recovering.
    
    1.x metadata allows a device to be a member of the array while it
    is still recoverying.  So it is a working member, but is not
    completely in-sync.
    
    mdadm/assemble does not understand this distinction and assumes that a
    work member is fully in-sync for the purpose of determining if there
    are enough in-sync devices for the array to be functional.
    
    So collect the 'recovery_start' value from the metadata and use it in
    assemble when determining how useful a given device is.
    
    Reported-by: Mikael Abrahamsson <swmike@swm.pp.se>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Assemble.c b/Assemble.c
index 7f90048..e4d6181 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -800,7 +800,8 @@ int Assemble(struct supertype *st, char *mddev,
 		if (devices[j].i.events+event_margin >=
 		    devices[most_recent].i.events) {
 			devices[j].uptodate = 1;
-			if (i < content->array.raid_disks) {
+			if (i < content->array.raid_disks &&
+			    devices[j].i.recovery_start == MaxSector) {
 				okcnt++;
 				avail[i]=1;
 			} else
@@ -822,6 +823,7 @@ int Assemble(struct supertype *st, char *mddev,
 			int j = best[i];
 			if (j>=0 &&
 			    !devices[j].uptodate &&
+			    devices[j].i.recovery_start == MaxSector &&
 			    (chosen_drive < 0 ||
 			     devices[j].i.events
 			     > devices[chosen_drive].i.events))
diff --git a/super-ddf.c b/super-ddf.c
index 3e30229..870efd8 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1369,6 +1369,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info)
 	info->disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
 
 
+	info->recovery_start = MaxSector;
 	info->reshape_active = 0;
 	info->name[0] = 0;
 
@@ -1427,6 +1428,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info)
 
 	info->container_member = ddf->currentconf->vcnum;
 
+	info->recovery_start = MaxSector;
 	info->resync_start = 0;
 	if (!(ddf->virt->entries[info->container_member].state
 	      & DDF_state_inconsistent)  &&
diff --git a/super-intel.c b/super-intel.c
index 91479a2..bbdcb51 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1452,6 +1452,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	info->data_offset	  = __le32_to_cpu(map->pba_of_lba0);
 	info->component_size	  = __le32_to_cpu(map->blocks_per_member);
 	memset(info->uuid, 0, sizeof(info->uuid));
+	info->recovery_start = MaxSector;
 
 	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty) {
 		info->resync_start = 0;
@@ -1559,6 +1560,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	info->disk.number = -1;
 	info->disk.state = 0;
 	info->name[0] = 0;
+	info->recovery_start = MaxSector;
 
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
diff --git a/super0.c b/super0.c
index 0485a3a..5c6b7d7 100644
--- a/super0.c
+++ b/super0.c
@@ -372,6 +372,7 @@ static void getinfo_super0(struct supertype *st, struct mdinfo *info)
 
 	uuid_from_super0(st, info->uuid);
 
+	info->recovery_start = MaxSector;
 	if (sb->minor_version > 90 && (sb->reshape_position+1) != 0) {
 		info->reshape_active = 1;
 		info->reshape_progress = sb->reshape_position;
diff --git a/super1.c b/super1.c
index 85bb598..40fbb81 100644
--- a/super1.c
+++ b/super1.c
@@ -612,6 +612,11 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info)
 	strncpy(info->name, sb->set_name, 32);
 	info->name[32] = 0;
 
+	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_RECOVERY_OFFSET))
+		info->recovery_start = __le32_to_cpu(sb->recovery_offset);
+	else
+		info->recovery_start = MaxSector;
+
 	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_RESHAPE_ACTIVE)) {
 		info->reshape_active = 1;
 		info->reshape_progress = __le64_to_cpu(sb->reshape_position);
