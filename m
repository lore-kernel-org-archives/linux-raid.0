From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/4] integrated stat and fstat into utility functions
Date: Sat,  1 Apr 2017 20:51:41 +0800
Message-ID: <20170401125145.14440-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

hi, Jes;

This patches focus on integrating stat and fstat operations, move the
duplicated codes into one utility function, and also fixed one bug in
waitclean(), it forgot to check the block device.

Thanks,
Zhilong

Zhilong Liu (4):
  mdadm/util:integrate stat operations into one utility
  mdadm/util:integrate fstat operations into one utility function
  mdadm/Create:declaring an existing struct within same function
  mdadm/Monitor:check the block device when use waitclean parameter

 Assemble.c    | 15 ++++-----------
 Build.c       | 21 +++------------------
 Create.c      | 17 +++++++----------
 Grow.c        |  4 +---
 Incremental.c | 25 ++-----------------------
 Manage.c      | 10 ++--------
 Monitor.c     |  2 ++
 bitmap.c      | 12 ++++--------
 mdadm.h       |  2 ++
 super-intel.c | 14 +++-----------
 util.c        | 30 ++++++++++++++++++++++++++++++
 11 files changed, 60 insertions(+), 92 deletions(-)

-- 
2.10.2

