From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/7] Online Capacity Expansion (raid5/0,
	all arrays in container, rebased)
Date: Wed, 26 Jan 2011 16:03:09 +0100
Message-ID: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This patch series implements raid5 and raid0 Online Capacity Expansion
for all arrays in container using imsm metadata.
Series was re-based to new mdadm version (2011.01.26). 

It replaces previously sent series for OLCE continuation on container.

Comparing to previously sent series there are the following changes:
1. imsm: Update metadata for second array
   Patch is changed. There is no interface changes
   in imsm_progress_container_reshape() as Neil suggested.
   This patch implements next arrays reshape in container
   for imsm metadata.
   There is no more reshape limitation for 2 arrays in container only
   (as previously exist),
   If imsm will support more than 2 arrays in container reshape code is ready.
2. FIX: monitor doesn't handshake with md
   Patch is changed. ping_monitor() is sent for external metadata only.
3. Added bug fixes:
        - imsm: FIX: do not allow for container operation for the same disks number
                (OLCE for no change in raid disks was accepted)
        - FIX: Array after takeover has to be frozen
                (for single disk raid0, OLCE fails due to recovery process
                started by md, during reshape configuration)
        - FIX: Container can be left frozen
                (when reshape_container() fails, container was left frozen)
        - FIX: start_reshape status should be checked
                (if md fails to start reshape, mdadm didn't have such information
                 and goes processed with check-pointing)
4. Patch:
        imsm: FIX: spare cannot be added
   remains in series as issue is still observed

BR
Adam

---

Adam Kwolek (7):
      FIX: start_reshape status should be checked
      FIX: Container can be left frozen
      imsm: FIX: spare cannot be added
      FIX: Array after takeover has to be frozen
      imsm: FIX: do not allow for container operation for the same disks number
      FIX: monitor doesn't handshake with md
      imsm: Update metadata for second array


 Grow.c        |   14 ++++++++++---
 super-intel.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 5 deletions(-)

-- 
Signature
