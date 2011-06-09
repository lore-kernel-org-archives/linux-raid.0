From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] IMSM Checkpointing Bug Fix Series (2)
Date: Thu, 09 Jun 2011 18:29:01 +0200
Message-ID: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series contains 2 fixes for IMSM Checkpointing:
        1. imsm: FIX: Disable automatic metadata rollback for broken reshape
        2. imsm: FIX: Use function to obtain array layout

It enables IMSM array creation:
        1. FIX: Cannot create volume
        2. imsm: FIX: Cannot create volume
This fix contains 2 patches but any single patch of those 2 help.
I think both should be placed in mdadm.

Checkpointing status:
	- Raid0: OK
	- Raid5: Data corruption problem when stripes are restored from backup (work in progress)


BR
Adam

---

Adam Kwolek (4):
      imsm: FIX: Disable automatic metadata rollback for broken reshape
      imsm: FIX: Use function to obtain array layout
      FIX: Cannot create volume
      imsm: FIX: Cannot create volume


 Create.c      |    4 ++--
 super-intel.c |   24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 9 deletions(-)

-- 
Signature
