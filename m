From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 0/5] Level and chunk size migrations for imsm
Date: Mon, 14 Feb 2011 14:12:41 +0100
Message-ID: <20110214130213.8540.57401.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

The following series implements raid level (5<->0) and chunk size migrations.

Comparing to last patches you are looking at, there are the following differences:
1. Chunk size migrations added
2. Selecting spare device for raid0->raid5 migration is moved to mdmon (prepare_update())
        mdadm re-reads metadata for adding spares so sysfs-mdmon configuration is consistent
	mdadm puts migration parameters in update only:
		- new new level
		- new chunk size

The first patch in series addresses problem for raid5 -> raid0 migration when raid_disks sysfs
entry was set with too small value (value has to be large enough to allow takeover to raid0
at reshape end)

After this series mdadm passes unit tests suites: 12, 13, 14, 15, 16, 18 
(test 18imsm-r1_2d-takeover-r0_1d requires latest changes for raid1->raid0 takeover in md)

BR
Adam


---

Adam Kwolek (5):
      imsm: Add chunk size to metadata update
      imsm: process update for raid level migrations
      imsm: prepare memory for level migration update
      imsm: prepare update for level migrations reshape
      FIX: set delta_disks to 0 for raid5->raid0 transition


 Grow.c        |    1 
 super-intel.c |  343 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 341 insertions(+), 3 deletions(-)

-- 
Signature
