From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 0/3] Make dlm lock more reliable for cluster-md
Date: Wed, 13 Dec 2017 10:00:37 +0800
Message-ID: <20171213020040.3603-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Currently, only a few functions which change superblock are protected
by dlm lock, but to avoid consistent issue we need to protect those
funcs which read superblock.

And call dlm locking interface inside super1.c is really clumsy since
each func which accesses superblock should be protected by dlm lock,
so we call lock_cluster/unlock_cluster in mdadm.c.

The first patch provides dlm locking support for CREATE, MANAGE, GROW
and INCREMENTAL mode, then the second patch provides the support for
ASSEMBLE mode. The last patch cleanup the failure path in Assemble().

Thanks,
Guoqing

Guoqing Jiang (3):
  mdadm: improve the dlm locking mechanism for clustered raid
  Assemble: provide protection when clustered raid do assemble
  Assemble: cleanup the failure path

 Assemble.c | 82 ++++++++++++++++++++++++++++++++++++--------------------------
 mdadm.c    | 20 +++++++++++++++
 mdadm.h    |  8 +++---
 super1.c   | 42 --------------------------------
 util.c     | 65 +++++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 128 insertions(+), 89 deletions(-)

-- 
2.13.6

