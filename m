From: mwilck@arcor.de
Subject: Fixes for DDF test case (race conditions in mdmon)
Date: Mon, 25 Mar 2013 23:10:58 +0000 (UTC)
Message-ID: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:31 +0200
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is a series of patches to fix the DDF tests case(tests/10ddf-create).

Patch 3 fixes a problem that was implicitly introduced by commit 
c1ea5a98 - "mdadm -Db" would now print UUIDs for subarrays, but the
wrong ones.

Patch 5-7 are the interesting part. The DDF test case kept failing for
me right there where a comment already says "# This failed once. 
The raid5 was resyncing". I tracked this down to race conditions
between mdmon and the kernel when arrays are stopped - the kernel
cleans up in sysfs and reading the attributes from there is unreliable.
Files may have already vanished, read() may fail or even succeed
with incorrect results.

The other patches are hopefully self-explaining.

Regards
Martin

Martin Wilck (8):
  DDF: __write_ddf_structure: Fix wrong reference to ddf->primary
  DDF: __write_init_super_ddf: just use seq number of active header
  DDF: brief_detail_super_ddf: print correct UUID for subarrays
  DDF: add code to debug state changes
  monitor: don't call pselect() on deleted sysfs files
  monitor: read_and_act: handle race conditions for resync_start
  monitor: treat unreadable array_state as clean
  tests/10ddf-create: omit log output check

 monitor.c          |   38 ++++++++++++----
 super-ddf.c        |  124 ++++++++++++++++++++++++++++++++++++++-------------
 tests/10ddf-create |    6 +--
 3 files changed, 121 insertions(+), 47 deletions(-)
