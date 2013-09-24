From: mwilck@arcor.de
Subject: [PATCH 0/2] Fix mdadm --add for LSI fake RAID
Date: Tue, 24 Sep 2013 19:18:50 +0200
Message-ID: <1380043132-8099-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

These patches hopefully solve the problem reported by
Francis Moreau in the thread "mdadm 3.3 fails to kick out non
fresh disk": A disk set failed and removed from a LSI DDF fake 
RAID can't be re-added any more.

Martin Wilck (2):
  DDF: add_to_super_ddf: leave invalid secondary_lba untouched
  DDF: add_to_super_ddf: be careful with workspace_lba

 super-ddf.c |   32 +++++++++++++++++++++++++++++---
 1 files changed, 29 insertions(+), 3 deletions(-)

-- 
1.7.3.4
