From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/9] OLCE for external meta (cont.)
Date: Tue, 11 Jan 2011 15:03:47 +0100
Message-ID: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series continues OLCE implementation for external metadata.

Main changes:
- Raid0 OLCE is possible
- OLCE for container with 2 arrays works (imsm) 
- Spares can be added to raid5 container (roll back of some changes)
- some bugs fixed

Problems:
- checkpointing sometimes hangs 
  reshape in md is finished, but mdadm stops responding before size set is executed,
  somewhere in child_monitor()
- when second array in container is raid0, it is not reshaped during OLCE 
  for imsm no one at this moment can update metadata:
     - mdadm is decided not to do this
     - mdmon is not running for this array yet (array_set_state() cannot be called for metadata update)
     - mdmon can be run later in reshape_array(), but we need meta update earlier to get reshape_active variable updated

BR
Adam



     

---

Adam Kwolek (9):
      imsm: Proceed with second array reshape only for frozen container
      FIX: container has to be frozen during reshape
      imsm: FIX: monitor should initialize 2nd reshape only
      imsm: FIX: container content gathering is not needed for size set
      imsm: Update metadata for second array
      imsm: FIX: only one spare is passed in update
      imsm:FIX: one spare can be added to raid0 only
      FIX: Cannot add spare to monitored container
      imsm: FIX: set correct slot information in metadata (raid0)


 Grow.c        |   62 ++++++++++++++----------------
 Manage.c      |    8 ++--
 super-intel.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 149 insertions(+), 40 deletions(-)

-- 
Signature
