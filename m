From: Jes.Sorensen@redhat.com
Subject: [PATCH 00/11] Various cleanups and minor fixes
Date: Tue, 20 Mar 2012 17:54:05 +0100
Message-ID: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This patch set implements a number of smaller cleanups, as well as
fixing a couple of cases where we don't zero out the full buffer we
just obtained via malloc.

The most controversial is probably patch 06 which caches the device
block size for aligned read/writes in super1.c to avoid calling the
ioctl() on each write.

I also introduced some generalized ROUND_UP macros to avoid the manual
pointer and size manipulation in various places.

The ddf code I am unable to test as I don't have any raids with ddf
layout, but it does compile.

Cheers,
Jes


Jes Sorensen (11):
  super1.c don't keep recalculating bitmap pointer
  Define and use SUPER1_SIZE for allocations
  init_super1() memset full buffer allocated for superblock
  match_metadata_desc1(): Use calloc instead of malloc+memset
  Use 4K buffer alignment for superblock allocations
  Use struct align_fd to cache fd's block size for aligned reads/writes
  match_metadata_desc0(): Use calloc instead of malloc+memset
  Generalize ROUND_UP() macro and introduce matching ROUND_UP_PTR()
  super1.c: use ROUND_UP/ROUND_UP_PTR
  super-intel.c: Use ROUND_UP() instead of manually coding it
  __write_init_super_ddf(): Use posix_memalign() instead of static
    aligned buffer

 mdadm.h       |    8 ++--
 super-ddf.c   |   19 ++++++----
 super-intel.c |    2 +-
 super0.c      |    6 ++--
 super1.c      |  111 +++++++++++++++++++++++++++++++++++----------------------
 5 files changed, 87 insertions(+), 59 deletions(-)

-- 
1.7.7.6

