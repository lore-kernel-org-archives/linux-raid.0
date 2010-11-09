From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 00/31] Add Online Capacity Expansion with checkpointing to
 mdadm for external metadata
Date: Tue, 9 Nov 2010 17:00:38 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA8E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This patch series introduces 3 new features in to mdadm:
-	Takeover: patches 0001 and 0002
-	Online Capacity Expansion: patches 0003-0022
-	Checkpointing: patches 0023-0031
	For checkpointing md patch "md: raid5: update suspend_hi during reshape" is required also.
New vectors (introduced by Dan Williams) reshape_super() and manage_reshape() are used in whole process.

Online Capacity Expansion for raid0 and raid5 arrays implements the following algorithm for container reshape:
1.	mdadm: Freeze container
2.	mdadm: Perform takeover to raid5 for all raid0 arrays in container (imsm for raid0 <->raid5 takeover requires no metadata updates)
3.	mdadm: set raid_disks sysfs entry for all arrays in container
4.	Mdadm: prepares and sends metadata update using reshape_super() vector for first array in container.
5.	Mdadm: waits for array idle or reshape state
6.	Managemon: prepare_update(): allocates memory for bigger device object
7.	Monitor: process_update(): applies update, relinks memory for device objects.
		Sets reshape_delta_disks variable in active array to requested ne disks
8.	Monitor: kicks managemon on reshape_delta_disks  value other than RESHAPE_NOT_ACTIVE and RESHAPE_IN_PROGRESS  value
9.	Managemon: adds devices to md (let md set slot number on reshape start)
10.	Managemon: sets sync_max to 0
11.	Managemon: starts reshape in md
12.	Managemon: on success sends slot verification message to monitor to update slots
13.	Managemon: on failure sends reshape cancelation message (sets idle state to md)
14.	Managemon: sets reshape_delta_disks variable to RESHAPE_IN_PROGRESS value to avoid managemon procedures reentry.
15.	Monitor:
	a. for set slot message verifies and corrects (if necessary) slot information in metadata
	b. for cancel message roll backs metadata information, set reshape_delta_disks variable to RESHAPE_NOT_ACTIVE
16.	mdadm:  on idle array state exits and unfreezes array. End
17.	mdadm : on reshape array state continues with reshape (it also sends ping to monitor and mandgemon to be sure that metadata updates hits disks)
18.	mdadm: verifies array state: if slots are set correctly
19.	mdadm: calls child_grow() function
20.	mdadm: waits for reshape finish
21.	monitor: on reshape finish sets reshape_delta_disks variable to RESHAPE_NOT_ACTIVE
22.	mdadm: sets array size according to information in metadata
23.	mdadm: for raid0 array backward takeover to raid0 is executed.
24.	mdadm: check if other array in container requires reshape if, yes starts from #4
25.	mdadm: unfreezes array

To use this feature 2 steps are required:
1. Add spares to container i.e. mdadm -add /dev/md/imsm_container_name /dev/sdX
   For Raid0 spares are required also. Patch "[PATCH 17/23] Add spares to raid0 array using takeover" enables this.
2. Execute reshape i.e. : mdadm -grown /dev/md/imsm_container_name -raid-devices=requested_raid_disks_number -backup-file=patch_to_backup_file
   Grow is executed for all arrays in container that command is executed on.

Feature is treated as experimental due to Windows compatibility during reshape process, code is guarded by EXPERIMENTAL compilation flag.

Checkpointing algorithm is implemented Grow.c ,as common code and for details look patches  0023-0031. It is used in #19 in above description.

---

Adam Kwolek (31):
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
      Prepare and free fdlist in function
      imsm: FIX: spare list contains one device put there several times
      imsm: FIX: Fill delta_disks field in getinfo_super()
      imsm: FIX: Fill sys_name field in getinfo_super()
      Add spares to raid0 array using takeover
      imsm: Do not indicate resync during reshape
      imsm: Do not accept messages sent by mdadm
      imsm: Cancel metadata changes on reshape start failure
      imsm: Verify  slots in meta against slot numbers set by md
      Add support to skip slot configuration
      Process reshape initialization by managemon
      Send information to managemon about ne reshape request
      imsm: FIX: core dump during imsm metadata writing
      imsm: Add reshape_update for grow array case
      imsm: Add support for general migration
      Treat feature as experimental
      FIX: allow for execution for new size set to 0
      Disk removal support for Raid10->Raid0 takeover
      Add takeover support for external meta


 mdadm/mdadm/Assemble.c    |    8 
 mdadm/mdadm/Grow.c        |  593 ++++++++--
 mdadm/mdadm/Makefile      |    4 
 mdadm/mdadm/Manage.c      |  157 ++-
 mdadm/mdadm/managemon.c   |  161 +++
 mdadm/mdadm/mdadm.h       |   87 +
 mdadm/mdadm/mdmon.h       |   19 
 mdadm/mdadm/mdstat.c      |   35 +
 mdadm/mdadm/monitor.c     |  156 ++-
 mdadm/mdadm/msg.c         |   33 +
 mdadm/mdadm/msg.h         |    2 
 mdadm/mdadm/restripe.c    |   44 -
 mdadm/mdadm/super-intel.c | 2782 ++++++++++++++++++++++++++++++++++++++++++++-
 mdadm/mdadm/sysfs.c       |  148 ++
 mdadm/mdadm/util.c        |  167 +++
 15 files changed, 4168 insertions(+), 228 deletions(-)

-- 
Signature
