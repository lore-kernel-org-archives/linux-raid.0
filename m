From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1 0/2] unify stat and fstat checking blkdev into functions
Date: Thu,  4 May 2017 20:16:20 +0800
Message-ID: <20170504121622.4014-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;

This two patches declared two functions named fstat_is_blkdev()
and stat_is_blkdev() to integrate repeated checking block device
operations, decreased the repeated codes via to utility function.
And fix a bug in WaitClean(), it forgot to check block device.

This patchset depends on patchset
"[mdadm PATCH 0/2] unify stat and fstat into functions"

Changes:
 - modified the return value of them, return true/1 if it is a
   block device, return false/0 when it isn't.
 - rename the functions and make their name shorter.

Thanks,
Zhilong

Zhilong Liu (2):
  util: unify fstat checking blkdev into function
  util: unify stat checking blkdev into function

 Assemble.c    | 26 +++++++++-----------------
 Build.c       | 30 +++++++-----------------------
 Create.c      | 23 ++++++++++-------------
 Grow.c        | 10 ++++------
 Incremental.c | 52 +++++++++++++++-------------------------------------
 Manage.c      | 13 ++-----------
 Monitor.c     | 16 ++++------------
 bitmap.c      | 13 ++++---------
 mdadm.h       |  2 ++
 super-ddf.c   | 10 ++++------
 super-intel.c | 23 +++++++----------------
 util.c        | 34 ++++++++++++++++++++++++++++++++++
 12 files changed, 102 insertions(+), 150 deletions(-)

-- 
2.10.2

