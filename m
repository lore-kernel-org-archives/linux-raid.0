From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/5] Make OLCE workeable
Date: Tue, 08 Mar 2011 14:24:29 +0100
Message-ID: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

This is first part of my comments for your latest changes on devel3-2 regarding reshape and reshape restart.
Unfortunately those changes breaks OLCE functionality. This patch series makes OLCE workable (mdadm UT suits 12 and 13 succeed).

Problems:
1. In passing in mdinfo (array.level) raid4 for transition raid0->raid0.
   This causes problems in takeover
   a.Raid0 takeover doesn't occur. array.level == reshape.level == 4
     Resolution: Decision about takeover has to be made based on real md level not info->array.level
   b.Decision about backward takeover cannot be always taken by mdadm. mdadm can think that original level is raid4
     Resolution: use level read from md as orig_level (not from metadata)

2.On the begin of reshape_array() array structure is read from md (via ioctrl). Md knows nothing about raid4 working level, so spares_needed is wrongly computed
  Resolution: use info->array.raid_disks instead array.raid_disks to compute  spares_needed.
3.Analyse_changes() delta_parity concept doesn't match information currently metadata reports. Result of this is wrongly computed reshape.after.data_disks field.
  Resolution: do not use delta_parity, base on information from metadata handle
4.Defects/potential defects
 a.delta_disks should be checked in sysfs_set_array()
 b.array assembly problem
reshape_active flag has to be evaluated. Existing second map doesn't means reshape always (rebuild, initialization)

I've tried to follow your idea in this series. Generally it seems ok (proved by UT). I like putting more array configuration in sysfs_set_array().

Now I'm going to look at patches at the reshape restart point of view.
I'll let you know results soon.

BR
Adam


---

Adam Kwolek (5):
      FIX: Compute spares_needed basing on metadata info
      FIX: Remove delta_parity concept
      FIX: Allow for takeover
      FIX: Set new raid disks when delta_disks is valid
      fix: array is reassembled inactive if stopped during resync


 Grow.c        |   22 +++++-----------------
 super-intel.c |    5 +++--
 sysfs.c       |    4 +++-
 3 files changed, 11 insertions(+), 20 deletions(-)

-- 
Signature
