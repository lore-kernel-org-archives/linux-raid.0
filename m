From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/34] OLCE for external metadata (devel3.2)
Date: Tue, 04 Jan 2011 15:34:38 +0100
Message-ID: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This patch series implements Online Capacity Expansion (OLCE) feature in mdadm devel3.2. for Raid5 and Raid0.
This is implemented as reshape of whole container (all arrays that belongs to container are reshaped).
Raid0 reshape is implemented using takeover to raid4 transition.

---

Adam Kwolek (31):
      Raid0: detect reshape on array start
      Raid0: Reload disk list on 'next' raid0 array
      Raid0: Run 'next' reshapes without meta update
      imsm: FIX: do not repair raid4 arrays
      Raid0: execute backward takeover
      Detect level change
      Take in mind takeover during disk add
      imsm: Update raid0 metadata for reshape
      imsm: Move reshape update processing to function
      Add spares to raid0 in mdadm
      imsm: Update metadata for second array
      Set array size after adding new disks
      imsm: update array size information in metadata
      FIX: Initialize subarray variable in reshape_array
      imsm: FIX: Division by 0
      imsm: Finalize reshape in metadata
      Finalize reshape after adding disks to array
      imsm: FIX: Fill sys_name in container_content()
      FIX: Use sysfs to change array parameters
      FIX: added disks are not used by reshape process /md/
      FIX: change adding disks criteria
      FIX: Get array information in reshape_array()
      imsm: FIX: support general migration by getinfo_super_imsm_volume
      FIX: Arrays cannot be opened exclusively
      imsm: FIX: update first array in container only
      FIX: get updated information from metadata
      imsm: FIX: Do not update anchor directly
      imsm: FIX: Perform first metadata update for container operation
      imsm: FIX: display error message
      imsm: FIX: display correct information for '-E' option
      mdadm: second_map enhancement for imsm_get_map()

Krzysztof Wojcik (3):
      FIX: Position calculation in mdstat_by_subdev
      FIX: Change size condition in imsm_reshape_is_allowed_on_container
      Manage reshape process in manage_reshape vector.


 Grow.c        |  174 ++++++++++++------
 Manage.c      |   13 -
 managemon.c   |   12 +
 mdstat.c      |    4 
 monitor.c     |   20 ++
 super-intel.c |  561 ++++++++++++++++++++++++++++++++++++++++++---------------
 6 files changed, 576 insertions(+), 208 deletions(-)

-- 
Signature
