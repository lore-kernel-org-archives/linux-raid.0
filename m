From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/8] mdadm static checker fixes
Date: Tue,  8 Mar 2016 12:30:44 -0500
Message-ID: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I have been running mdadm through Coverity and fixed a number of
issues that were raised in the scan. A couple of them were non issues
related to conditions where we know for sure the kernel will not
return strings longer than a given size, but there were also a number
of potential memory leaks and buffer overflows.

These patches are sitting in my pending queue. If you are on the CC
list, would you mind having a look at the portions touching code you
previously pushed wrote.

Please hollor if you notice I did anything wrong, otherwise I'll push
this set into git within the next couple of days.

Cheers,
Jes


Jes Sorensen (8):
  Manage: Manage_add(): Fix memory leak
  load_sys(): Add a buffer size argument
  Grow: Grow_continue_command() remove dead code
  Grow: Grow_addbitmap(): Add check to quiet down static code checkers
  {platform,super}-intel: Fix two resource leaks
  bitmap: Fix resource leak in bitmap_file_open()
  Manage: Manage_subdevs() fix file descriptor leak
  super1: Fix potential buffer overflows when copying cluster_name

 Detail.c         |  2 +-
 Grow.c           | 11 ++++++++---
 Manage.c         |  8 ++++++--
 bitmap.c         |  1 +
 mdadm.h          |  2 +-
 platform-intel.c |  7 ++++++-
 super-intel.c    | 12 ++++++++----
 super1.c         | 18 ++++++++++++------
 sysfs.c          | 47 ++++++++++++++++++++++++-----------------------
 9 files changed, 67 insertions(+), 41 deletions(-)

-- 
2.5.0

