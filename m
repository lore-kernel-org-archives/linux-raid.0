From: gqjiang@suse.com
Subject: [PATCH V2 00/11] mdadm tool: add the support for cluster-md
Date: Fri,  8 May 2015 16:50:18 +0800
Message-ID: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Compared to previous version:
1. re-arrange the squence of patches
2. add some memembers into sb_le_to_cpu
3. handle some logic change and comments from Neil

Basic background for Cluster MD: Cluster MD is a shared-device RAID for a
cluster, currently, the implementation is limited to RAID1 but with further
work (and some positive feedback), it could be extend to other RAID levels.

The kernel part code of cluster-md has been sent to maillist several month
ago by Goldywyn, and to make cluster-md works, the mdadm tools also need to
do some changes accordingly.

This patch set extends mdadm tool to aware cluster MD scenario, and handle
related cluster-md scenario.

1. the first part (0001-0007) comes from Goldwyn, which add initial
support for cluster-md, those changes included make mdadm awares nodes,
home-cluster and n bitmaps for clustered mode, also let mdadm can 
confirm disk which is added by another node.


2. the second part is for support change cluster-name and node nums under
assemble mode. Which extend write-bitmap to handle above cases, and also
use the extended write_bitmap for update uuid. [PATCH V2 10/10] is just compiled
test only.

BTW: this series is based on commit "72a457 IMSM: Count arrays per orom".

Some reltated links:
[1] http://marc.info/?l=linux-raid&m=141891941330336&w=2
[2] http://marc.info/?l=linux-raid&m=141935561418770&w=2

Guoqing Jiang (11):
  Create n bitmaps for clustered mode
  Add nodes option while creating md
  home-cluster while creating an array
  Show all bitmaps while examining bitmap
  Add a new clustered disk
  Convert a bitmap=none device to clustered
  Skip clustered devices in incremental
  mdadm: add the ability to change cluster name
  mdadm: change the num of cluster node
  Reuse calc_bitmap_size to reduce code size
  Reuse the write_bitmap for update uuid

 Assemble.c    |  14 ++++--
 Create.c      |   5 +-
 Grow.c        |  22 +++++++--
 Incremental.c |   5 ++
 Makefile      |   1 +
 Manage.c      |  33 +++++++++++--
 ReadMe.c      |   3 ++
 bitmap.c      |  94 ++++++++++++++++++++++---------------
 bitmap.h      |   7 ++-
 config.c      |  27 ++++++++++-
 md_p.h        |   7 +++
 md_u.h        |   1 +
 mdadm.8.in    |  28 ++++++++++-
 mdadm.c       |  69 ++++++++++++++++++++++++++-
 mdadm.h       |  20 +++++++-
 super0.c      |   4 +-
 super1.c      | 147 +++++++++++++++++++++++++++++++++++++++++++++++-----------
 util.c        |  60 ++++++++++++++++++++++++
 18 files changed, 461 insertions(+), 86 deletions(-)

-- 
1.7.12.4

