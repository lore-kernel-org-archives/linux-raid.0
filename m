From: Zhilong Liu <zlliu@suse.com>
Subject: [mdadm PATCH 0/2] unify stat and fstat into functions
Date: Tue,  2 May 2017 11:26:44 +0800
Message-ID: <20170502032646.20220-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;

This two patches mainly unified the stat and fstat operations,
declare new function for them and decrease the repeated codes.
Also fix one bug in WaitClean(), it forgot to check the block
device.

Thanks,
Zhilong

Zhilong Liu (2):
  util: unify fstat operations into function
  util: unify stat operations into function

 Assemble.c    | 24 +++++++-----------------
 Build.c       | 30 +++++++-----------------------
 Create.c      | 23 ++++++++++-------------
 Grow.c        | 10 ++++------
 Incremental.c | 52 +++++++++++++++-------------------------------------
 Manage.c      | 13 ++-----------
 Monitor.c     | 16 ++++------------
 bitmap.c      | 10 +---------
 mdadm.h       |  2 ++
 super-ddf.c   | 10 ++++------
 super-intel.c | 23 +++++++----------------
 util.c        | 34 ++++++++++++++++++++++++++++++++++
 12 files changed, 97 insertions(+), 150 deletions(-)

-- 
2.10.2

