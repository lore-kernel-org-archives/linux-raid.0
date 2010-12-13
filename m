From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/16] Check-pointing for external metadata
Date: Mon, 13 Dec 2010 15:44:47 +0100
Message-ID: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series should be applied in top of my previous migration patches (devel 3.2).

Patches implements:
1. fixes for OLCE, migration, takeover : patches 0001 to 0006
2. check-pointing implementation: patches from 0007 to 0016

Next steps:
1. replace spares management using functions from auto-rebuild (Krzysztof is almost done)
2. add unit tests for submitted features (UT works for 3.1.4, they need rework for devel 3.2)

For feature description please look comments for particular patches.


---

Adam Kwolek (16):
      Allow for reshape without backup file
      imsm Fix: Core during rebuild on array details read
      mdadm: support grow operation for external meta using checkpointing
      Add mdadm->mdmon sync_max command message
      mdadm: migration restart for external meta
      mdadm: support backup operations for imsm
      mdadm: support restore_stripes() from the given buffer
      mdadm: add backup methods to superswitch
      mdadm: Add IMSM migration record to intel_super
      mdadm: second_map enhancement for imsm_get_map()
      FIX: suspend_hi and lo set to max and then to 0
      FIX: wait_backup() sometimes hangs
      FIX: prepare for new spares management
      FIX: remove unnecessary load_super() call
      WORKAROUND: md reports idle state during reshape start - Remove
      FIX: Add spares to raid0 in mdadm


 Assemble.c    |   10 +
 Detail.c      |    5 
 Grow.c        |  462 ++++++++++++++++++++++++++++++++--
 Manage.c      |    1 
 managemon.c   |   73 +++++
 mdadm.h       |   34 ++-
 mdmon.c       |   12 +
 mdmon.h       |    6 
 monitor.c     |  107 ++++++++
 msg.c         |   33 ++
 msg.h         |    2 
 restripe.c    |   49 ++--
 super-intel.c |  764 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 util.c        |   25 ++
 14 files changed, 1448 insertions(+), 135 deletions(-)

-- 
Adam Kwoleka
