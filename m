From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH 0/2] imsm: add extra handling of sync_action and sync_completed
Date: Thu, 16 Jun 2016 11:31:35 +0200
Message-ID: <1466069497-29503-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patchset fixes issues with IMSM reshape completion
or interruption. 
After sync completion sync_action set to 'idle' and must be treated 
as normal wait_for_reshape_imsm termination. During sync or after 
sync finished sync_completed can be set to 'disabled' or 'none' and 
must be handled respectively.

Alexey Obitotskiy (2):
  imsm: add handling of sync_action is equal to 'idle'
  imsm: properly handle values of sync_completed

 super-intel.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

-- 
2.7.4

