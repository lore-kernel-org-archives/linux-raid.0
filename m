From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 0/5] Don't combine disks with different sector size in the array
Date: Tue,  9 May 2017 12:25:42 +0200
Message-ID: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

IMSM doesn't allow to create arrays including drives with different sector
sizes.

Following patchset blocks all paths to create such configuration:
 * explicit array create
 * array rebuild (spare in the same container, spare moved across containers)
 * array grow

Alexey Obitotskiy (5):
  imsm: allow drives in a container regardless of sector size
  imsm: allocate buffer to support maximum sector size
  imsm: don't allow disks with different sector size in one array
  Allow more spare selection criteria
  Add sector size as spare selection criterion

 Incremental.c | 18 ++++++++-----
 Monitor.c     | 38 ++++++++++++++++----------
 mdadm.h       | 19 +++++++++----
 super-intel.c | 86 ++++++++++++++++++++++++++++++++++++++++-------------------
 util.c        | 37 ++++++++++++++++++++++---
 5 files changed, 140 insertions(+), 58 deletions(-)

-- 
1.8.3.1

