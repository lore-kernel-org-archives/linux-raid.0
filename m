From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 0/3] Make dlm lock more reliable for cluster-md
Date: Wed,  3 Jan 2018 16:19:08 +0800
Message-ID: <20180103081911.7380-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

For V2, there are some change in the first patch.

1. confirm a device in slave node doen't need to get lock.
2. remove the explicitly name of dlm library.
3. delete a global variable which was used for store lockid.

However, I am not able to simplify the checks before call lock_cluster
in the first patch ...

Thanks,
Guoqing
---------------------------------------------------------------------
Currently, only a few functions which change superblock are protected
by dlm lock, but to avoid consistent issue we need to protect those
funcs which read superblock.

And call dlm locking interface inside super1.c is really clumsy since
each func which accesses superblock should be protected by dlm lock,
so we call lock_cluster/unlock_cluster in mdadm.c.

The first patch provides dlm locking support for CREATE, MANAGE, GROW
and INCREMENTAL mode, then the second patch provides the support for
ASSEMBLE mode. The last patch cleanup the failure path in Assemble().

Guoqing Jiang (3):
  mdadm: improve the dlm locking mechanism for clustered raid
  Assemble: provide protection when clustered raid do assemble
  Assemble: cleanup the failure path

 Assemble.c | 82 ++++++++++++++++++++++++++++++++++++--------------------------
 mdadm.c    | 20 +++++++++++++++
 mdadm.h    | 12 +++++----
 super1.c   | 42 --------------------------------
 util.c     | 73 +++++++++++++++++++++++++++++++++++++++++++++----------
 5 files changed, 135 insertions(+), 94 deletions(-)

-- 
2.13.6

