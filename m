From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Thu, 09 Dec 2010 16:18:38 +0100
Message-ID: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This series for mdadm and introduces features (after some rework):
- Online Capacity Expansion (OLCE): patches 0001 to 0015
- Migrations: patches 0016 to 0023
- Takeover: patches 0024 to 0028
- Add spare to raid0: patch 0029

Changes made since last post:
1. rebased to latest devel 3.2
2. functions for finding array minor rewriten/colapsed in to one function (util.c)
3. used open_dev instead of open
4. Almost all added code fits in 80 collums


!!! Please note that searching spares has to be merged with auto-rebuild feature.  
    Krzysztof works this and he will post fix very soon.
    
Next steps:
- fix for spares managment
- add checkpointing (working without md fix for moving suspend_hi)


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
Migration works in the following way:
1. mdadm: reshape_super() prepares metadata update and sends it to mdmon 2. mdadm: waits for reshape array state 3. monitor: receives metadata update and applies it.
4. monitor: metadata update triggers managemon.
5. managemon: updates array (md) configuration and starts reshape 6. mdadm: finds that reshape is started and continues it using check pointing 7. mdadm: reshape is finished
and manage_reshape() finalizes array:
    - Sets array size as is given in metadata
    - Performs takeover to raid0 if necessary

In current patches placement of manage_reshape() function call was changed (patch 0019).
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

Adam Kwolek (29):
      Add spares to raid0 in mdadm
      IMSM compatibility for raid0 -> raid10 takeover
      FIX: Problem with removing array after takeover
      Takeover raid0 -> raid10 for external metadata
      Takeover raid10 -> raid0 for external metadata
      Add takeover support for external meta
      Migration: Chunk size migration
      FIX: mdstat doesn't read chunk size correctly
      Read chunk size and layout from mdstat
      Migration raid0->raid5
      Detect level change
      Migration: raid5->raid0
      Change manage_reshape() placement
      Enable reshape for subarrays
      FIX: core during getting map
      WORKAROUND: md reports idle state during reshape start
      Add reshape progress updating
      Finalize reshape after adding disks to array
      Control reshape in mdadm
      imsm: Fill delta_disks field in getinfo_super()
      imsm: Do not indicate resync during reshape
      imsm: Do not accept messages sent by mdadm
      imsm: Cancel metadata changes on reshape start failure
      imsm: Verify slots in meta against slot numbers set by md
      Process reshape initialization by managemon
      imsm: Block array state change during reshape
      imsm: Process reshape_update in mdmon
      imsm: Prepare reshape_update in mdadm
      Add state_of_reshape for external metadata


 Grow.c        |  201 +++-
 Manage.c      |   14 
 managemon.c   |  220 +++++
 mdadm.h       |   39 +
 mdmon.c       |   57 +
 mdmon.h       |   10 
 mdstat.c      |   14 
 monitor.c     |   38 +
 super-intel.c | 2668 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 sysfs.c       |  174 ++++
 util.c        |   34 +
 11 files changed, 3389 insertions(+), 80 deletions(-)

-- 
Adam
