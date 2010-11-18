From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 00/13] Series short description
Date: Thu, 18 Nov 2010 10:21:20 +0100
Message-ID: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following series of patches are based on mdadm version 3.1.4.

This series is the first of three parts of reshape/takeover implementation for external metadata.
Next parts are:
- OnlineCapacityExpansion/Checkpointing (already sent)
- Takeover/Migrations (will be send)

The external-reshape-design.txt file
(provided by 0011-Document-the-external-reshape-implementation.patch patch)
contains detailed description of the reshape/takeover design.

---

Dan Williams (13):
      Provide a mdstat_ent to subarray helper
      block monitor: freeze spare assignment for external arrays
      Manage: allow manual control of external raid0 readonly flag
      Grow: mark some functions static
      Assemble: fix assembly in the delta_disks > max_degraded case
      Grow: fix check for raid6 layout normalization
      Grow: add missing raid4 geometries to geo_map()
      fix a get_linux_version() comparison typo
      Create: cleanup/unify default geometry handling
      Initialize st->devnum and st->container_dev in super_by_fd
      Document the external reshape implementation
      External reshape (step 1): container reshape and ->reshape_super()
      External reshape (step 2): Freeze container


 Assemble.c                  |    4 
 Create.c                    |   21 +-
 Detail.c                    |   11 -
 Grow.c                      |  493 ++++++++++++++++++++++++++++++++++++++++---
 Manage.c                    |    1 
 external-reshape-design.txt |  168 +++++++++++++++
 managemon.c                 |   21 ++
 mdadm.c                     |    2 
 mdadm.h                     |   26 ++
 msg.c                       |  195 +++++++++++++++++
 msg.h                       |    2 
 restripe.c                  |    2 
 super-ddf.c                 |   11 +
 super-intel.c               |   15 +
 sysfs.c                     |   33 +++
 util.c                      |   48 +++-
 16 files changed, 965 insertions(+), 88 deletions(-)
 create mode 100644 external-reshape-design.txt

-- 
Krzysztof Wojcik
