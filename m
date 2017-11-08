From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 0/2] md: memleak fixes
Date: Wed,  8 Nov 2017 13:44:54 +0100
Message-ID: <cover.1510144853.git.zkabelac@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zdenek Kabelac <zkabelac@redhat.com>
List-Id: linux-raid.ids

Patchset tries to address several kmeleaks visible when lvm2 is using
raid target based on md-core.

1st. patch as quite easy to validate
2nd. please do careful review as bitmap.c is hard to follow

Zdenek Kabelac (2):
  md: release allocated bitset sync_set
  md: free unused memory after bitmap resize

 drivers/md/bitmap.c | 9 +++++++++
 drivers/md/md.c     | 8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

-- 
2.15.0

