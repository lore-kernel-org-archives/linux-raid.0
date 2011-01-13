From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/6] OLCE raid5/0 (all arrays in container)
Date: Thu, 13 Jan 2011 15:50:02 +0100
Message-ID: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series adds possibility to reshape all (raid0/5) arrays in container for expansion feature.
The main problem resolved in this series is how initialize second (and next) raid0 reshapes for container reshape
executed as set of array reshapes.

For i.e. second raid0 array mdmon should initialize metadata to let know to mdadm that there is something more to reshape.
But problem is what to do when mdmon is not loaded? (for first raid0 array this is not a problem, reshape_super() in mdadm updates metadata).

this is resolved by allowing mdadm to know what was reshaped so far. This allows to reshape arrays that are not reshaped yet,
without update from mdmon.

BR
Adam 

---

Adam Kwolek (6):
      FIX: sync_completed == 0 causes reshape cancellation in metadata
      FIX: mdadm hangs during reshape
      FIX: mdadm throws coredump on exit in error case
      FIX: reshape raid0 on second array
      FIX: continue raid0 reshape
      imsm: Update metadata for second array


 Grow.c        |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 monitor.c     |    4 ++
 super-intel.c |   35 +++++++++++++++++++--
 3 files changed, 120 insertions(+), 14 deletions(-)

-- 
Signature
