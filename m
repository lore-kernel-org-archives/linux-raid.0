From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Reduce unnecessary opens of raid members
Date: Thu, 11 Apr 2013 15:18:32 +0200
Message-ID: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: harald@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I am posting this on Harald's request. This avoids unncessary double
opens of raid members and also has the side effect of not triggering
udev notify twice.

Jes


Harald Hoyer (1):
  prevent double open(O_RDWR) on raid creation

 Kill.c        | 28 +++++++++++++++++-----------
 Manage.c      |  2 +-
 mdadm.c       |  4 ++--
 mdadm.h       |  2 +-
 super-ddf.c   |  2 +-
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      |  2 +-
 8 files changed, 25 insertions(+), 19 deletions(-)

-- 
1.8.1.4

