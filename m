From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/4] Prepare assembled array for reshape (expansion)
Date: Wed, 23 Feb 2011 14:51:31 +0100
Message-ID: <20110223133557.17074.9671.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When array with expansion in progress is being assembled, assembled array state is inactive.
If array state would be read-only, 2 things happens:
1. md starts reshape automatically (for externally controlled metadata)
2. mdmon sets array state to active.

This is not correct.

Array should meet the following criteria after assembly to be ready for reshape:

1. array should be in read-only state. Array is assembled with fewer devices 
   than stripes on array 'begin' requires. To avoid data corruption read-only state
   is required until md will be informed about reshape (reshape configuration occures also).

2. mdmon cannot push array in to active state. 
   For this reason mdmon should be temporary blocked from monitoring this array (freeze).

3. md cannot automatically start reshape when it founds reshape position different to MAX_SECTORS.
   For this reason reshape position has to be configured later (reshape_active flag is temporary cleared).

Above points are addressed by patches:
	FIX: Block monitor when starting array with reshape in progress
	FIX: Prevent reshape auto start during assembly for external metadata
	FIX: disks added beyond array should be counted during reshape

The last patch:
	TBD: continue reshape after assembling array
shows development direction.

I'm interested in your opinion about it.
In current code Grow_restart() is never called for imsm/external case.
Do you think that putting additional array configuration and Grow_restart() at pointed place is ok?


BR
Adam

---

Adam Kwolek (4):
      TBD: continue reshape after assembling array
      FIX: Block monitor when starting array with reshape in progress
      FIX: Prevent reshape auto start during assembly for external metadata
      FIX: disks added beyond array should be counted during reshape


 Assemble.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

-- 
Signature
