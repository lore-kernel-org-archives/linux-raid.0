From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/21] IMSM Checkpointing Bug Fix Series
Date: Wed, 08 Jun 2011 18:09:33 +0200
Message-ID: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series fixes problems found in IMSM's checkpointing.
It contains rework based on Neil's comments to previous/initial checkpointing
series and tt should be applied on neil_master branch (on the top 
of previous checkpointing patches).

BR
Adam


---

Adam Kwolek (21):
      MAN: Man update for check-pointing
      imsm: Optimize expansion speed when no backup is required
      imsm: FIX: Remove timeout from wait_for_reshape_imsm()
      imsm: FIX: wait_for_reshape_imsm() cleanup
      imsm: FIX: Do not continue reshape when backup exists
      FIX: Move buffer to next location
      imsm: FIX: Remove unused variables and code
      imsm: FIX: Move reshape_progress forward
      imsm: FIX: Detect failed devices during recover_backup_imsm()
      imsm: FIX: Use metadata information for restore_stripes() and save_stripes()
      imsm: FIX: Remove unused parameter from save_backup_imsm() interface
      imsm: FIX: Do not use pba_of_lba0 for copy position calculation
      imsm: FIX: Do not verify unused parameters
      imsm: FIX: Calculate backup location based on metadata information
      imsm: FIX: Use macros to data access
      imsm: FIX: Check layout for level migration
      imsm: FIX: Max position could not be rounded to MB
      imsm: FIX: Detect migration end during migration record saving
      imsm: FIX: Verify if migration record is loaded correctly
      imsm: FIX: Opened handle is not closed
      imsm: FIX: Cannot create volume


 mdadm.8.in    |    9 ++
 restripe.c    |    6 +
 super-intel.c |  237 ++++++++++++++++++++++++++++++++++-----------------------
 3 files changed, 153 insertions(+), 99 deletions(-)

-- 
Signature
