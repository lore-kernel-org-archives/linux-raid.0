From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] Solve problem adding internal bitmaps to 1.0 arrays
Date: Thu, 26 Apr 2012 17:12:55 +0200
Message-ID: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This set solves the problem with adding internal bitmaps to 1.0
arrays. Basically there were two problems, one the sign extension from
u32 to long was done incorrectly, and second we also tried to convert
it to an 'unsigned long long' when passing it to the kernel.

With these two applied I can succesfully add bitmaps to 1.0 arrays.

Please hollor if you see any problems with this patchset.

Cheers,
Jes

Jes Sorensen (2):
  Fix sign extension of bitmap_offset in super1.c
  Introduce sysfs_set_num_signed() and use it to set bitmap/offset

 Grow.c   |    4 ++--
 mdadm.h  |    2 ++
 super1.c |    4 ++--
 sysfs.c  |    8 ++++++++
 4 files changed, 14 insertions(+), 4 deletions(-)

-- 
1.7.7.6

