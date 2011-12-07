From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/9] Array degradation during reshape and rebuild (cont.)
Date: Wed, 07 Dec 2011 13:57:35 +0100
Message-ID: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

The following series adds implementation details for array
degradation during reshape and rebuild/initialization.

Series fixes problems in handling degradation during rebuild
in imsm metadata and fixes problems noticed in applied changes..

Failing disks using sysfs (echo 1 > /sys/block/sdX/device/delete)
mdadm does his job correctly.
The problem is when disks are pulled physically from system.
As workaround BBM disabling can be used /sent previously/.


BR
Adam
  

---

Adam Kwolek (9):
      imsm: FIX: Use defines for device map access
      imsm: FIX: Check correct slots on disk failure
      imsm: FIX: Finish rebuild and initialization when missing drive is handled
      imsm: FIX: Mark failure for rebuild
      imsm: FIX: Add array map state transition for failures during initialization
      imsm: FIX: Do not allow spare activation during rebuild
      imsm: Function imsm_set_disk() rework
      imsm: FIX: Correct ords merging in end_migration()
      imsm: FIX: Remove longer map request


 super-intel.c |  475 ++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 285 insertions(+), 190 deletions(-)

-- 
Signature
