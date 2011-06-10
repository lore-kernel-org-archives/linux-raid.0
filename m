From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/2] IMSM Checkpointing Bug Fix Series (3)
Date: Fri, 10 Jun 2011 17:56:21 +0200
Message-ID: <20110610154856.24539.28960.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements fixes for potential problems found
using Klocwork.

For complete solution all sent patches (7) needs to be applied:
  1. imsm: FIX: Cannot create volume
  2. FIX: Cannot create volume
  3. imsm: FIX: Use function to obtain array layout
  4. imsm: FIX: Disable automatic metadata rollback for broken reshape
  5. imsm: FIX: Raid5 data corruption data recovering from backup
  6. imsm: Fix: klocwork: targets variable can be used uninitialized
  7. imsm: FIX: klocwork: passed dev pointer to is_gen_migration() can be NULL

IMSM Checkpointing Status: All unit tests passed

BR
Adam


---

Adam Kwolek (2):
      imsm: FIX: klocwork: passed dev pointer to is_gen_migration() can be NULL
      imsm: Fix: klocwork: targets variable can be used uninitialized


 super-intel.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

-- 
Signature
