From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/53] External Metadata Reshape
Date: Fri, 26 Nov 2010 09:03:51 +0100
Message-ID: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch series (combines 3 previous series in to one) for mdadm and introduces features:
- Freeze array/container and new reshape vectors: patches 0001 to 0015
  mdadm devel 3.2 contains patches 0001 to 0013 already,  patches 0014 and 0016 fixes 2 problems in this functionality
- Takeover: patches 0016 to 0017
- Online Capacity Expansion (OLCE): patches 0018 to 0036
- Checkpointing: patches 0037 to 0045
-  Migrations: patches 0045 to 0053
    1. raid0 to raid5 : patch 0051
    2. raid5 to raid0 : patch 0052
    3. chunk size migration) : patch 0053

Patches are for mdadm 3.1.4 and Neil's feedback for 6 first OLCE patches is included.
There should be no patch corruption problem now, as it is sent directly from stgit (not outlook).

For checkpointing md patch "md: raid5: update suspend_hi during reshape" is required also (sent before).
New vectors (introduced by Dan Williams) reshape_super() and manage_reshape() are used in whole process.

In the next step, I'll rebase it to mdadm devel 3.2, meanwhile Krzysztof Wojcik will prepare additional fixes for raid10<->raid0 takeover

I think that few patches can be taken in to devel 3.2 at this monent i.e.:
    0014-FIX-Cannot-exit-monitor-after-takeover.patch
    0015-FIX-Unfreeze-not-only-container-for-external-metada.patch
    0016-Add-takeover-support-for-external-meta.patch
    0018-Treat-feature-as-experimental.patch
    0033-Prepare-and-free-fdlist-in-functions.patch
    0034-Compute-backup-blocks-in-function.patch

Online Capacity Expansion for raid0 and raid5 arrays implements the following algorithm for container reshape:
1.      mdadm: Freeze container
2.      mdadm: Perform takeover to raid5 for all raid0 arrays in container (imsm for raid0 <->raid5 takeover requires no metadata updates)
3.      mdadm: set raid_disks sysfs entry for all arrays in container
4.      mdadm: prepares and sends metadata update using reshape_super() vector for first array in container.
5.      mdadm: waits for array idle or reshape state
6.      managemon: prepare_update(): allocates memory for bigger device object
7.      monitor: process_update(): applies update, relinks memory for device objects. Sets reshape_delta_disks variable in active array to requested ne disks
8.      monitor: kicks managemon on reshape_delta_disks  value other than RESHAPE_NOT_ACTIVE and RESHAPE_IN_PROGRESS  value
9.      managemon: adds devices to md (let md set slot number on reshape start)
10.     managemon: sets sync_max to 0
11.     managemon: starts reshape in md
12.     managemon: on success sends slot verification message to monitor to update slots
13.     managemon: on failure sends reshape cancelation message (sets idle state to md)
14.     managemon: sets reshape_delta_disks variable to RESHAPE_IN_PROGRESS value to avoid managemon procedures reentry.
15.     monitor:
           a. for set slot message verifies and corrects (if necessary) slot information in metadata
           b. for cancel message roll backs metadata information, set reshape_delta_disks variable to RESHAPE_NOT_ACTIVE
16.     mdadm:  on idle array state exits and unfreezes array. End
17.     mdadm: on reshape array state continues with reshape (it also sends ping to monitor and mandgemon to be sure that metadata updates hits disks)
18.     mdadm: verifies array state: if slots are set correctly
19.     mdadm: calls child_grow() function
20.     mdadm: waits for reshape finish
21.     monitor: on reshape finish sets reshape_delta_disks variable to RESHAPE_NOT_ACTIVE
22.     mdadm: sets array size according to information in metadata
23.     mdadm: for raid0 array backward takeover to raid0 is executed.
24.     mdadm: check if other array in container requires reshape if, yes starts from #4
25.     mdadm: unfreezes array

Migration feature reuses code flow introduced for OLCE (Online Capacity Expansion) and uses the same grow/reshape flow in mdadm/mdmon.
Migration is executed in the following way:
1. mdadm: reshape_super() prepares metadata update and sends it to mdmon 2. mdadm: waits for reshape array state 3. monitor: receives metadata update and applies it.
4. monitor: metadata update triggers managemon.
5. managemon: updates array (md) configuration and starts reshape 6. mdadm: finds that reshape is started and continues it using check pointing 7. mdadm: reshape is finished
and manage_reshape() finalizes array:
    - Sets array size as is given in metadata
    - Performs takeover to raid0 if necessary

In current patches placement of manage_reshape() function call was changed (patch 0050).
It is moved to end of array processing to use common code form Grow.c for external metadata reshape case (we do not need to duplicate existing code) as it would do the same
things as code for native metadata. New manage_reshape() placement causes a few things to do in current implementation only and simplifees code.

Migrations command line:
1. Execute migration raid0->raid5:
    mdadm  --grow /dev/md/array_name -level 5 -layout=left-asymmetric

    This converts n-disks raid0 array to (n+1)-disks raid5 array.
    Additional disk is user from spares pool for raid5 array.

2. Execute migration raid5->raid0:
    mdadm  - -grow /dev/md/array_name -level 0

    This converts n-disks raid5 array to n-disks raid0 array.

3. Execute chunk size migration
    mdadm  - -grow /dev/md/array_name -chunk N

    where N is ne chunk size value


Online Capacity Expansion command line:
1. Add spares to container i.e. mdadm -add /dev/md/imsm_container_name /dev/sdX
   For Raid0 spares are required also. Patch "[PATCH 16] Add spares to raid0 array using takeover" enables this.
2. Execute reshape i.e. : mdadm -grown /dev/md/imsm_container_name -raid-devices=requested_raid_disks_number
   Grow is executed for all arrays in container that command is executed on.

Feature is treated as experimental due to Windows compatibility during reshape process, code is guarded by MDADM_EXPERIMENTAL environment variable.


---

Adam Kwolek (45):
      Migration: Chunk size migration
      Migration raid0->raid5
      Migration: raid5->raid0
      Change manage_reshape() placement
      imsm Fix: Core during rebuild on array details read
      WORKAROUND: md reports idle state during reshape start
      FIX: Honor !reshape state on wait_reshape() entry
      FIX: Allow for reshape without backup file
      mdadm: support grow operation for external meta
      Add mdadm->mdmon sync_max command message
      mdadm: migration restart for external meta
      mdadm: support backup operations for imsm
      mdadm: support restore_stripes() from the given buffer
      mdadm: add backup methods to superswitch
      mdadm: Add IMSM migration record to intel_super
      mdadm: read chunksize and layout from mdstat
      mdadm: second_map enhancement for imsm_get_map()
      Finalize reshape after adding disks to array
      Control reshape in mdadm
      Compute backup blocks in function.
      Prepare and free fdlist in functions
      imsm: FIX: spare list contains one device several times
      imsm: FIX: Fill delta_disks field in getinfo_super()
      imsm: FIX: Fill sys_name field in getinfo_super()
      Add spares to raid0 array using takeover
      imsm: Do not indicate resync during reshape
      imsm: Do not accept messages sent by mdadm
      imsm: Cancel metadata changes on reshape start failure
      imsm: Verify slots in meta against slot numbers set by md
      Add support to skip slot configuration
      Process reshape initialization by managemon
      Send information to managemon about reshape request
      imsm: FIX: core dump during imsm metadata writing
      imsm: Add reshape_update for grow array case
      imsm: Add support for general migration
      Treat feature as experimental
      Disk removal support for Raid10->Raid0 takeover
      Add takeover support for external meta
      FIX: Unfreeze not only container for external metadata
      FIX: Cannot exit monitor after takeover
      External reshape (step 2): Freeze container
      External reshape (step 1): container reshape and ->reshape_super()
      Document the external reshape implementation
      Initialize st->devnum and st->container_dev in super_by_fd
      block monitor: freeze spare assignment for external arrays

Dan Williams (8):
      Create: cleanup/unify default geometry handling
      fix a get_linux_version() comparison typo
      Grow: add missing raid4 geometries to geo_map()
      Grow: fix check for raid6 layout normalization
      Assemble: fix assembly in the delta_disks > max_degraded case
      Grow: mark some functions static
      Manage: allow manual control of external raid0 readonly flag
      Provide a mdstat_ent to subarray helper


 Assemble.c                  |   12 
 Create.c                    |   21 
 Detail.c                    |   22 
 Grow.c                      | 1285 ++++++++++++++++--
 Makefile                    |    6 
 Manage.c                    |  155 ++
 external-reshape-design.txt |  168 ++
 managemon.c                 |  266 ++++
 mdadm.c                     |    2 
 mdadm.h                     |  113 +-
 mdmon.h                     |   16 
 mdstat.c                    |   11 
 monitor.c                   |  112 ++
 msg.c                       |  229 +++
 msg.h                       |    4 
 restripe.c                  |   47 -
 super-ddf.c                 |   11 
 super-intel.c               | 3125 ++++++++++++++++++++++++++++++++++++++++++-
 sysfs.c                     |  180 ++
 util.c                      |  241 +++
 20 files changed, 5722 insertions(+), 304 deletions(-)
 create mode 100644 external-reshape-design.txt

-- 
Signature
