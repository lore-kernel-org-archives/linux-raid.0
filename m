From: Jes.Sorensen@redhat.com
Subject: [PATCH 00/11] Memory/resource leaks and unchecked return fixes
Date: Mon, 31 Oct 2011 15:02:28 +0100
Message-ID: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is another pile of patches to fixup memory leaks and buffer
overflows found in the coverity run. 

Cheers,
Jes


Jes Sorensen (11):
  Fix memory leaks in reshape_array()
  Fix memory leak
  Fix memory leak
  Fix memory leak of 'st3' in array_try_spare()
  partition_try_spare() use closedir() to release DIR * returned by
    opendir()
  Fix memory leak
  Add missing return in case of trying to grow sub-array
  Avoid memory leak
  policy_add(): Add missing va_end()
  Write_rules(): Avoid stack corruption if using extremely long udev
    pathname
  mdmon(): Error out if failing to connect to victim monitor

 Assemble.c    |    1 +
 Detail.c      |    1 +
 Grow.c        |   16 ++++++++++++++--
 Incremental.c |    6 +++++-
 mdmon.c       |    8 +++++++-
 policy.c      |    4 +++-
 super-gpt.c   |    4 +++-
 super-intel.c |    1 +
 8 files changed, 35 insertions(+), 6 deletions(-)

-- 
1.7.6.4

