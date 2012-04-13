From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 00/14] imsm: volume expand
Date: Fri, 13 Apr 2012 16:51:54 +0200
Message-ID: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

This patch series introduces the possibility to increase volume size using
existing free space in container without adding spare disks to imsm metadata.

Adam Kwolek (14):
  imsm: FIX: Update function imsm_num_data_members() for Raid1/10
  imsm: FIX: Add volume size expand support to imsm_analyze_change()
  imsm: Add new metadata update for volume size expansion
  imsm: Execute size change for external metatdata
  FIX: Support metadata changes rollback
  imsm: FIX: Support metadata changes rollback
  FIX: Extend size of raid0 array
  FIX: Respect metadata size limitations
  FIX: Detect error and rollback metadata
  imsm: Add function imsm_get_free_size()
  imsm: Support setting max size for size change operation
  imsm: FIX: Component size alignment check
  FIX: Size change is possible as standalone change only
  FIX: Assembled second array is in read only state during reshape

 Assemble.c    |   29 ++++--
 Grow.c        |  163 ++++++++++++++++++++++-------
 mdadm.h       |    4 +
 super-intel.c |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 438 insertions(+), 76 deletions(-)

