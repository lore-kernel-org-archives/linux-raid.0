From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/9] Reshape restart from checkpoint
Date: Wed, 09 Mar 2011 14:45:29 +0100
Message-ID: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This series contains fixes for reshape restart (external metadata)
and makes process workable.

In general your idea of reusing reshape_container() works. The main
problem I've found is opening read only array for writing.
Fortunately during reshape restart we do not need any array writes, 
so read only access is enough.

In patch 'FIX: Unfreeze array on success only during reshape continuation'
I've blocked unfreezing array after reshape restart in case of error.
This causes mdmon to not touch such array and user can take some actions.

I've fixed problem dirty array assembly also. Fix is almost as you proposed.

Known issues:
1. Container reshape half way (corner case)
  When 2 arrays are in container and first is under near finished reshape (during restart), 
  it can occur that reshape_container() could want to reshape second array before it is assembled
  Probably for container reshape continuation we should wait
  (after fork() in reshape_container()) for assembly finish.
2. when first array in container reshape is restarted, second array is not frozen

BR
Adam


---

Adam Kwolek (9):
      imsm : FIX: Assemble dirty array when reshape is in progress
      FIX: Set 'active' array state before array configuration
      FIX: Array cannot be opened for writing on restart
      FIX: Cannot continue reshape if mdmon is not run
      FIX: Unfreeze array on success only during reshape continuation
      imsm: FIX: Do not clean checkpoint for active reshape
      FIX: Make expansion counter usable
      FIX: Block reshaped array monitoring
      FIX: Load container content for container reshape continuation


 Assemble.c    |   39 ++++++++++++++++++++++++---------------
 Grow.c        |   38 +++++++++++++++++++++++++++++++++-----
 super-intel.c |   19 +++++++++++++------
 3 files changed, 70 insertions(+), 26 deletions(-)

-- 
Signature
