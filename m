From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/12] Problems during restart container reshape
Date: Tue, 07 Feb 2012 15:02:55 +0100
Message-ID: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

This series corrects problems occurred during restart multi arrays reshape:
 1. Assembled incrementally array during reshape is assembled degraded
 2. Reshape cannot be continued after reboot. '--continue' gives  an error
 3. When raid0 arrays are reshaped, first array is reshaped only
 4. Size doesn't change on second raid0 array
Please note that patch 'imsm: FIX: No new missing disks are allowed during general migration' can be easily extended by:
 - Narrow it to incremental assembly only
 - Array can be pushed to be assembled by using e.g. 'force' option during incremental assembly.

Other issue addressed in this series is chunk size change from 128k to 4k problem.

BR
Adam

---

Adam Kwolek (12):
      FIX: Do not try to (continue) reshape using inactive array
      FIX: restart reshape when reshape process is stopped just between 2 reshapes
      imsm: FIX: Clear migration record when migration switches to next volume.
      imsm: FIX: use md position to reshape restart
      FIX: use md position to reshape restart
      imsm: FIX: Chunk size migration problem
      Flush mdmon before next reshape step during container operation
      Fix: Sometimes mdmon throws core dump during reshape
      imsm: FIX: imsm_get_allowed_degradation() doesn't count degradation for raid1
      FIX: Array is not run when expansion disks are added
      imsm: FIX: No new missing disks are allowed during general migration
      FIX: NULL pointer to strdup() can be passed


 Assemble.c    |    2 -
 Grow.c        |  124 ++++++++++++++++++++++++++++++++++++++++++++-------------
 managemon.c   |    6 +++
 msg.c         |   10 +++++
 msg.h         |    1 
 super-intel.c |   47 +++++++++++++++++++---
 util.c        |    5 +-
 7 files changed, 159 insertions(+), 36 deletions(-)

-- 
Signature
